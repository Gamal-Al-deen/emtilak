import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../routes/routes.dart';
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

  @override
  Widget build(BuildContext context) {
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
