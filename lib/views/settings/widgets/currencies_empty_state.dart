import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class CurrenciesEmptyState extends StatelessWidget {
  final String message;

  const CurrenciesEmptyState({
    super.key,
    this.message = 'لا توجد عملات مضافة بعد',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
