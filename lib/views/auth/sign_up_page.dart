import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/app_brand_logo.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  Widget _buildBrandSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final logoSize = constraints.maxWidth < 360 ? 84.0 : 110.0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBrandLogo(size: logoSize),
            const SizedBox(height: 16),
            const FractionallySizedBox(
              widthFactor: 0.8,
              child: Text(
                'ابدأ رحلتك في إدارة العقارات بثقة واحترافية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 560),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'إنشاء حساب جديد',
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
              'أدخل بياناتك للانضمام إلى منصة إمتلاك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 24),
            AuthFormField(
              controller: _fullNameController,
              hintText: 'الاسم الكامل',
              prefixIcon: Icons.person_outline,
              fieldType: AuthFieldType.name,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _emailController,
              hintText: 'البريد الإلكتروني',
              prefixIcon: Icons.email_outlined,
              fieldType: AuthFieldType.email,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _phoneController,
              hintText: 'رقم الهاتف',
              prefixIcon: Icons.phone_outlined,
              fieldType: AuthFieldType.phone,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _passwordController,
              hintText: 'كلمة المرور',
              prefixIcon: Icons.lock_outline,
              fieldType: AuthFieldType.password,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _confirmPasswordController,
              hintText: 'تأكيد كلمة المرور',
              prefixIcon: Icons.lock_reset_outlined,
              fieldType: AuthFieldType.confirmPassword,
              compareValue: _passwordController.text,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'إنشاء الحساب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                const Text(
                  'لديك حساب بالفعل؟ ',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWideLayout = constraints.maxWidth >= 900;

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
                                  child: _buildBrandSection(),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(flex: 3, child: _buildFormCard()),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 12),
                              _buildBrandSection(),
                              const SizedBox(height: 24),
                              _buildFormCard(),
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
