import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../routes/routes.dart';

class DashboardMobileQuickActions extends StatelessWidget {
  const DashboardMobileQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addPayment);
            },
            icon: const Icon(Icons.add_card, size: 18),
            label: const Text(
              'تسجيل دفعة',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addContract);
            },
            icon: const Icon(
              Icons.note_add_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            label: const Text(
              'عقد جديد',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardWideQuickActions extends StatelessWidget {
  const DashboardWideQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addPayment);
            },
            icon: const Icon(Icons.add_card, size: 20),
            label: const Text(
              'تسجيل دفعة جديدة',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addContract);
            },
            icon: const Icon(Icons.note_add_outlined, color: AppColors.primary, size: 20),
            label: const Text(
              'إنشاء عقد جديد',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addMaintenance);
            },
            icon: const Icon(Icons.build_outlined, color: AppColors.textSecondary, size: 20),
            label: const Text(
              'تسجيل مصروف صيانة',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
