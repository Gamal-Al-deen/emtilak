import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../routes/routes.dart';
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

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
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
                                  onPasswordToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(height: 12),
                              LoginBrandSection(logoSize: logoSize),
                              const SizedBox(height: 24),
                              LoginFormCard(
                                formKey: _formKey,
                                emailPhoneController: _emailPhoneController,
                                passwordController: _passwordController,
                                obscurePassword: _obscurePassword,
                                onSubmit: _submit,
                                onPasswordToggle: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
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
