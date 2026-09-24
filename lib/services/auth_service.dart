import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile_service.dart';

/// خطأ مفهوم يُعرض للمستخدم بصيغة عربية.
///
/// لا يُعرض أبدًا أي نص خام صادر من Firebase أو Google.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.isCanceled = false});

  /// الرسالة التي تظهر للمستخدم.
  final String message;

  /// true إذا ألغى المستخدم العملية بنفسه، وهي ليست مشكلة حقيقية.
  final bool isCanceled;

  @override
  String toString() => message;
}

/// المصدر الوحيد لعمليات المصادقة في التطبيق.
///
/// Firebase هو المرجعية الحقيقية للمصادقة، بينما يوفّر Google Sign-In
/// بيانات اعتماد يوثّقها Firebase عبر `signInWithCredential`.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // حالة المصادقة
  // ---------------------------------------------------------------------------

  Stream<User?>? _authStateChanges;

  /// تدفّق تغيّر حالة المصادقة، يُنشأ مرة واحدة فقط حتى لا يعاد الاشتراك
  /// في كل إعادة بناء للواجهة.
  Stream<User?> authStateChanges() =>
      _authStateChanges ??= _auth.authStateChanges();

  /// المستخدم الحالي، أو null إذا لم يكن مسجّل الدخول.
  User? get currentUser => _auth.currentUser;

  /// صورة المستخدم من Firebase (`photoURL`) — تُستخدم كمرشّح ثانٍ للأفاتار
  /// بعد صورة Supabase مباشرة، قبل الحرف الأول من الاسم.
  String? get currentPhotoURL {
    try {
      return _auth.currentUser?.photoURL;
    } catch (_) {
      return null; // Firebase غير مهيّأ (بيئة اختبار) — ليست حالة خطأ.
    }
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In (الإصدار 7.x)
  // ---------------------------------------------------------------------------

  Future<void>? _googleInit;

  /// يضمن استدعاء [GoogleSignIn.instance.initialize] مرة واحدة فقط وقبل أي
  /// طريقة أخرى، وفق متطلبات الإصدار 7.x من الحزمة.
  Future<void> _ensureGoogleInitialized() =>
      _googleInit ??= _initializeGoogle();

  Future<void> _initializeGoogle() async {
    try {
      // على أندرويد تُقرأ معرّفات عميل الويب (serverClientId) تلقائيًا من
      // google-services.json، فلا داعي لتمريرها يدويًا أو لوضع أي مفتاح سري.
      await GoogleSignIn.instance.initialize();
    } catch (_) {
      _googleInit = null; // نسمح بإعادة المحاولة عند الفشل
      rethrow;
    }
  }

  /// يبدأ تسجيل الدخول عبر Google ثم يوثّق الحساب في Firebase.
  ///
  /// يُرجع المستخدم الموثّق عند النجاح، أو `null` إذا ألغى المستخدم العملية.
  /// يرمي [AuthFailure] بأي حالة خطأ أخرى.
  Future<User?> signInWithGoogle() async {
    try {
      // ١) تهيئة Google Sign-In ثم بدء عملية تسجيل الدخول التفاعلية،
      //    ليختار المستخدم حسابه بنفسه.
      await _ensureGoogleInitialized();
      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();

      // ٢) الحصول على بيانات المصادقة (idToken) الخاصة بالحساب المختار.
      final String? idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AuthFailure(
          'تعذّر الحصول على بيانات الدخول من Google، حاول مرة أخرى.',
        );
      }

      // ٣) تحويل بيانات Google إلى بيانات اعتماد Firebase.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // ٤) المصادقة الفعلية عبر Firebase، وهي المرجعية الحقيقية.
      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );

      // مزامنة الملف الشخصي (Firebase UID ← صف profiles): تبدأ فور نجاح
      // الدخول ولا ترمي — أي فشل يُسجّل بمرحلته ليعرضه تحميل الملف.
      unawaited(ProfileService.instance.syncAfterFirebaseAuth());

      // ربط البصمة بهذا الحساب وحده: تُمسح بيانات البريد المحفوظة أولًا
      // حتى لا تُعيد البصمة حسابًا سابقًا (جذر مشكلة "الحساب الثابت").
      await _clearBiometricCredentials();
      await _markBiometricProvider(
        _providerGoogle,
        googleEmail: account.email,
      );
      return result.user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null; // ألغى المستخدم العملية: ليست حالة خطأ.
      }
      throw AuthFailure(_googleMessage(e.code));
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure(
        'تعذّر تسجيل الدخول، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Facebook Sign-In
  // ---------------------------------------------------------------------------

  /// يُضبط على `true` بعد إدخال معرّفات فيسبوك الحقيقية (App ID و Client
  /// Token) في `android/app/src/main/res/values/strings.xml`.
  static const bool _facebookLoginConfigured = false;

  /// يبدأ تسجيل الدخول عبر Facebook ثم يوثّق الحساب في Firebase.
  ///
  /// يُرجع المستخدم الموثّق عند النجاح، أو `null` إذا ألغى المستخدم العملية.
  Future<User?> signInWithFacebook() async {
    if (!_facebookLoginConfigured) {
      throw const AuthFailure(
        'تسجيل الدخول عبر فيسبوك غير مفعّل حاليًا، سيتم تفعيله قريبًا.',
      );
    }

    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        return null; // ألغى المستخدم العملية: ليست حالة خطأ.
      }
      if (result.status == LoginStatus.operationInProgress) {
        throw const AuthFailure(
          'هناك محاولة دخول جارية بالفعل، حاول بعد قليل.',
        );
      }
      if (result.status == LoginStatus.failed) {
        // لا نعرض أي نص خام صادر من فيسبوك.
        throw const AuthFailure(
          'تعذّر تسجيل الدخول عبر فيسبوك، حاول مرة أخرى.',
        );
      }

      // في flutter_facebook_auth 7.x: خاصية AccessToken اسمها tokenString.
      final String? token = result.accessToken?.tokenString;
      if (token == null || token.isEmpty) {
        throw const AuthFailure(
          'تعذّر الحصول على بيانات الدخول من فيسبوك، حاول مرة أخرى.',
        );
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(token);
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // مزامنة الملف الشخصي (Firebase UID ← صف profiles): لا ترمي،
      // والفشل يُسجّل بمرحلته ليعرضه تحميل الملف.
      unawaited(ProfileService.instance.syncAfterFirebaseAuth());

      // ربط البصمة بهذا الحساب وحده (نفس منطق Google): تُمسح أي بيانات
      // بريد محفوظة حتى لا تُعادة البصمة لحساب آخر.
      await _clearBiometricCredentials();
      await _markBiometricProvider(_providerFacebook);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure(
        'تعذّر تسجيل الدخول عبر فيسبوك، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // تسجيل الدخول بالبصمة
  // ---------------------------------------------------------------------------

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _secureEmailKey = 'biometric_email';
  static const String _securePasswordKey = 'biometric_password';
  static const String _biometricEnabledKey = 'biometric_login_enabled';

  /// المزوّد الذي نجحت آخر مصادقة عليه على هذا الجهاز — البصمة تستعيد
  /// حسابه فقط، ولا تعرف أي حساب ثابت.
  static const String _secureProviderKey = 'biometric_provider';

  /// بريد آخر حساب Google المربوط بالبصمة — تحقّق إلزامي عند الاستعادة
  /// حتى لا تفتح قائمة الحسابات حسابًا غير المسجّل.
  static const String _secureGoogleEmailKey = 'biometric_google_email';

  static const String _providerEmail = 'email';
  static const String _providerGoogle = 'google';
  static const String _providerFacebook = 'facebook';

  /// ما إذا كان زر البصمة ظاهرًا في شاشة تسجيل الدخول (من الإعدادات).
  Future<bool> isBiometricLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  /// تفعيل/تعطيل زر البصمة؛ وعند التعطيل تُحذف بيانات الدخول المحفوظة.
  Future<void> setBiometricLoginEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
    if (!enabled) {
      await _clearBiometricCredentials();
    }
  }

  /// يحفظ بيانات الدخول الأخيرة بشكل مشفّر داخل الجهاز.
  Future<void> _saveBiometricCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _secureStorage.write(key: _secureEmailKey, value: email);
      await _secureStorage.write(key: _securePasswordKey, value: password);
      // آخر مصادقة ناجحة = بريد، فترتبط البصمة به.
      await _secureStorage.write(key: _secureProviderKey, value: _providerEmail);
    } catch (_) {
      // فشل الحفظ لا يُبطل أي عملية أخرى.
    }
  }

  Future<void> _clearBiometricCredentials() async {
    try {
      await _secureStorage.delete(key: _secureEmailKey);
      await _secureStorage.delete(key: _securePasswordKey);
      await _secureStorage.delete(key: _secureProviderKey);
      await _secureStorage.delete(key: _secureGoogleEmailKey);
    } catch (_) {
      // تجاهل: الحذف اختياري.
    }
  }

  /// يربط البصمة بالمزوّد الذي نجحت آخر مصادقة عليه — لا يُخزَّن أي سرّ
  /// ولا أي بيانات اعتماد جديدة، فقط مؤشّر الهوية (وبريد Google للمطابقة).
  Future<void> _markBiometricProvider(
    String provider, {
    String? googleEmail,
  }) async {
    try {
      await _secureStorage.write(key: _secureProviderKey, value: provider);
      if (provider == _providerGoogle) {
        if (googleEmail != null && googleEmail.trim().isNotEmpty) {
          await _secureStorage.write(
            key: _secureGoogleEmailKey,
            value: googleEmail.trim().toLowerCase(),
          );
        } else {
          await _secureStorage.delete(key: _secureGoogleEmailKey);
        }
      }
    } catch (_) {
      // فشل الحفظ لا يُبطل المصادقة.
    }
  }

  /// يتحقق من الهوية بالبصمة ثم يدخل بالبيانات المحفوظة على الجهاز.
  ///
  /// يُرجع `null` إذا ألغى المستخدم العملية، ويرمي [AuthFailure] عند الفشل.
  Future<User?> signInWithBiometric() async {
    final String? provider = await _secureStorage.read(key: _secureProviderKey);
    final String? email = await _secureStorage.read(key: _secureEmailKey);
    final String? password = await _secureStorage.read(key: _securePasswordKey);

    // ترحيل آمن للإصدارات القديمة: بريد محفوظ دون مزوّد = بريد.
    String effectiveProvider = provider ?? '';
    if (effectiveProvider.isEmpty && email != null && password != null) {
      effectiveProvider = _providerEmail;
    }

    if (effectiveProvider.isEmpty) {
      throw const AuthFailure(
        'لا يوجد حساب مسجل للدخول بالبصمة. يرجى تسجيل الدخول أولاً باستخدام Google.',
      );
    }
    if (effectiveProvider == _providerEmail &&
        (email == null || password == null)) {
      throw const AuthFailure(
        'لا توجد بيانات دخول محفوظة على هذا الجهاز، سجّل الدخول بالبريد الإلكتروني أولًا.',
      );
    }

    final LocalAuthentication localAuth = LocalAuthentication();
    try {
      final bool supported = await localAuth.isDeviceSupported();
      if (!supported) {
        throw const AuthFailure(
          'تسجيل الدخول بالبصمة غير متاح على هذا الجهاز.',
        );
      }

      final bool authenticated = await localAuth.authenticate(
        localizedReason: 'سجّل الدخول إلى التطبيق باستخدام بصمة الإصبع',
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'تسجيل الدخول بالبصمة',
            signInHint: 'ضع إصبعك على حسّاس البصمة',
            cancelButton: 'إلغاء',
          ),
        ],
        biometricOnly: true,
      );

      if (!authenticated) {
        // محاولة فاشلة دون أي تأثير جانبي.
        throw const AuthFailure('لم يتم التعرّف على بصمتك، حاول مرة أخرى.');
      }
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled ||
          e.code == LocalAuthExceptionCode.timeout) {
        return null; // ألغى المستخدم العملية: ليست حالة خطأ.
      }
      throw AuthFailure(_biometricMessage(e.code));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure('تعذّر التحقق من الهوية بالبصمة، حاول مرة أخرى.');
    }

    // استعادة الحساب "الأخير" المرتبط بالبصمة — لا يوجد حساب ثابت،
    // وكل مسار إخفاق يُرجِع رسالة عربية تدلّ على مرحلته الحقيقية.
    switch (effectiveProvider) {
      case _providerGoogle:
        return _restoreGoogleForBiometric();
      case _providerFacebook:
        return _restoreFacebookForBiometric();
      default:
        final UserCredential credential = await signInWithEmail(
          email: email!,
          password: password!,
        );
        return credential.user;
    }
  }

  /// استعادة آخر حساب Google المربوط بالبصمة: صامتة أولًا (إن كانت جلسة
  /// Google سارية) ثم تفاعلية، مع **تحقّق إلزامي** من مطابقة الحساب
  /// للمسجّل حتى لا تفتح قائمة حسابات Google حسابًا غير المقصود.
  Future<User?> _restoreGoogleForBiometric() async {
    final String? registeredEmail = await _secureStorage.read(
      key: _secureGoogleEmailKey,
    );
    if (registeredEmail == null || registeredEmail.isEmpty) {
      throw const AuthFailure(
        'لا يوجد حساب مسجل للدخول بالبصمة. يرجى تسجيل الدخول أولاً باستخدام Google.',
      );
    }

    try {
      await _ensureGoogleInitialized();

      //1) محاولة صامتة: تُعيد آخر جلسة سارية دون أي واجهة.
      // قد يكون المستقبل نفسه null (عدم دعم) فيُترك الحساب فارغًا.
      GoogleSignInAccount? account;
      final Future<GoogleSignInAccount?>? lightweight = GoogleSignIn.instance
          .attemptLightweightAuthentication();
      if (lightweight != null) {
        account = await lightweight;
      }

      //2) لا جلسة → تفاعلية (قائمة الحسابات) ثم فرض المطابقة أدناه.
      account ??= await GoogleSignIn.instance.authenticate();

      if (account.email.trim().toLowerCase() != registeredEmail) {
        throw const AuthFailure(
          'الحساب المستعاد لا يطابق آخر حساب مسجّل بالبصمة. سجّل الدخول أولًا باستخدام Google.',
        );
      }

      final String? idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AuthFailure(
          'تعذّر الحصول على بيانات الدخول من Google، حاول مرة أخرى.',
        );
      }
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );
      unawaited(ProfileService.instance.syncAfterFirebaseAuth());
      await _markBiometricProvider(
        _providerGoogle,
        googleEmail: account.email,
      );
      return result.user;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        return null; // ألغى المستخدم بنفسه: ليست حالة خطأ.
      }
      throw AuthFailure(_googleMessage(e.code));
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure(
        'تعذّر استعادة حساب Google، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    }
  }

  /// استعادة آخر حساب Facebook المربوط بالبصمة عبر رمزه المحفوظ في
  /// الـSDK؛ إن كان محذوفًا (خروج أو انتهاء صلاحية) تظهر رسالة عربية
  /// تطلب تسجيل الدخول عبر فيسبوك أولًا — لا يُفتح أي حساب افتراضي.
  Future<User?> _restoreFacebookForBiometric() async {
    try {
      final AccessToken? token = await FacebookAuth.instance.accessToken;
      if (token == null || token.tokenString.isEmpty) {
        throw const AuthFailure(
          'جلسة فيسبوك غير متاحة على هذا الجهاز. سجّل الدخول عبر فيسبوك أولًا.',
        );
      }
      final OAuthCredential credential = FacebookAuthProvider.credential(
        token.tokenString,
      );
      final UserCredential result = await _auth.signInWithCredential(
        credential,
      );
      unawaited(ProfileService.instance.syncAfterFirebaseAuth());
      await _markBiometricProvider(_providerFacebook);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure(
        'تعذّر استعادة حساب فيسبوك، سجّل الدخول عبر فيسبوك أولًا.',
      );
    }
  }

  static String _biometricMessage(LocalAuthExceptionCode code) {
    switch (code) {
      case LocalAuthExceptionCode.noBiometricHardware:
        return 'هذا الجهاز لا يدعم تسجيل الدخول بالبصمة.';
      case LocalAuthExceptionCode.noBiometricsEnrolled:
        return 'لم تتم إضافة بصمة على هذا الجهاز، أضفها من إعدادات الجهاز أولًا.';
      case LocalAuthExceptionCode.noCredentialsSet:
        return 'لم يتم إعداد قفل شاشة أو بصمة على الجهاز، فعّلها من الإعدادات أولًا.';
      case LocalAuthExceptionCode.temporaryLockout:
      case LocalAuthExceptionCode.biometricLockout:
        return 'تم قفل البصمة مؤقتًا بعد محاولات كثيرة، حاول لاحقًا.';
      case LocalAuthExceptionCode.authInProgress:
        return 'هناك محاولة تحقق جارية بالفعل، حاول بعد قليل.';
      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        return 'مستشعر البصمة غير متاح حاليًا، حاول بعد قليل.';
      case LocalAuthExceptionCode.uiUnavailable:
        return 'تعذّر عرض نافذة التحقق، حاول مرة أخرى.';
      case LocalAuthExceptionCode.userRequestedFallback:
        return 'يلزم استخدام البصمة لتسجيل الدخول.';
      case LocalAuthExceptionCode.userCanceled:
      case LocalAuthExceptionCode.systemCanceled:
      case LocalAuthExceptionCode.timeout:
        return 'تم إلغاء التحقق بالبصمة.';
      case LocalAuthExceptionCode.deviceError:
      case LocalAuthExceptionCode.unknownError:
        return 'تعذّر التحقق من الهوية بالبصمة، حاول مرة أخرى.';
    }
  }

  // ---------------------------------------------------------------------------
  // البريد الإلكتروني وكلمة المرور
  // ---------------------------------------------------------------------------

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // حفظ البيانات (مشفّرة داخل الجهاز) لتمكين الدخول بالبصمة لاحقًا؛
      // فشل الحفظ لا يُبطل نجاح تسجيل الدخول.
      await _saveBiometricCredentials(email: email.trim(), password: password);

      // مزامنة الملف الشخصي (تغطي الدخول بالبصمة أيضًا لأنه يمرّ من هنا).
      unawaited(ProfileService.instance.syncAfterFirebaseAuth());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } catch (_) {
      throw const AuthFailure(
        'تعذّر تسجيل الدخول، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // حفظ الاسم اختياري، وفشله لا يُبطل إنشاء الحساب.
      final String name = displayName?.trim() ?? '';
      if (name.isNotEmpty) {
        try {
          await credential.user?.updateDisplayName(name);
        } catch (_) {
          // تجاهل: الحساب أُنشئ وسُجّل دخوله بنجاح.
        }
      }

      // ربط البصمة بالحساب المُنشأ للتو (آخر مصادقة ناجحة)؛ فشل الحفظ
      // لا يُبطل إنشاء الحساب.
      await _saveBiometricCredentials(email: email.trim(), password: password);

      // مزامنة الملف الشخصي فور إنشاء الحساب (idempotent، لا ترمي).
      unawaited(ProfileService.instance.syncAfterFirebaseAuth());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } catch (_) {
      throw const AuthFailure(
        'تعذّر إنشاء الحساب، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    }
  }

  Future<void> sendPasswordReset({required String email}) async {
    try {
      // الاستعادة من Firebase وحده — لا يوجد حساب Supabase يُزامَن.
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_firebaseMessage(e.code));
    } catch (_) {
      throw const AuthFailure(
        'تعذّر إرسال رابط الاستعادة، تحقّق من اتصالك بالإنترنت وحاول مرة أخرى.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // تسجيل الخروج
  // ---------------------------------------------------------------------------

  /// يُنهي جلسة Google ثم جلسة Firebase.
  ///
  /// تُرجع false عند الفشل بدل رمي استثناء، حتى لا تُسقط واجهة الاستدعاء.
  Future<bool> signOut() async {
    // تفريغ ذاكرة الجلسة المؤقتة للملف أولًا (لا يحذف أي صف في القاعدة) —
    // لا ترمي أبدًا ولا تُبطل تسجيل الخروج.
    await ProfileService.instance.clearSession();

    // إلغاء جلسة Facebook إن وُجدت.
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {
      // فشل Facebook لا يمنع تسجيل الخروج من Firebase.
    }

    // إلغاء جلسة Google حتى لا يبقى المستخدم مسجّل الدخول فيها.
    try {
      await _ensureGoogleInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // فشل Google لا يمنع تسجيل الخروج من Firebase.
    }

    try {
      await _auth.signOut();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // رسائل الخطأ بالعربية (لا تُعرض أي رسائل خام من المزوّد)
  // ---------------------------------------------------------------------------

  static String _firebaseMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح.';
      case 'user-disabled':
        return 'هذا الحساب معطّل، تواصل مع الدعم.';
      case 'user-not-found':
        return 'لا يوجد حساب مسجّل بهذا البريد الإلكتروني.';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة.';
      case 'invalid-credential':
        return 'بيانات الدخول غير صحيحة، تحقّق من البريد وكلمة المرور.';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جدًا، يجب ألا تقل عن 6 أحرف.';
      case 'network-request-failed':
        return 'تعذّر الاتصال بالشبكة، تحقّق من اتصالك بالإنترنت.';
      case 'too-many-requests':
        return 'عدد كبير من المحاولات، يرجى المحاولة لاحقًا.';
      case 'operation-not-allowed':
        return 'طريقة تسجيل الدخول غير مفعّلة حاليًا.';
      case 'account-exists-with-different-credential':
        return 'يوجد حساب بهذا البريد بطريقة تسجيل دخول مختلفة.';
      case 'invalid-action-code':
      case 'expired-action-code':
        return 'رابط إعادة التعيين غير صالح أو منتهي الصلاحية.';
      case 'requires-recent-login':
        return 'يلزم تسجيل الدخول مرة أخرى لإتمام هذه العملية.';
      default:
        return 'حدث خطأ غير متوقع، حاول مرة أخرى.';
    }
  }

  static String _googleMessage(GoogleSignInExceptionCode code) {
    switch (code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'إعدادات تسجيل الدخول غير صحيحة، تواصل مع مطوّر التطبيق.';
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'تعذّر عرض نافذة تسجيل الدخول، حاول مرة أخرى.';
      case GoogleSignInExceptionCode.userMismatch:
        return 'حساب Google غير متطابق، حاول بحساب آخر.';
      case GoogleSignInExceptionCode.unknownError:
      case GoogleSignInExceptionCode.canceled:
      case GoogleSignInExceptionCode.interrupted:
        return 'تعذّر تسجيل الدخول باستخدام Google، حاول مرة أخرى.';
    }
  }
}
