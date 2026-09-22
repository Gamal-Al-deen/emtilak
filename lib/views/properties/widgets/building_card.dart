import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';

class BuildingCard extends StatelessWidget {
  final Building building;
  final int totalUnits;
  final int rentedUnits;
  final int vacantUnits;
  final VoidCallback? onTap;
  final VoidCallback? onViewUnits;

  const BuildingCard({
    super.key,
    required this.building,
    required this.totalUnits,
    required this.rentedUnits,
    required this.vacantUnits,
    this.onTap,
    this.onViewUnits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      building.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      building.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem('$totalUnits', 'إجمالي الوحدات'),
                        _buildInfoItem('$rentedUnits', 'مؤجرة', color: AppColors.rented),
                        _buildInfoItem('$vacantUnits', 'فارغة', color: AppColors.vacant),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String count, String label, {Color? color}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
