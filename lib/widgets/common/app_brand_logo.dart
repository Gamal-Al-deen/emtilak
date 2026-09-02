import 'package:flutter/material.dart';

import '../../core/colors.dart';

class AppBrandLogo extends StatelessWidget {
  final double size;
  final bool showTitle;
  final String title;
  final String subtitle;

  const AppBrandLogo({
    super.key,
    this.size = 110,
    this.showTitle = true,
    this.title = 'إمتلاك',
    this.subtitle = 'Emtilak',
  });

  @override
  Widget build(BuildContext context) {
    final logoBadge = Container(
      width: size * 1.5,
      height: size * 1.5,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        // color: AppColors.surface,
        // border: Border.all(color: AppColors.gold.withValues(alpha: 0.35), width: 2),
        // boxShadow: const [
        //   BoxShadow(
        //     color: AppColors.cardShadow,
        //     blurRadius: 18,
        //     offset: Offset(0, 8),
        //   ),
        // ],
      ),
      child: Container(
        child: Image.asset(
          'assets/images/logo-trans.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          alignment: Alignment.center,
        ),
      ),
    );

    if (!showTitle) {
      return logoBadge;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoBadge,
        // const SizedBox(height: 12),
        // Text(
        //   title,
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(
        //     fontSize: 30,
        //     fontWeight: FontWeight.bold,
        //     color: AppColors.primary,
        //     fontFamily: 'Cairo',
        //   ),
        // ),
        // const SizedBox(height: 2),
        // Text(
        //   subtitle,
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w600,
        //     color: AppColors.gold,
        //     fontFamily: 'Cairo',
        //   ),
        // ),
      ],
    );
  }
}
