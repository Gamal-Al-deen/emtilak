import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class PaymentsEmptyState extends StatelessWidget {
  const PaymentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا توجد دفعات مطابقة للفلتر',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
