import 'package:flutter/material.dart';
import '../../../../core/colors.dart';

class TenantStatementHeader extends StatelessWidget {
  final String tenantName;
  final String tenantUnit;
  final String balanceText;
  final String? contractInfo;

  const TenantStatementHeader({
    super.key,
    required this.tenantName,
    required this.tenantUnit,
    this.balanceText = '0 \$ (مستوفى)',
    this.contractInfo,
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
              if (contractInfo != null) ...[
                const SizedBox(height: 2),
                Text(
                  contractInfo!,
                  style: const TextStyle(
                    color: AppColors.white70,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'الرصيد / المدفوع',
                style: TextStyle(
                  color: AppColors.white70,
                  fontSize: 11,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                balanceText,
                style: const TextStyle(
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
