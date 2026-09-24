import 'package:flutter/material.dart';

class AddPaymentHeader extends StatelessWidget {
  const AddPaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بيانات الدفعة المالية',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
