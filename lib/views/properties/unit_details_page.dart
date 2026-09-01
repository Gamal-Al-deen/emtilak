import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../widgets/common/custom_app_bar.dart';

class UnitDetailsPage extends StatelessWidget {
  const UnitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final unitNumber = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'A101';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'تفاصيل الوحدة $unitNumber'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Unit Header Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'شقة رقم $unitNumber',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Cairo'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.rented.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'مؤجرة',
                        style: TextStyle(color: AppColors.rented, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.apartment_rounded, color: AppColors.textSecondary, size: 16),
                    SizedBox(width: 6),
                    Text('عمارة القدس - الطابق الأول', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Cairo', fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Active Contract Details Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('العقد النشط حالياً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary, fontFamily: 'Cairo')),
                const Divider(height: 20, color: AppColors.divider),
                _buildRow('المستأجر', 'محمد أحمد'),
                _buildRow('قيمة الإيجار', '500 \$ / شهرياً'),
                _buildRow('تاريخ بداية العقد', '01/01/2024'),
                _buildRow('تاريخ نهاية العقد', '31/12/2025'),
                _buildRow('حالة الدفع لشهر مايو', 'مدفوع كامل بالوقت', color: AppColors.success),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.tenantStatement, arguments: 'محمد أحمد');
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text('عرض كشف حساب المستأجر', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addMaintenance);
            },
            icon: const Icon(Icons.build_outlined, color: AppColors.primary),
            label: const Text('تسجيل مصروف صيانة للوحدة', style: TextStyle(color: AppColors.primary, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Cairo')),
          Text(value, style: TextStyle(color: color ?? AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
