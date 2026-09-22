import 'package:flutter/material.dart';
import '../../../../core/colors.dart';

class TenantStatementHeader extends StatelessWidget {
  final String tenantName;
  final String tenantUnit;

  const TenantStatementHeader({
    super.key,
    required this.tenantName,
    required this.tenantUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tenantName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                tenantUnit,
                style: const TextStyle(
                  color: AppColors.white70,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'الرصيد الحالي',
                style: TextStyle(
                  color: AppColors.white70,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                '0 \$ (مستوفى)',
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
