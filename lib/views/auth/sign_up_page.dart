import 'package:flutter/material.dart';

import '../../routes/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common/auth_message.dart';
import 'widgets/sign_up_brand_section.dart';
import 'widgets/sign_up_form_card.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  Future<void>? _pendingSignUp;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    showAuthMessage(context, message, isError: isError);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_pendingSignUp != null) return; // منع المحاولات المتزامنة

    final Future<void> future = _createAccount();
    setState(() => _pendingSignUp = future);
    try {
      await future;
    } on AuthFailure catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('حدث خطأ غير متوقع، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _pendingSignUp = null);
    }
  }

  Future<void> _createAccount() async {
    await AuthService.instance.signUpWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
      displayName: _fullNameController.text,
    );
    // إنشاء الحساب يسجّل دخول المستخدم تلقائيًا في Firebase.
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = _pendingSignUp != null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideLayout = constraints.maxWidth >= 900;
            final logoSize = constraints.maxWidth < 360 ? 84.0 : 110.0;

            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideLayout ? 36 : 18,
                  vertical: isWideLayout ? 28 : 16,
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
                                  child: SignUpBrandSection(logoSize: logoSize),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 3,
                                child: SignUpFormCard(
                                  formKey: _formKey,
                                  fullNameController: _fullNameController,
                                  emailController: _emailController,
                                  phoneController: _phoneController,
                                  passwordController: _passwordController,
                                  confirmPasswordController:
                                      _confirmPasswordController,
                                  obscurePassword: _obscurePassword,
                                  obscureConfirmPassword:
                                      _obscureConfirmPassword,
                                  onSubmit: _submit,
                                  isLoading: isLoading,
                                  onTogglePassword: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  onToggleConfirmPassword: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 12),
                              SignUpBrandSection(logoSize: logoSize),
                              const SizedBox(height: 24),
                              SignUpFormCard(
                                formKey: _formKey,
                                fullNameController: _fullNameController,
                                emailController: _emailController,
                                phoneController: _phoneController,
                                passwordController: _passwordController,
                                confirmPasswordController:
                                    _confirmPasswordController,
                                obscurePassword: _obscurePassword,
                                obscureConfirmPassword: _obscureConfirmPassword,
                                onSubmit: _submit,
                                isLoading: isLoading,
                                onTogglePassword: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                onToggleConfirmPassword: () => setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                ),
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
