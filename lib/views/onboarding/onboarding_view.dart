import 'package:flutter/material.dart';

import '../../app/colors.dart';
import 'widgets/onboarding_page.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // يمكن إضافة عناصر أخرى لاحقاً عند استلام تصاميمها.
  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      imagePath: 'assets/images/onboarding/reports.png',
      title: 'تقارير دقيقة و واضحة',
      description: 'احصل على تقارير مالية شاملة واتخذ قراراتك\nبناءً على بيانات دقيقة.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding/onboarding_2.png',
      title: 'تتبع الإيرادات والمدفوعات',
      description: 'سجل الإيجارات والمدفوعات واطلع على التقارير\nوأصدر سندات قبض رسمية.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding/onboarding_3.png',
      title: 'إدارة عقاراتك بسهولة',
      description: 'أضف مبانيك ووحداتك وتابع حالة كل وحدة\nمن مكان واحد بكل سهولة.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleButtonPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم الوصول إلى نهاية شاشة التعريف.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 16,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    itemBuilder: (context, index) => _pages[index],
                  ),
                ),
                _PageIndicators(currentPage: _currentPage),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleButtonPressed,
                      child: Text(_currentPage == 0 ? 'ابدأ الآن' : 'التالي'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: List.generate(
        3,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? AppColors.gold : const Color(0xFFD9DEE7),
          ),
        ),
      ),
    );
  }
}
