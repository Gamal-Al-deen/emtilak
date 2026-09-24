import 'package:flutter/material.dart';

import '../../../../widgets/common/app_brand_logo.dart';

class ForgotPasswordBrandSection extends StatelessWidget {
  const ForgotPasswordBrandSection({
    super.key,
    required this.logoSize,
  });

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppBrandLogo(size: logoSize),
        const SizedBox(height: 16),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Text(
            'استعادة الوصول إلى حسابك بسهولة وأمان',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}
