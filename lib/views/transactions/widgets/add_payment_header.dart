import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddPaymentHeader extends StatelessWidget {
  const AddPaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بيانات الدفعة المالية',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
