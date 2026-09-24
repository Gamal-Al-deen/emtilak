import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';

class CurrencyTile extends StatelessWidget {
  final CurrencyModel currency;
  final VoidCallback? onSetBase;
  final VoidCallback? onEditRate;

  const CurrencyTile({
    super.key,
    required this.currency,
    this.onSetBase,
    this.onEditRate,
  });

  @override
  Widget build(BuildContext context) {
    final isBase = currency.isBase;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBase ? AppColors.gold : Theme.of(context).colorScheme.outline,
          width: isBase ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isBase
              ? AppColors.gold
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            currency.symbol,
            style: TextStyle(
              color: isBase ? AppColors.white : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              currency.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            if (isBase)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'الأساسية',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          'الرمز: ${currency.code} | سعر الصرف: ${currency.rate}',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (val) {
            if (val == 'setBase') {
              onSetBase?.call();
            } else if (val == 'edit') {
              onEditRate?.call();
            }
          },
          itemBuilder: (context) => [
            if (!isBase)
              const PopupMenuItem(
                value: 'setBase',
                child: Text(
                  'تعيين كعملة أساسية',
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            const PopupMenuItem(
              value: 'edit',
              child: Text(
                'تعديل سعر الصرف',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
