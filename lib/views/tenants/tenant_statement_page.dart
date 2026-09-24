import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import '../../controllers/app_controllers.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'widgets/tenant_statement_header.dart';
import 'widgets/tenant_statement_list.dart';
import 'widgets/tenant_statement_export_button.dart';

class TenantStatementPage extends StatelessWidget {
  const TenantStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String tenantName = 'محمد أحمد';
    String? contractId;
    if (args is Map) {
      tenantName = args['tenantName']?.toString() ?? 'محمد أحمد';
      contractId = args['contractId']?.toString();
    } else if (args is String) {
      tenantName = args;
    }

    final dataService = AppControllers.instance;

    final tenantContracts = dataService.getContractsForTenant(tenantName);
    final contract = contractId != null
        ? dataService.contracts.where((c) => c.id == contractId).firstOrNull
        : (tenantContracts.isNotEmpty ? tenantContracts.first : null);

    final tenantUnit = contract != null
        ? contract.unitName
        : (tenantContracts.isNotEmpty
            ? tenantContracts.map((c) => c.unitName).join(' ، ')
            : 'بدون وحدة سكنية حالياً');

    final tenantPayments = contractId != null
        ? dataService.payments
            .where((p) =>
                p.contractId == contractId ||
                (p.tenantName == tenantName &&
                    p.contractInfo.contains('#$contractId')))
            .toList()
        : dataService.payments
            .where((p) => p.tenantName == tenantName)
            .toList();

    final totalPaid = tenantPayments
        .where((p) => p.status == 'مدفوع' || p.status == 'جزئي')
        .fold(0.0, (sum, p) => sum + p.amount);

    final balanceText = '${totalPaid.toInt()} \$ (مدفوع)';
    final contractInfo = contract != null
        ? 'عقد #${contract.id} • إيجار شهري: ${contract.monthlyRent.toInt()} \$'
        : null;

    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                balanceText: balanceText,
                contractInfo: contractInfo,
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
