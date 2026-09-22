import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/auth/auth_text_field.dart';

class ForgotPasswordFormCard extends StatelessWidget {
  const ForgotPasswordFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
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
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              controller: emailController,
              hintText: 'البريد الإلكتروني',
              prefixIcon: Icons.email_outlined,
              fieldType: AuthFieldType.email,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
              onPressed: () => Navigator.pushReplacementNamed(
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
    );
  }
}
