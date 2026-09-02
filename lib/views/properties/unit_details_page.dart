import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../mockData/mock_data_service.dart';
import '../../models/app_models.dart';
import '../../routes/routes.dart';
import '../../widgets/common/custom_app_bar.dart';

class UnitDetailsPage extends StatelessWidget {
  const UnitDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final unitNumber =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'A101';
    final dataService = MockDataService.instance;

    final unit = dataService.units.firstWhere(
      (u) => u.number == unitNumber,
      orElse: () => Unit(
        id: 'u_default',
        buildingId: 'b1',
        number: unitNumber,
        buildingName: 'عمارة القدس',
        status: 'مؤجرة',
        monthlyRent: 500.0,
        currentTenant: 'محمد أحمد',
      ),
    );

    final activeContract = dataService.contracts.firstWhere(
      (c) => c.unitName.contains(unit.number),
      orElse: () => Contract(
        id: '101',
        tenantName: unit.currentTenant ?? 'بدون مستأجر',
        unitName: '${unit.number} - ${unit.buildingName}',
        buildingName: unit.buildingName,
        monthlyRent: unit.monthlyRent,
        startDate: '2024/01/01',
        endDate: '2025/12/31',
        status: unit.status == 'مؤجرة' ? 'نشط' : 'غير متوفر',
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'تفاصيل الوحدة ${unit.number}'),
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
                      'شقة رقم ${unit.number}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.rented.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        unit.status,
                        style: const TextStyle(
                          color: AppColors.rented,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${unit.buildingName} - الطابق الأول',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
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
                const Text(
                  'العقد النشط حالياً',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const Divider(height: 20, color: AppColors.divider),
                _buildRow(
                  'المستأجر',
                  unit.currentTenant ?? activeContract.tenantName,
                ),
                _buildRow(
                  'قيمة الإيجار',
                  '${(unit.monthlyRent > 0 ? unit.monthlyRent : activeContract.monthlyRent).toInt()} \$ / شهرياً',
                ),
                _buildRow('تاريخ بداية العقد', activeContract.startDate),
                _buildRow('تاريخ نهاية العقد', activeContract.endDate),
                _buildRow(
                  'حالة العقد',
                  activeContract.status,
                  color: activeContract.status == 'نشط'
                      ? AppColors.success
                      : AppColors.error,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          if (unit.currentTenant != null ||
              activeContract.tenantName.isNotEmpty) ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.tenantStatement,
                  arguments: unit.currentTenant ?? activeContract.tenantName,
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text(
                'عرض كشف حساب المستأجر',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addMaintenance);
            },
            icon: const Icon(Icons.build_outlined, color: AppColors.primary),
            label: const Text(
              'تسجيل مصروف صيانة للوحدة',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
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
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
