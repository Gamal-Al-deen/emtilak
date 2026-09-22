import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';
import '../../../widgets/common/status_badge.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback? onTap;

  const PaymentCard({
    super.key,
    required this.payment,
    this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مدفوع':
        return AppColors.success;
      case 'جزئي':
        return AppColors.warning;
      case 'متأخر':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

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
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      payment.tenantName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      payment.contractInfo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      payment.paymentDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${payment.amount.toInt()} ${payment.currency}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(
                    label: payment.status,
                    color: _getStatusColor(payment.status),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
