import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class UnitsGridHeader extends StatelessWidget {
  final String buildingName;
  final int unitsCount;

  const UnitsGridHeader({
    super.key,
    required this.buildingName,
    required this.unitsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            buildingName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Cairo',
            ),
          ),
          Row(
            children: [
              Text(
                '$unitsCount وحدة',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.apartment, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class UnitsGridLegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const UnitsGridLegendItem({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

class UnitsGridLegend extends StatelessWidget {
  const UnitsGridLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      spacing: 16,
      runSpacing: 8,
      children: [
        UnitsGridLegendItem(label: 'مؤجرة', color: AppColors.rented),
        UnitsGridLegendItem(label: 'قيد التجهيز', color: AppColors.preparing),
        UnitsGridLegendItem(label: 'فارغة', color: AppColors.vacant),
        UnitsGridLegendItem(label: 'صيانة', color: AppColors.maintenance),
      ],
    );
  }
}

class UnitsGridEmptyState extends StatelessWidget {
  final VoidCallback onAddUnit;

  const UnitsGridEmptyState({
    super.key,
    required this.onAddUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'لا توجد وحدات مسجلة لهذا المبنى',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onAddUnit,
            icon: const Icon(Icons.add),
            label: const Text('إضافة وحدة جديدة'),
          ),
        ],
      ),
    );
  }
}
