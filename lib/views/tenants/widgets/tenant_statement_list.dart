import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../models/app_models.dart';
import 'tenant_statement_tile.dart';

class TenantStatementList extends StatelessWidget {
  final List<Payment> payments;

  const TenantStatementList({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: payments.isEmpty
            ? const Center(
                child: Text(
                  'لا توجد حركات مسجلة لهذا المستأجر حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.separated(
                itemCount: payments.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, index) {
                  final p = payments[index];
                  return TenantStatementTile(payment: p);
                },
              ),
      ),
    );
  }
}
