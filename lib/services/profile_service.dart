import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show
        FileOptions,
        PostgrestException,
        StorageException,
        Supabase,
        SupabaseClient;

import '../models/profile_model.dart';
import '../supabase_options.dart';

/// خطأ في خدمة الملف الشخصي برسالة عربية مفهومة.
///
/// لا تُعرض أبدًا أي رسالة خام صادرة من Firebase أو Supabase؛ وكل رسالة
/// هنا تدلّ على مرحلة الفشل الحقيقية (جلسة/مزامنة/قاعدة/تخزين/شبكة).
class ProfileFailure implements Exception {
  const ProfileFailure(this.message);

  /// الرسالة التي تظهر للمستخدم.
  final String message;

  @override
  String toString() => message;
}

/// المصدر الوحيد لعمليات الملف الشخصي في التطبيق.
///
/// المعمارية المعتمدة: Firebase وحيدًا مصدر المصادقة والهوية، و`profiles.id`
/// = معرّف Firebase (UID) حرفيًا. Supabase قاعدة وتخزين فقط — **لا توجد أي
/// جلسة Supabase Auth**. التوكن يأتي من Edge Function `firebase-session`
/// التي تتحقق من هوية Firebase ثم تُصدّر JWT حاملًا `sub` = Firebase UID
/// (وضع التوكيل الخارجي الرسمي — `Supabase.initialize(accessToken:)`).
///
/// قواعد أمنية مطبّقة هنا:
/// - لا تُخزَّن أي كلمة مرور في `profiles` (البريد من Firebase فقط).
/// - لا يُستخدم أي مفتاح service-role — المفاتيح العامة للعميل فقط.
/// - كل استعلام مقيّد بمعرّف المستخدم الحالي، وRLS هو حارس القاعدة.
/// - كل مسار شبكة له مهلة قصوى حتى يصل إلى حالة نهائية (لا دوران أبدي).
class ProfileService {
  ProfileService._();

  static final ProfileService instance = ProfileService._();

  /// مهلة أقصى لكل خطوة شبكة: تضمن وصول كل `await` إلى نهاية فيُنفَّذ
  /// `finally` دائمًا — العلاج الجذري لدوران التحميل الأبدي.
  static const Duration _requestTimeout = Duration(seconds: 20);

  /// JWT الموقّع للعميل + تاريخ انتهائه (يُصدَّر جديد قبل كل انتهاء).
  String? _supabaseJwt;
  DateTime _jwtExpiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  Future<void>? _mintInFlight;

  /// آخر مستخدم تمت مزامنته بنجاح (null = لم تتم أو فشلت).
  String? _syncedUid;
  Future<void>? _syncInFlight;

  /// سبب فشل الحصول على JWT (مرحلة الجلسة) — يُعرض هو بدل رسائل RLS المضلّلة.
  String? _tokenStageError;

  /// آخر خطأ في المزامنة بمرحلته (null = نجحت أو لم تبدأ).
  String? _lastSyncError;

  /// آخر خطأ في المزامنة بمرحلته (مرئي للتشخيص، وتُستخدم في التحميل).
  String? get lastSyncError => _lastSyncError;

  SupabaseClient get _client {
    if (!Supabase.instance.isInitialized) {
      throw const ProfileFailure(
        'خدمة الملف الشخصي غير مهيأة، أعد تشغيل التطبيق.',
      );
    }
    return Supabase.instance.client;
  }

  // ---------------------------------------------------------------------------
  // مستمع حالة Firebase (استعادة الجلسة عند إعادة التشغيل + تفريغ الخروج)
  // ---------------------------------------------------------------------------

  StreamSubscription<User?>? _authSubscription;

