import 'package:flutter/material.dart';

class PaymentsEmptyState extends StatelessWidget {
  const PaymentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد دفعات مطابقة للفلتر',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
