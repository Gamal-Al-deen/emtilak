import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/app_models.dart';
import '../services/profile_service.dart';

/// يدير تحميل/تعديل الملف الشخصي ورفع الصورة وحالات التحميل/الحفظ.
///
/// كل منطق العمل هنا (خارج الView) بنفس نمط الكنترولرز الحاليين،
/// والأخطاء تُرجَع كسلاسل عربية جاهزة لـ `showAuthMessage`.
class ProfileController extends ChangeNotifier {
  final ProfileService _service = ProfileService.instance;

  UserProfile? _profile;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  /// معرّف مالك [_profile] الحالي — تُخزَّن الهوية مع الصف حتى لا يُعرض
  /// ملف حساب سابق أبدًا بعد تسجيل الخروج أو تبديل الحساب (جذر المشكلة).
  String? _loadedUid;

  /// مستمع تغيّر الهوية (خروج أو دخول حساب آخر): يُبطل ذاكرة الملف فورًا.
  StreamSubscription<User?>? _identitySubscription;

  ProfileController() {
    // نفس نمط ProfileService.startAuthListener: إن لم يكن Firebase مهيّأًا
    // (بيئة اختبار) يفشل التقاطع ولا تُبطِل أي حالة أخرى.
    try {
      _identitySubscription = FirebaseAuth.instance.authStateChanges().listen(
        (User? user) {
          final String? uid = user?.uid;
          if (uid == _loadedUid) return;
          final bool hadProfile = _profile != null;
          _profile = null;
          _loadedUid = uid;
          _error = null;
          if (uid != null) {
            unawaited(loadProfile()); // حساب جديد: حمّل صفّه فورًا
          } else if (hadProfile) {
            notifyListeners(); // خروج: أخفِ بيانات الحساب السابق فورًا
          }
        },
      );
    } catch (e) {
      debugPrint('ProfileController[identity]: $e');
    }
  }

