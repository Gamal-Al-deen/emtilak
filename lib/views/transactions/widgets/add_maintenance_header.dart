import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddMaintenanceHeader extends StatelessWidget {
  const AddMaintenanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل مصروف الصيانة / الترميم',
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
