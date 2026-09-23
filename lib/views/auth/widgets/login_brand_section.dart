import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../widgets/common/app_brand_logo.dart';

class LoginBrandSection extends StatelessWidget {
  const LoginBrandSection({
    super.key,
    required this.logoSize,
  });

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // حاوية الشعار مربّعة الشكل (1.5 × الحجم) مع حشو 0.12، وصورة الشعار
        // العريضة (648×429) تتمركز فيها بـ BoxFit.contain — فينتهي أسفلها
        // المرسوم عند (0.75 + 0.63 × 429/648) ÷ 1.5 من ارتفاع الحاوية.
        // نقصّ الحاوية عند هذا الموضع بالضبط عبر ClipRect + heightFactor:
        // تُرفع المساحة الشفافة أسفل الشعار فقط، ويظل الشعار بحجمه نفسه،
        // مع بقاء التخطيط في حدوده المفتوحة (بلا ضغط أعمدة يسبّب فيضًا).
        ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: (0.75 + 0.63 * (429 / 648)) / 1.5,
            child: AppBrandLogo(size: logoSize),
          ),
        ),
        const SizedBox(height: 8),
        const FractionallySizedBox(
          widthFactor: 0.8,
          child: Text(
            'منصة متكاملة لإدارة العقارات والموارد',
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
  }
}
