import 'package:flutter/material.dart';
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
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: payments.isEmpty
            ? Center(
                child: Text(
                  'لا توجد حركات مسجلة لهذا المستأجر حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : ListView.separated(
                itemCount: payments.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                itemBuilder: (context, index) {
                  final p = payments[index];
                  return TenantStatementTile(payment: p);
                },
              ),
      ),
    );
  }
}
