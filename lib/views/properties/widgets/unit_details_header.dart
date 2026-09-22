import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';

class UnitDetailsHeader extends StatelessWidget {
  final Unit unit;

  const UnitDetailsHeader({
    super.key,
    required this.unit,
  });

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
    );
  }
}
