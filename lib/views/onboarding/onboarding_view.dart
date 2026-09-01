import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/colors.dart';
import '../../routes/routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  Future<void> _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Cairo',
      ),
      bodyTextStyle: TextStyle(
        fontSize: 14.0,
        color: AppColors.textSecondary,
        fontFamily: 'Cairo',
        height: 1.6,
      ),
      imagePadding: EdgeInsets.only(top: 40, bottom: 20),
      pageColor: AppColors.surface,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: IntroductionScreen(
              globalBackgroundColor: AppColors.surface,
              pages: [
                PageViewModel(
                  title: 'تقارير دقيقة وواضحة',
                  body:
                      'احصل على تقارير مالية شاملة واستعرض أداء عقاراتك في مكان واحد.',
                  image: Image.asset(
                    'assets/images/onboarding/reports.png',
                    height: 260,
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: 'تتبع الإيرادات والمدفوعات',
                  body:
                      'سجل الإيجارات والمدفوعات واطلع على المتأخرات وأصدر سندات قبض رسمية.',
                  image: Image.asset(
                    'assets/images/onboarding/onboarding_2.png',
                    height: 260,
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: 'إدارة عقاراتك بسهولة',
                  body:
                      'أضف مبانيك ووحداتك وتابع حالة كل وحدة بكل سهولة واحترافية.',
                  image: Image.asset(
                    'assets/images/onboarding/onboarding_3.png',
                    height: 260,
                  ),
                  decoration: pageDecoration,
                ),
              ],
              onDone: () => _onIntroEnd(context),
              onSkip: () => _onIntroEnd(context),
              showSkipButton: true,
              skip: const Text(
                'تخطي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              next: const Text(
                'التالي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              done: const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(22.0, 10.0),
                activeColor: AppColors.gold,
                color: AppColors.border,
                spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
