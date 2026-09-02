import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/app_brand_logo.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني.',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppBrandLogo(size: 110),
                                      const SizedBox(height: 16),
                                      const FractionallySizedBox(
                                        widthFactor: 0.8,
                                        child: Text(
                                          'استعادة الوصول إلى حسابك بسهولة وأمان',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 520,
                                  ),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.cardShadow,
                                        blurRadius: 18,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'استعادة كلمة المرور',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        AuthFormField(
                                          controller: _emailController,
                                          hintText: 'البريد الإلكتروني',
                                          prefixIcon: Icons.email_outlined,
                                          fieldType: AuthFieldType.email,
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: _submit,
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            backgroundColor: AppColors.primary,
                                          ),
                                          child: const Text(
                                            'إرسال الرابط',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pushReplacementNamed(
                                                context,
                                                AppRoutes.login,
                                              ),
                                          child: const Text(
                                            'العودة إلى تسجيل الدخول',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: AppColors.gold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 12),
                              AppBrandLogo(size: 90),
                              const SizedBox(height: 16),
                              const Text(
                                'استعادة الوصول إلى حسابك بسهولة وأمان',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 520,
                                ),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.cardShadow,
                                      blurRadius: 18,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'استعادة كلمة المرور',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'أدخل بريدك الإلكتروني لاستلام رابط إعادة التعيين.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      AuthFormField(
                                        controller: _emailController,
                                        hintText: 'البريد الإلكتروني',
                                        prefixIcon: Icons.email_outlined,
                                        fieldType: AuthFieldType.email,
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: _submit,
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          backgroundColor: AppColors.primary,
                                        ),
                                        child: const Text(
                                          'إرسال الرابط',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pushReplacementNamed(
                                              context,
                                              AppRoutes.login,
                                            ),
                                        child: const Text(
                                          'العودة إلى تسجيل الدخول',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: AppColors.gold,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
