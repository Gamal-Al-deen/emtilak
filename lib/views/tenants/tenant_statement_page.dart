import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../mockData/mock_data_service.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'widgets/tenant_statement_header.dart';
import 'widgets/tenant_statement_list.dart';
import 'widgets/tenant_statement_export_button.dart';

class TenantStatementPage extends StatelessWidget {
  const TenantStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tenantName =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'محمد أحمد';
    final dataService = MockDataService.instance;

    final tenant = dataService.tenants.firstWhere(
      (t) => t.name == tenantName,
      orElse: () => dataService.tenants.isNotEmpty
          ? dataService.tenants.first
          : null as dynamic,
    );

    final tenantUnit = tenant.unitName;
    final tenantPayments = dataService.payments
        .where((p) => p.tenantName == tenantName)
        .toList();

    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'كشف حساب: $tenantName'),
      body: ResponsiveContainer(
        maxWidth: 900,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              TenantStatementHeader(
                tenantName: tenantName,
                tenantUnit: tenantUnit,
              ),
              const SizedBox(height: 16),
              TenantStatementList(payments: tenantPayments),
              const SizedBox(height: 12),
              TenantStatementExportButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('جاري تصدير كشف الحساب كملف PDF...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
