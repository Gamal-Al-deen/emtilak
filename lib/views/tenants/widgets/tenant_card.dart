import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../models/app_models.dart';

class TenantCard extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onViewStatement;

  const TenantCard({
    super.key,
    required this.tenant,
    required this.onTap,
    required this.onCall,
    required this.onViewStatement,
  });

  @override
  Widget build(BuildContext context) {
    final t = tenant;
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: AppColors.divider,
          child: Icon(
            Icons.person,
            color: AppColors.textSecondary,
          ),
        ),
        title: Text(
          t.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          t.unitName,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.phone_outlined,
                color: AppColors.primary,
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
