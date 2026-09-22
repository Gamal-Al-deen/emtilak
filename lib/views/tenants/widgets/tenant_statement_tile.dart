import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../models/app_models.dart';

class TenantStatementTile extends StatelessWidget {
  final Payment payment;

  const TenantStatementTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final p = payment;
    final isPaid = p.status == 'مدفوع';

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            isPaid ? Icons.arrow_downward : Icons.arrow_upward,
            color: isPaid ? AppColors.success : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'دفعة عن ${p.contractInfo} (${p.method})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  p.paymentDate,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+ ${p.amount.toInt()} ${p.currency}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isPaid ? AppColors.success : AppColors.error,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                'الحالة: ${p.status}',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
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
