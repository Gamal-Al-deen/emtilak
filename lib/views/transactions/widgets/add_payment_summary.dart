import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddPaymentSummary extends StatelessWidget {
  final VoidCallback? onSubmit;

  const AddPaymentSummary({
    super.key,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onSubmit,
      icon: const Icon(Icons.print_outlined),
      label: const Text(
        'حفظ وإصدار سند قبض',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
