import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class ContractsEmptyState extends StatelessWidget {
  const ContractsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا توجد عقود مطابقة للبحث',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
