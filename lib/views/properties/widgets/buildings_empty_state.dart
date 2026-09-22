import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class BuildingsEmptyState extends StatelessWidget {
  final String message;

  const BuildingsEmptyState({
    super.key,
    this.message = 'لا توجد مباني مطابقة للبحث',
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
