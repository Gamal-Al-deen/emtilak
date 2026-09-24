import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/auth/auth_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailPhoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onSubmit,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onBiometricSignIn,
    required this.onPasswordToggle,
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isFacebookLoading = false,
    this.isBiometricLoading = false,
    this.showBiometricButton = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailPhoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;
  final VoidCallback onBiometricSignIn;
  final VoidCallback onPasswordToggle;

  /// يمنع أي محاولة دخول جديدة أثناء تنفيذ محاولة سابقة.
  final bool isLoading;

  /// يحدّد الزر الذي يعرض مؤشر التحميل حاليًا.
  final bool isGoogleLoading;
  final bool isFacebookLoading;
  final bool isBiometricLoading;

  /// يظهر زر البصمة فقط عند تفعيله من الإعدادات.
  final bool showBiometricButton;

  /// مؤشر التحميل الخاص بأي زر غير زر تسجيل الدخول الأساسي.
  bool get _socialActionLoading =>
      isGoogleLoading || isFacebookLoading || isBiometricLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Text(
              l10n.loginTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.loginWelcome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: emailPhoneController,
              hintText: l10n.loginEmailHint,
              prefixIcon: Icons.email_outlined,
              fieldType: AuthFieldType.email,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: passwordController,
              hintText: l10n.loginPasswordHint,
              prefixIcon: Icons.lock_outline,
              fieldType: AuthFieldType.password,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: onPasswordToggle,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.forgotPassword,
                ),
                child: Text(
                  l10n.loginForgotPassword,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: isLoading && !_socialActionLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      l10n.loginButton,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: Divider(color: AppColors.border)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'أو',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.border)),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isLoading ? null : onGoogleSignIn,
              icon: isGoogleLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.g_mobiledata,
                      size: 28,
                      color: AppColors.error,
                    ),
              label: Text(
                isGoogleLoading ? l10n.loginVerifying : l10n.loginWithGoogle,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isLoading ? null : onFacebookSignIn,
              icon: isFacebookLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(
                      Icons.facebook,
                      size: 24,
                      color: AppColors.info,
                    ),
              label: Text(
                isFacebookLoading
                    ? l10n.loginVerifying
                    : l10n.loginWithFacebook,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            if (showBiometricButton) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : onBiometricSignIn,
                icon: isBiometricLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(
                        Icons.fingerprint,
                        size: 24,
                        color: AppColors.primary,
                      ),
                label: Text(
                  isBiometricLoading ? l10n.loginVerifying : l10n.loginWithBiometric,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                Text(
                  l10n.loginNoAccount,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.signUp),
                  child: Text(
                    l10n.loginCreateAccount,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