  /// يُستدعى مرة واحدة من `main()` بعد تهيئة Supabase:
  /// - وصول مستخدم (استعادة جلسة بعد إعادة التشغيل) → مزامنة idempotent.
  /// - خروج (null) → تفريغ الذاكرة المؤقتة فقط (لا يُحذف أي صف في القاعدة).
  void startAuthListener() {
    if (_authSubscription != null) return;
    try {
      _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
        User? user,
      ) {
        if (user == null) {
          unawaited(clearSession());
        } else {
          unawaited(syncAfterFirebaseAuth());
        }
      });
    } catch (e) {
      // Firebase غير مهيّأ (بيئة اختبار) — ليست حالة خطأ قاتلة.
      debugPrint('ProfileService[stage:listener]: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // جلسة Supabase الموحّدة: JWT من Edge Function (لا Supabase Auth إطلاقًا)
  // ---------------------------------------------------------------------------

  /// مزوّد `accessToken` لـ `Supabase.initialize` (third-party auth):
  /// يُعيد JWT موقّعًا للمستخدم الحالي، أو `null` عند غياب مستخدم Firebase
  /// (تذهب الطلبات حينها بدورها مجهولة ويرفضها RLS كما يجب).
  ///
  /// لا ترمي أبدًا: أي فشل يُسجَّل بمرحلته في [_tokenStageError] وتُعاد
  /// `null` — وستظهر رسالة المرحلة الصحيحة عند أول استعلام قاعدة.
  Future<String?> accessTokenForSupabase() async {
    final User? user = _currentUserOrNull();
    if (user == null) {
      _clearJwt();
      return null;
    }
    if (_supabaseJwt != null && DateTime.now().isBefore(_jwtExpiresAt)) {
      return _supabaseJwt; // مسار شائع: توكن سارٍ بلا أي شبكة.
    }
    try {
      await _mintJwt(user);
      return _supabaseJwt;
    } on ProfileFailure catch (e) {
      _tokenStageError = e.message;
      debugPrint('ProfileService[stage:token]: ${e.message}');
      return null;
    } on TimeoutException {
      _tokenStageError = 'انتهت مهلة الاتصال بخدمة جلسة الملف الشخصي.';
      debugPrint('ProfileService[stage:token]: timeout');
      return null;
    } on SocketException {
      _tokenStageError = 'تعذّر الاتصال بالشبكة للحصول على جلسة الملف الشخصي.';
      debugPrint('ProfileService[stage:token]: socket');
      return null;
    } catch (e) {
      _tokenStageError =
          'تعذّر الاتصال بخدمة جلسة الملف الشخصي، تحقّق من اتصالك بالإنترنت.';
      debugPrint('ProfileService[stage:token]: $e');
      return null;
    }
  }

  Future<void> _mintJwt(User user) {
    final Future<void>? inFlight = _mintInFlight;
    if (inFlight != null) return inFlight;
    final Future<void> future = _doMintJwt(user);
    _mintInFlight = future;
    return future.whenComplete(() => _mintInFlight = null);
  }

  Future<void> _doMintJwt(User user) async {
    // 1) توكن Firebase — إثبات الهوية الوحيد الذي يغادر التطبيق.
    final String? idToken = await user.getIdToken().timeout(_requestTimeout);
    if (idToken == null || idToken.isEmpty) {
      throw const ProfileFailure(
        'تعذّر الحصول على بيانات الدخول، سجّل الخروج ثم أعد الدخول.',
      );
    }

    // 2) استدعاء Edge Function: تتحقق من التوكن وتُصدّر JWT بـ sub = UID.
    final Uri uri = Uri.parse(
      '${SupabaseOptions.projectUrl}/functions/v1/firebase-session',
    );
    final HttpClient http = HttpClient()..connectionTimeout = _requestTimeout;
    try {
      final HttpClientRequest request = await http
          .postUrl(uri)
          .timeout(_requestTimeout);
      request.headers
        ..contentType = ContentType.json
        ..set('apikey', SupabaseOptions.publishableKey)
        ..set('Authorization', 'Bearer $idToken');
      request.write('{}');
      final HttpClientResponse response = await request
          .close()
          .timeout(_requestTimeout);
      final String body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_requestTimeout);

      if (response.statusCode != HttpStatus.ok) {
        throw ProfileFailure(_mintMessage(response.statusCode));
      }
      final Object? decoded = jsonDecode(body);
      final String token = decoded is Map<String, dynamic>
          ? '${decoded['token'] ?? ''}'
          : '';
      if (token.isEmpty) {
        throw const ProfileFailure(
          'رد غير متوقع من خدمة جلسة الملف الشخصي، حاول لاحقًا.',
        );
      }
      _supabaseJwt = token;
      _jwtExpiresAt =
          _expOf(token) ?? DateTime.now().add(const Duration(minutes: 50));
      _tokenStageError = null;
    } finally {
      http.close(force: true);
    }
  }

  /// رسالة عربية تدلّ على مرحلة فشل خدمة الجلسة (لا نص خام من الخادم).
  String _mintMessage(int status) {
    switch (status) {
      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        return 'تعذّر التحقق من هوية الدخول، سجّل الخروج ثم أعد الدخول.';
      case HttpStatus.notFound:
        return 'خدمة مزامنة الجلسة غير منشورة على الخادم، تواصل مع مطوّر التطبيق.';
      case HttpStatus.tooManyRequests:
        return 'عدد كبير من المحاولات، حاول بعد قليل.';
      default:
        if (status >= 500) {
          return 'تعذّر تجهيز جلسة الملف الشخصي على الخادم (إعدادات غير مكتملة)، تواصل مع مطوّر التطبيق.';
        }
        return 'تعذّر الاتصال بخدمة جلسة الملف الشخصي، حاول مرة أخرى.';
    }
  }

  DateTime? _expOf(String jwt) {
    try {
      final List<String> parts = jwt.split('.');
      if (parts.length < 2) return null;
      final String payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final Object? claims = jsonDecode(payload);
      final Object? exp = claims is Map<String, dynamic> ? claims['exp'] : null;
      if (exp is num) {
        return DateTime.fromMillisecondsSinceEpoch(
          (exp * 1000).round(),
        ).subtract(const Duration(seconds: 60)); // هامش تجديد مبكر.
      }
      return null;
    } catch (_) {
      return null; // فشل قراءة exp = تجديد احتيالي قريب (آمن).
    }
  }

  // ---------------------------------------------------------------------------
  // طبقة المزامنة: Firebase UID ← صف profiles (idempotent، بلا صلاحية خادمية)
  // ---------------------------------------------------------------------------

  /// تُستدعى بعد كل نجاح Firebase (تسجيل/دخول بريد، Google، فيسبوك، بصمة)
  /// وبعد استعادة الجلسة: **لا ترمي أبدًا**، وتسجّل أي فشل بمرحلته في
  /// [lastSyncError] ليعرضه تحميل الملف حين يطلب المستخدم بياناته.
  Future<void> syncAfterFirebaseAuth() {
    final Future<void>? inFlight = _syncInFlight;
    if (inFlight != null) return inFlight;
    final Future<void> future = _performSync();
    _syncInFlight = future;
    return future.whenComplete(() => _syncInFlight = null);
  }

  Future<void> _performSync() async {
    final User? user = _currentUserOrNull();
    if (user == null) {
      _lastSyncError = 'لا يوجد مستخدم موثّق لمزامنة الملف الشخصي.';
      return;
    }
    if (_syncedUid == user.uid) return; // مُزامَن بالفعل لهذا المستخدم
    try {
      await _syncUser(user);
      _syncedUid = user.uid;
      _lastSyncError = null;
      debugPrint('ProfileService: profile synced for ${user.uid}');
    } on ProfileFailure catch (e) {
      _syncedUid = null;
      _lastSyncError = e.message;
      debugPrint('ProfileService[stage:sync]: ${e.message}');
    } on TimeoutException {
      _syncedUid = null;
      _lastSyncError = 'انتهت مهلة الاتصال بقاعدة بيانات الملف الشخصي.';
      debugPrint('ProfileService[stage:sync]: timeout');
    } on PostgrestException catch (e) {
      _syncedUid = null;
      _lastSyncError = _postgrestMessage(e);
      debugPrint('ProfileService[stage:sync/db]: $e');
    } catch (e) {
      _syncedUid = null;
      _lastSyncError = _tokenStageError ?? _networkDbMessage;
      debugPrint('ProfileService[stage:sync]: $e');
    }
  }

  Future<void> _syncUser(User user) async {
    // 1) JWT أولًا: فشله يُوقف المزامنة برسالة مرحلة الجلسة الحقيقية.
    await accessTokenForSupabase();
    if (_tokenStageError != null) {
      throw ProfileFailure(_tokenStageError!);
    }
    final SupabaseClient client = _client;

    // 2) هل الصف موجود؟
    final Map<String, dynamic>? existing = await client
        .from('profiles')
        .select()
        .eq('id', user.uid)
        .maybeSingle()
        .timeout(_requestTimeout);

    if (existing != null) {
      // الملف موجود: البريد وحده يُحدَّث من Firebase (مرجعية البريد =
      // Firebase) — ولا نمسّ الاسم/الهاتف لأنهما تعديلات صنعها المستخدم.
      final String? storedEmail = existing['email']?.toString();
      final String firebaseEmail = user.email ?? '';
      if (firebaseEmail.isNotEmpty && storedEmail != firebaseEmail) {
        await client
            .from('profiles')
            .update({'email': firebaseEmail})
            .eq('id', user.uid)
            .timeout(_requestTimeout);
      }
      return;
    }

    // 3) صف مفقود: إنشاؤه idempotent بمعرّف Firebase نفسه (upsert على
    //    المعرّف يمنع التكرار في أي إعادة دخول) — لا يُنشئ حساب Supabase.
    await client
        .from('profiles')
        .upsert(<String, dynamic>{
          'id': user.uid,
          'email': user.email,
          'full_name': (user.displayName ?? '').trim(),
          'phone': user.phoneNumber,
        }, onConflict: 'id')
        .timeout(_requestTimeout);
  }

  /// تضمن مزامنة هذا المستخدم قبل أي قراءة/كتابة، وترمي [ProfileFailure]
  /// بمرحلتها الحقيقية عند الفشل (مسارات يشترط فيها وجود الملف).
  Future<void> _requireSync(User user) async {
    if (_syncedUid == user.uid) return;
    await syncAfterFirebaseAuth(); // لا ترمي أبدًا
    if (_syncedUid == user.uid) return;
    throw ProfileFailure(
      _lastSyncError ?? 'تعذّرت مزامنة الملف الشخصي، حاول مرة أخرى.',
    );
  }

  /// تفريغ الجلسة المؤقتة محليًا عند تسجيل الخروج — لا تُحذف أي بيانات من
  /// Supabase ولا تُلغى جلسة Firebase هنا (الخارِج يتولى ذلك)، ولا ترمي.
  Future<void> clearSession() async {
    _clearJwt();
    _syncedUid = null;
    _lastSyncError = null;
    _tokenStageError = null;
  }

  void _clearJwt() {
    _supabaseJwt = null;
    _jwtExpiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  }

  // ---------------------------------------------------------------------------
  // قراءة/كتابة الملف الشخصي (كلها مقيّدة بمعرّف Firebase الحالي + RLS)
  // ---------------------------------------------------------------------------

  Future<UserProfile> loadProfile() async {
    final User user = _requireFirebaseUser();
    await _requireSync(user); // يضمن JWT + وجود الصف (يرمي بمرحلته)
    try {
      final Map<String, dynamic>? row = await _client
          .from('profiles')
          .select()
          .eq('id', user.uid)
          .maybeSingle()
          .timeout(_requestTimeout);
      if (row != null) return UserProfile.fromMap(row);
      throw ProfileFailure(
        _tokenStageError ??
            'لم يتم العثور على الملف الشخصي، أعد تسجيل الدخول لإنشائه.',
      );
    } on ProfileFailure {
      rethrow;
    } on TimeoutException {
      throw const ProfileFailure(
        'انتهت مهلة الاتصال بقاعدة بيانات الملف الشخصي، تحقّق من اتصالك بالإنترنت.',
      );
    } on PostgrestException catch (e) {
      throw ProfileFailure(_postgrestMessage(e));
    } catch (e) {
      debugPrint('loadProfile[stage:db]: $e');
      throw ProfileFailure(_tokenStageError ?? _networkDbMessage);
    }
  }

  Future<UserProfile> updateFullName(String fullName) =>
      _updateProfile({'full_name': fullName});

  Future<UserProfile> updatePhone(String? phone) =>
      _updateProfile({'phone': phone});

  Future<UserProfile> updateAvatarUrl(String? url) =>
      _updateProfile({'avatar_url': url});

  Future<UserProfile> _updateProfile(Map<String, dynamic> patch) async {
    final User user = _requireFirebaseUser();
    await _requireSync(user);
    try {
      final Map<String, dynamic>? row = await _client
          .from('profiles')
          .update(patch)
          .eq('id', user.uid)
          .select()
          .maybeSingle()
          .timeout(_requestTimeout);
      if (row == null) {
        throw const ProfileFailure(
          'لم يتم العثور على الملف الشخصي للتعديل.',
        );
      }
      return UserProfile.fromMap(row);
    } on ProfileFailure {
      rethrow;
    } on TimeoutException {
      throw const ProfileFailure(
        'انتهت مهلة حفظ البيانات، تحقّق من اتصالك بالإنترنت وحاول مجددًا.',
      );
    } on PostgrestException catch (e) {
      throw ProfileFailure(_postgrestMessage(e));
    } catch (e) {
      debugPrint('updateProfile[stage:db]: $e');
      throw ProfileFailure(_tokenStageError ?? _networkDbMessage);
    }
  }

  // ---------------------------------------------------------------------------
  // صورة الملف الشخصي (Supabase Storage — avatars/{firebase_uid}/...)
  // ---------------------------------------------------------------------------

  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final User user = _requireFirebaseUser();
    if (bytes.isEmpty) {
      throw const ProfileFailure('الصورة المختارة غير صالحة.');
    }
    await _requireSync(user);
    final String ext = _extensionOf(fileName);
    // مسار يحدّده المستخدم نفسه: مجلد باسم معرّفه فقط (تفرضه سياسات storage).
    final String path =
        '${user.uid}/avatar_${DateTime.now().millisecondsSinceEpoch}.$ext';
    try {
      await _client.storage
          .from('avatars')
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: _mimeOf(ext), upsert: true),
          )
          .timeout(_requestTimeout);
      return _client.storage.from('avatars').getPublicUrl(path);
    } on StorageException catch (e) {
      throw ProfileFailure(_storageMessage(e));
    } on TimeoutException {
      throw const ProfileFailure(
        'انتهت مهلة رفع الصورة، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    } catch (e) {
      debugPrint('uploadAvatar[stage:storage]: $e');
      throw ProfileFailure(_tokenStageError ?? _networkStorageMessage);
    }
  }

  /// حذف ملف صورة قديم — تنظيف فقط، وفشله لا يُبطل أي عملية.
  Future<void> deleteAvatarFile(String? publicUrl) async {
    if (publicUrl == null || publicUrl.isEmpty) return;
    const String marker = '/object/public/avatars/';
    final int index = publicUrl.indexOf(marker);
    if (index < 0) return;
    String path = publicUrl.substring(index + marker.length);
    final int query = path.indexOf('?');
    if (query >= 0) path = path.substring(0, query);
    if (path.isEmpty) return;
    try {
      path = Uri.decodeComponent(path);
      await _client.storage
          .from('avatars')
          .remove([path])
          .timeout(_requestTimeout);
    } catch (e) {
      debugPrint('deleteAvatarFile[stage:storage]: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // أدوات الهوية والأخطاء
  // ---------------------------------------------------------------------------

  User? _currentUserOrNull() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null; // Firebase غير مهيّأ (بيئة اختبار) — ليست حالة خطأ.
    }
  }

  User _requireFirebaseUser() {
    final User? user = _currentUserOrNull();
    if (user == null) {
      throw const ProfileFailure(
        'لم يتم تسجيل الدخول، سجّل الدخول للوصول إلى ملفك الشخصي.',
      );
    }
    return user;
  }

  /// رسالة قاعدة بيانات عربية تدلّ على مرحلتها الحقيقية؛ وإذا كان السبب
  /// الجذري فشل JWT نعرض رسالة مرحلة الجلسة بدل رسالة RLS المضلّلة.
  String _postgrestMessage(PostgrestException e) {
    final String code = (e.code ?? '').toLowerCase();
    final String message = e.message.toLowerCase();

    final bool rlsDenied =
        code.contains('42501') ||
        message.contains('permission') ||
        message.contains('row-level');
    if (rlsDenied) {
      return _tokenStageError ??
          'صلاحيات الملف الشخصي مرفوضة، سجّل الخروج ثم أعد الدخول.';
    }
    if (code.contains('22p02') || message.contains('invalid input syntax')) {
      return 'بنية قاعدة البيانات غير محدَّثة، طبّق سكربت تحديث الملفات الشخصية (sqi_migration) في Supabase.';
    }
    if (code.contains('401') || message.contains('jwt')) {
      return 'جلسة الملف الشخصي غير صالحة، سجّل الخروج ثم أعد الدخول.';
    }
    if (code.contains('42p01') || message.contains('does not exist')) {
      return 'لم يتم إعداد قاعدة بيانات الملف الشخصي، تواصل مع الدعم.';
    }
    if (code.contains('23505')) return 'تعذّر حفظ البيانات، حاول مجددًا.';
    if (code.contains('23503')) {
      return 'تعذّر حفظ الملف الشخصي، سجّل الخروج ثم أعد الدخول.';
    }
    return _tokenStageError ?? _networkDbMessage;
  }

  String _storageMessage(StorageException e) {
    final String text = '${e.message} ${e.error ?? ''}'.toLowerCase();
    if (text.contains('row-level') ||
        text.contains('403') ||
        text.contains('unauthorized') ||
        text.contains('denied')) {
      return _tokenStageError ?? 'صلاحيات رفع الصورة مرفوضة، أعد تسجيل الدخول.';
    }
    if (text.contains('bucket')) return 'خزن صور الملف الشخصي غير مُهيأ.';
    if (text.contains('exceed') || text.contains('too large')) {
      return 'حجم الصورة كبير جدًا.';
    }
    if (text.contains('mime') || text.contains('content type')) {
      return 'نوع الصورة غير مدعوم.';
    }
    if (text.contains('401') || text.contains('jwt')) {
      return 'جلسة الملف الشخصي غير صالحة، سجّل الخروج ثم أعد الدخول.';
    }
    return _tokenStageError ?? _networkStorageMessage;
  }

  static const String _networkDbMessage =
      'تعذّر الاتصال بقاعدة بيانات الملف الشخصي، تحقّق من اتصالك بالإنترنت.';

  static const String _networkStorageMessage =
      'تعذّر الاتصال بخدمة تخزين الصور، تحقّق من اتصالك بالإنترنت.';

  String _extensionOf(String fileName) {
    final int dot = fileName.lastIndexOf('.');
    final String ext = dot >= 0
        ? fileName.substring(dot + 1).trim().toLowerCase()
        : '';
    switch (ext) {
      case 'png':
        return 'png';
      case 'webp':
        return 'webp';
      case 'heic':
        return 'heic';
      case 'heif':
        return 'heif';
      case 'gif':
        return 'gif';
      case 'jpg':
      case 'jpeg':
        return 'jpg';
      default:
        return 'jpg';
    }
  }

  String _mimeOf(String ext) {
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      case 'gif':
        return 'image/gif';
      default:
        return 'image/jpeg';
    }
  }
}
