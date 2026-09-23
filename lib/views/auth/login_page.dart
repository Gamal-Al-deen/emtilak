import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/auth_message.dart';
import 'widgets/login_brand_section.dart';
import 'widgets/login_form_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  /// null = لا توجد محاولة جارية، وإلا فإن القيمة هي طريقة الدخول الحالية.
  Future<void>? _pendingSignIn;

  /// 'email' أو 'google' أو 'facebook' أو 'biometric' — الزر الذي يعمل حاليًا.
  String? _activeAction;

  /// يُقرأ من الإعدادات لتحديد ظهور زر البصمة.
  bool _showBiometricButton = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
  }

  Future<void> _loadBiometricPreference() async {
    final bool enabled = await AuthService.instance.isBiometricLoginEnabled();
    if (mounted && enabled != _showBiometricButton) {
      setState(() => _showBiometricButton = enabled);
    }
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    showAuthMessage(context, message, isError: isError);
  }

  /// يمنع أي محاولة دخول متزامنة أثناء تنفيذ محاولة سابقة.
  Future<void> _run(
    Future<void> Function() action, {
    required String actionType,
  }) async {
    if (_pendingSignIn != null) return;
    _activeAction = actionType;
    final Future<void> future = action();
    setState(() => _pendingSignIn = future);
    try {
      await future;
    } on AuthFailure catch (e) {
      _showMessage(e.message, isError: !e.isCanceled);
    } catch (_) {
      _showMessage('حدث خطأ غير متوقع، حاول مرة أخرى.');
    } finally {
      if (mounted) {
        setState(() {
          _pendingSignIn = null;
          _activeAction = null;
        });
      }
    }
  }

  void _goToApp() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _run(
      () async {
        await AuthService.instance.signInWithEmail(
          email: _emailPhoneController.text,
          password: _passwordController.text,
        );
        _goToApp();
      },
      actionType: 'email',
    );
  }

  Future<void> _signInWithGoogle() async {
    await _run(
      () async {
        final User? user = await AuthService.instance.signInWithGoogle();
        if (user == null) {
          _showMessage(
            'تم إلغاء تسجيل الدخول باستخدام Google.',
            isError: false,
          );
          return;
        }
        _goToApp();
      },
      actionType: 'google',
    );
  }

  Future<void> _signInWithFacebook() async {
    await _run(
      () async {
        final User? user = await AuthService.instance.signInWithFacebook();
        if (user == null) {
          _showMessage(
            'تم إلغاء تسجيل الدخول باستخدام فيسبوك.',
            isError: false,
          );
          return;
        }
        _goToApp();
      },
      actionType: 'facebook',
    );
  }

  Future<void> _signInWithBiometric() async {
    await _run(
      () async {
        final User? user = await AuthService.instance.signInWithBiometric();
        if (user == null) {
          _showMessage('تم إلغاء التحقق بالبصمة.', isError: false);
          return;
        }
        _goToApp();
      },
      actionType: 'biometric',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = _pendingSignIn != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideLayout = constraints.maxWidth >= 900;
            final logoSize = constraints.maxWidth < 360 ? 84.0 : 110.0;

            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideLayout ? 36 : 18,
                  vertical: isWideLayout ? 28 : 12,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: isWideLayout
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child:
                                      LoginBrandSection(logoSize: logoSize),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 3,
                                child: LoginFormCard(
                                  formKey: _formKey,
                                  emailPhoneController: _emailPhoneController,
                                  passwordController: _passwordController,
                                  obscurePassword: _obscurePassword,
                                  onSubmit: _submit,
                                  onGoogleSignIn: _signInWithGoogle,
                                  onFacebookSignIn: _signInWithFacebook,
                                  onBiometricSignIn: _signInWithBiometric,
                                  isLoading: isLoading,
                                  isGoogleLoading:
                                      isLoading && _activeAction == 'google',
                                  isFacebookLoading:
                                      isLoading &&
                                      _activeAction == 'facebook',
                                  isBiometricLoading:
                                      isLoading &&
                                      _activeAction == 'biometric',
                                  showBiometricButton: _showBiometricButton,
                                  onPasswordToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 6),
                              LoginBrandSection(logoSize: logoSize),
                              const SizedBox(height: 16),
                              LoginFormCard(
                                formKey: _formKey,
                                emailPhoneController: _emailPhoneController,
                                passwordController: _passwordController,
                                obscurePassword: _obscurePassword,
                                onSubmit: _submit,
                                onGoogleSignIn: _signInWithGoogle,
                                onFacebookSignIn: _signInWithFacebook,
                                onBiometricSignIn: _signInWithBiometric,
                                isLoading: isLoading,
                                isGoogleLoading:
                                    isLoading && _activeAction == 'google',
                                isFacebookLoading:
                                    isLoading && _activeAction == 'facebook',
                                isBiometricLoading:
                                    isLoading && _activeAction == 'biometric',
                                showBiometricButton: _showBiometricButton,
                                onPasswordToggle: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
