import 'package:flutter/material.dart';

import '../views/onboarding/onboarding_view.dart';
import 'routes.dart';
import 'theme.dart';

class EmtilakApp extends StatelessWidget {
  const EmtilakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إمتلاك',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingView(),
      },
    );
  }
}