  @override
  void dispose() {
    _identitySubscription?.cancel();
    super.dispose();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  /// آخر خطأ في التحميل (null = لا خطأ).
  String? get error => _error;

  /// الاسم المعروض: بيانات Supabase أولًا، ثم اسم Firebase، ثم بديل آمن.
  ///
  /// يتحدّث تلقائيًا عند تعديل الاسم ولا يعتمد على أي قيمة ثابتة.
  static String resolveName(UserProfile? profile, {String? fallback}) {
    final String? name = profile?.fullName.trim();
    if (name != null && name.isNotEmpty) return name;
    final String? fb = fallback?.trim();
    if (fb != null && fb.isNotEmpty) return fb;
    return 'مستخدم إمتلاك';
  }

  /// البريد المعروض: من الملف أولًا، ثم من Firebase، ثم نص بديل واضح.
  static String resolveEmail(UserProfile? profile, {String? fallback}) {
    final String? email = profile?.email?.trim();
    if (email != null && email.isNotEmpty) return email;
    final String? fb = fallback?.trim();
    if (fb != null && fb.isNotEmpty) return fb;
    return 'لم يُضاف بريد إلكتروني بعد';
  }

  /// يحمّل الملف من Supabase (يتجاهل إن كان محملًا إلا مع [force]).
  Future<void> loadProfile({bool force = false}) async {
    if (_isLoading) return;
    if (_profile != null && !force) return;

    // هوية لحظة بدء الطلب: إن تبدّل المستخدم أثناء الانتظار تُرفض النتيجة،
    // فلا يُسجَّل صف حساب سابق تحت حساب جديد (سباق التبديل).
    final String? requestUid = _currentUid;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final UserProfile loaded = await _service.loadProfile();
      if (requestUid != _currentUid) return; // تبّدل أثناء التحميل
      _profile = loaded;
      _loadedUid = requestUid;
      _error = null;
    } on ProfileFailure catch (e) {
      if (requestUid == _currentUid) _error = e.message;
    } catch (_) {
      if (requestUid == _currentUid) {
        _error = 'تعذّر تحميل الملف الشخصي، تحقّق من اتصالك بالإنترنت.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// يحفظ الاسم الجديد؛ يُرجع رسالة خطأ عربية أو null عند النجاح.
  Future<String?> updateName(String raw) async {
    final String name = raw.trim();
    if (name.isEmpty) return 'الاسم الكامل مطلوب.';
    if (name.length > 120) return 'الاسم طويل جدًا (120 حرفًا كحد أقصى).';
    return _apply(
      () => _service.updateFullName(name),
      'تعذّر حفظ الاسم، حاول مرة أخرى.',
    );
  }

  /// يحفظ رقم الهاتف (فارغ = إزالته)؛ يُرجع رسالة خطأ أو null.
  Future<String?> updatePhone(String raw) async {
    final String phone = raw.trim();
    if (phone.isNotEmpty) {
      if (phone.length < 6) return 'رقم الهاتف قصير جدًا.';
      if (!RegExp(r'^[0-9+\s-]+$').hasMatch(phone)) {
        return 'رقم الهاتف يجب أن يحتوي على أرقام فقط.';
      }
    }
    return _apply(
      () => _service.updatePhone(phone.isEmpty ? null : phone),
      'تعذّر حفظ رقم الهاتف، حاول مرة أخرى.',
    );
  }

  /// يلتقط/يختار صورة ويرفعها ثم يحدّث الملف.
  ///
  /// يُرجع null عند النجاح **أو** عند إلغاء المستخدم (ليست خطأ)،
  /// ورسالة خطأ عربية عند الفشل. الواجهة تميّز الحالتين بمقارنة الرابط.
  Future<String?> changeAvatar(ImageSource source) async {
    _isSaving = true;
    notifyListeners();
    try {
      final XFile? picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return null; // ألغى المستخدم العملية

      final Uint8List bytes = await picked.readAsBytes();
      if (bytes.isEmpty) return 'الصورة المختارة غير صالحة.';

      final String url = await _service.uploadAvatar(
        bytes: bytes,
        fileName: picked.name,
      );
      final String? oldUrl = _profile?.avatarUrl;
      _profile = await _service.updateAvatarUrl(url);
      _error = null;
      notifyListeners();
      await _service.deleteAvatarFile(oldUrl); // تنظيف الملف القديم (أفضل جهد)
      return null;
    } on ProfileFailure catch (e) {
      return e.message;
    } on PlatformException catch (e) {
      return _permissionMessage(e.code);
    } catch (_) {
      return 'تعذّر رفع الصورة، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// يحذف الصورة الحالية من الملف ومن التخزين؛ null عند النجاح/الغياب.
  Future<String?> removeAvatar() async {
    final String? oldUrl = _profile?.avatarUrl;
    if (oldUrl == null || oldUrl.isEmpty) return null;
    return _apply(
      () async {
        final UserProfile updated = await _service.updateAvatarUrl(null);
        await _service.deleteAvatarFile(oldUrl);
        return updated;
      },
      'تعذّر حذف الصورة، حاول مرة أخرى.',
    );
  }

  Future<String?> _apply(
    Future<UserProfile> Function() operation,
    String fallbackError,
  ) async {
    _isSaving = true;
    notifyListeners();
    try {
      _profile = await operation();
      _error = null;
      return null;
    } on ProfileFailure catch (e) {
      return e.message;
    } catch (_) {
      return fallbackError;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// معرّف المستخدم Firebase الحالي (null = لا جلسة أو بيئة اختبار).
  String? get _currentUid {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (_) {
      return null; // Firebase غير مهيّأ — ليست حالة خطأ.
    }
  }

  static String _permissionMessage(String code) {
    final String c = code.toLowerCase();
    if (c.contains('denied') || c.contains('permission')) {
      return 'تم رفض الإذن، فعّل إذن الوصول من إعدادات الجهاز ثم حاول مجددًا.';
    }
    if (c.contains('camera')) return 'تعذّر فتح الكاميرا، حاول مرة أخرى.';
    if (c.contains('invalid')) return 'الصورة غير صالحة، اختر صورة أخرى.';
    return 'تعذّر فتح الصور، حاول مرة أخرى.';
  }
}
