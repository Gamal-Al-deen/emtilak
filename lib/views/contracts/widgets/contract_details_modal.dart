import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../models/app_models.dart';
import '../../../widgets/common/status_badge.dart';

class ContractDetailsModal extends StatelessWidget {
  final Contract contract;
  final VoidCallback onViewStatement;
  final VoidCallback onAddPayment;

  const ContractDetailsModal({
    super.key,
    required this.contract,
    required this.onViewStatement,
    required this.onAddPayment,
  });

  static Future<void> show(
    BuildContext context, {
    required Contract contract,
    required VoidCallback onViewStatement,
    required VoidCallback onAddPayment,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ContractDetailsModal(
          contract: contract,
          onViewStatement: onViewStatement,
          onAddPayment: onAddPayment,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = contract;
    return ResponsiveContainer(
      maxWidth: 550,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفاصيل عقد #${c.id}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  StatusBadge(
                    label: c.status,
                    color: c.status == 'نشط'
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ],
              ),
              Divider(height: 14, color: Theme.of(context).colorScheme.outlineVariant),
              ContractDetailsRow(
                label: 'اسم المستأجر',
                value: c.tenantName,
              ),
              ContractDetailsRow(
                label: 'الوحدة السكنية',
                value: c.unitName,
              ),
              ContractDetailsRow(
                label: 'قيمة الإيجار الشهري',
                value: '${c.monthlyRent.toInt()} ${c.currency}',
                color: AppColors.gold,
              ),
              ContractDetailsRow(
                label: 'تاريخ بداية العقد',
                value: c.startDate,
              ),
              ContractDetailsRow(
                label: 'تاريخ نهاية العقد',
                value: c.endDate,
              ),
              if (c.notes != null && c.notes!.isNotEmpty) ...[
                ContractDetailsRow(
                  label: 'ملاحظات',
                  value: c.notes!,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: onViewStatement,
                      icon: const Icon(Icons.receipt_long, size: 16),
                      label: const Text(
                        'كشف الحساب',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: onAddPayment,
                      icon: Icon(
                        Icons.add_card,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(
                        'تسجيل دفعة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
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

class ContractDetailsRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const ContractDetailsRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
