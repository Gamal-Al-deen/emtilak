import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../models/app_models.dart';

class TenantCard extends StatelessWidget {
  final Tenant tenant;
  final String? unitDisplay;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onViewStatement;

  const TenantCard({
    super.key,
    required this.tenant,
    this.unitDisplay,
    required this.onTap,
    required this.onCall,
    required this.onViewStatement,
  });

  @override
  Widget build(BuildContext context) {
    final t = tenant;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.outlineVariant,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          t.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          unitDisplay ?? 'بدون وحدة سكنية حالياً',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.phone_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              onPressed: onCall,
            ),
            IconButton(
              icon: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.gold,
                size: 20,
              ),
              onPressed: onViewStatement,
            ),
          ],
        ),
      ),
    );
  }
}
