import 'package:flutter/material.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../models/app_models.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'unit_details_header.dart';
import 'unit_details_contracts_section.dart';
import 'unit_details_payments_section.dart';
import 'unit_details_actions.dart';

class UnitDetailsContent extends StatelessWidget {
  const UnitDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final unitNumber =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'A101';
    final dataService = AppControllers.instance;

    final unit = dataService.units.firstWhere(
      (u) => u.number == unitNumber,
      orElse: () => Unit(
        id: 'u_default',
        buildingId: 'b1',
        number: unitNumber,
        buildingName: 'عمارة القدس',
        status: 'مؤجرة',
        monthlyRent: 500.0,
        currentTenant: 'محمد أحمد',
      ),
    );

    final activeContract = dataService.contracts.firstWhere(
      (c) => c.unitName.contains(unit.number),
      orElse: () => Contract(
        id: '101',
        tenantName: unit.currentTenant ?? 'بدون مستأجر',
        unitName: '${unit.number} - ${unit.buildingName}',
        buildingName: unit.buildingName,
        monthlyRent: unit.monthlyRent,
        startDate: '2024/01/01',
        endDate: '2025/12/31',
        status: unit.status == 'مؤجرة' ? 'نشط' : 'غير متوفر',
      ),
    );

    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'تفاصيل الوحدة ${unit.number}'),
      body: ResponsiveContainer(
        maxWidth: 900,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          children: [
            UnitDetailsHeader(unit: unit),
            const SizedBox(height: 16),
            UnitDetailsContractsSection(
              unit: unit,
              activeContract: activeContract,
            ),
            const SizedBox(height: 16),
            const UnitDetailsPaymentsSection(),
            UnitDetailsActions(
              unit: unit,
              activeContract: activeContract,
            ),
          ],
        ),
      ),
    );
  }
}
