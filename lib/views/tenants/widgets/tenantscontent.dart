import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../models/app_models.dart';
import '../../../routes/routes.dart';
import 'add_tenant_dialog.dart';
import 'tenant_details_modal.dart';
import 'tenant_card.dart';
import 'tenants_empty_state.dart';
import 'tenants_search_bar.dart';

class TenantsContent extends StatefulWidget {
  const TenantsContent({super.key});

  @override
  State<TenantsContent> createState() => _TenantsContentState();
}

class _TenantsContentState extends State<TenantsContent> {
  final AppControllers _dataService = AppControllers.instance;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showAddTenantDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTenantDialog(
          onSubmit: (name, phone, nationalId) async {
            final error = await _dataService.addTenant(
              name: name,
              phone: phone,
              nationalId: nationalId,
            );
            if (!context.mounted) return;
            if (error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إضافة المستأجر بنجاح!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showTenantDetailsModal(Tenant t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TenantDetailsModal(
          tenant: t,
          onViewStatement: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AppRoutes.tenantStatement,
              arguments: t.name,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTenants = _dataService.tenants;
    final filteredTenants = _searchQuery.isEmpty
        ? allTenants
        : allTenants
            .where(
              (t) =>
                  t.name.contains(_searchQuery) ||
                  t.phone.contains(_searchQuery),
            )
            .toList();

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    final double gridAspectRatio;
    if (Responsive.isLargeDesktop(context)) {
      gridAspectRatio = 3.0;
    } else if (Responsive.isDesktop(context)) {
      gridAspectRatio = 2.7;
    } else {
      gridAspectRatio = 2.4;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              TenantsSearchBar(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                onAddPressed: _showAddTenantDialog,
              ),
              const SizedBox(height: 16),

              Expanded(
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
                              final contracts = _dataService.getContractsForTenant(t.name);
                              final unitDisplay = contracts.isNotEmpty
                                  ? contracts.map((c) => c.unitName).join(' ، ')
                                  : 'بدون وحدة سكنية حالياً';
                              return TenantCard(
                                tenant: t,
                                unitDisplay: unitDisplay,
                                onTap: () => _showTenantDetailsModal(t),
                                onCall: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'جاري الاتصال بـ ${t.phone}...',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                onViewStatement: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.tenantStatement,
                                    arguments: {
                                      'tenantName': t.name,
                                      if (contracts.isNotEmpty)
                                        'contractId': contracts.first.id,
                                    },
                                  );
                                },
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredTenants.length,
                            itemBuilder: (context, index) {
                              final t = filteredTenants[index];
                              final contracts = _dataService.getContractsForTenant(t.name);
                              final unitDisplay = contracts.isNotEmpty
                                  ? contracts.map((c) => c.unitName).join(' ، ')
                                  : 'بدون وحدة سكنية حالياً';
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TenantCard(
                                  tenant: t,
                                  unitDisplay: unitDisplay,
                                  onTap: () => _showTenantDetailsModal(t),
                                  onCall: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'جاري الاتصال بـ ${t.phone}...',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  onViewStatement: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.tenantStatement,
                                      arguments: {
                                        'tenantName': t.name,
                                        if (contracts.isNotEmpty)
                                          'contractId': contracts.first.id,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
