import 'package:flutter/material.dart';
import '../../../../core/colors.dart';

class TenantsEmptyState extends StatelessWidget {
  const TenantsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا يوجد مستأجرون مطابقون للبحث',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
