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
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'العقد النشط حالياً',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Cairo',
            ),
          ),
          Divider(height: 20, color: Theme.of(context).colorScheme.outlineVariant),
          _buildRow(
            context,
            'المستأجر',
            unit.currentTenant ?? activeContract.tenantName,
          ),
          _buildRow(
            context,
            'قيمة الإيجار',
            '${(unit.monthlyRent > 0 ? unit.monthlyRent : activeContract.monthlyRent).toInt()} \$ / شهرياً',
          ),
          _buildRow(context, 'تاريخ بداية العقد', activeContract.startDate),
          _buildRow(context, 'تاريخ نهاية العقد', activeContract.endDate),
          _buildRow(
            context,
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

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Theme.of(context).colorScheme.onSurface,
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
