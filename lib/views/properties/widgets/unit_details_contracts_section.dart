import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';

class UnitDetailsContractsSection extends StatelessWidget {
  final Unit unit;
  final Contract activeContract;

  const UnitDetailsContractsSection({
    super.key,
    required this.unit,
    required this.activeContract,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
