import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/auth_message.dart';
import 'widgets/forgot_password_brand_section.dart';
import 'widgets/forgot_password_form_card.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  Future<void>? _pendingReset;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    showAuthMessage(context, message, isError: isError);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_pendingReset != null) return; // منع المحاولات المتزامنة

    final Future<void> future = _sendResetEmail();
    setState(() => _pendingReset = future);
    try {
      await future;
    } on AuthFailure catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('حدث خطأ غير متوقع، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _pendingReset = null);
    }
  }

  Future<void> _sendResetEmail() async {
    await AuthService.instance.sendPasswordReset(email: _emailController.text);
    _showMessage(
      'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني.',
      isError: false,
    );
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = _pendingReset != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final logoSize = constraints.maxWidth < 360 ? 84.0 : 110.0;

            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 36 : 18,
                  vertical: isWide ? 28 : 16,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24),
                                  child: ForgotPasswordBrandSection(
                                    logoSize: logoSize,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 3,
                                child: ForgotPasswordFormCard(
                                  formKey: _formKey,
                                  emailController: _emailController,
                                  onSubmit: _submit,
                                  isLoading: isLoading,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 12),
                              ForgotPasswordBrandSection(logoSize: logoSize),
                              const SizedBox(height: 24),
                              ForgotPasswordFormCard(
                                formKey: _formKey,
                                emailController: _emailController,
                                onSubmit: _submit,
                                isLoading: isLoading,
                              ),
                              const SizedBox(height: 18),
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
