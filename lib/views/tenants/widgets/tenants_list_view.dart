import 'package:flutter/material.dart';
import '../../../../utils/responsive.dart';
import '../../../../models/app_models.dart';
import 'tenant_card.dart';
import 'tenants_empty_state.dart';

class TenantsListView extends StatelessWidget {
  final List<Tenant> filteredTenants;
  final bool isWide;
  final double gridAspectRatio;
  final void Function(Tenant) onCardTap;
  final void Function(Tenant) onCall;
  final void Function(Tenant) onViewStatement;

  const TenantsListView({
    super.key,
    required this.filteredTenants,
    required this.isWide,
    required this.gridAspectRatio,
    required this.onCardTap,
    required this.onCall,
    required this.onViewStatement,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: filteredTenants.isEmpty
          ? const TenantsEmptyState()
          : isWide
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isDesktop(context) ||
                            Responsive.isLargeDesktop(context)
                        ? 3
                        : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: gridAspectRatio,
                  ),
                  itemCount: filteredTenants.length,
                  itemBuilder: (context, index) {
                    final t = filteredTenants[index];
                    return TenantCard(
                      tenant: t,
                      onTap: () => onCardTap(t),
                      onCall: () => onCall(t),
                      onViewStatement: () => onViewStatement(t),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: filteredTenants.length,
                  itemBuilder: (context, index) {
                    final t = filteredTenants[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TenantCard(
                        tenant: t,
                        onTap: () => onCardTap(t),
                        onCall: () => onCall(t),
                        onViewStatement: () => onViewStatement(t),
                      ),
                    );
                  },
                ),
    );
  }
}
