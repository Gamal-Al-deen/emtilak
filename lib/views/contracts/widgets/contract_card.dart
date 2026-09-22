import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';
import '../../../widgets/common/status_badge.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;
  final VoidCallback onTap;

  const ContractCard({
    super.key,
    required this.contract,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = contract;
    final isAct = c.status == 'نشط';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عقد #${c.id}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  StatusBadge(
                    label: c.status,
                    color: isAct ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                c.tenantName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                c.unitName,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(
                height: 12,
                color: AppColors.divider,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تاريخ النهاية',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          c.endDate,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'تاريخ البداية',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          c.startDate,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'الإيجار الشهري',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${c.monthlyRent.toInt()} ${c.currency}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
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
