import 'package:flutter/material.dart';
import '../../../routes/routes.dart';
import '../../../models/app_models.dart';

class UnitDetailsActions extends StatelessWidget {
  final Unit unit;
  final Contract activeContract;

  const UnitDetailsActions({
    super.key,
    required this.unit,
    required this.activeContract,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (unit.currentTenant != null ||
            activeContract.tenantName.isNotEmpty) ...[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.tenantStatement,
                arguments: unit.currentTenant ?? activeContract.tenantName,
              );
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text(
              'عرض كشف حساب المستأجر',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addMaintenance);
          },
          icon: Icon(Icons.build_outlined, color: Theme.of(context).colorScheme.primary),
          label: Text(
            'تسجيل مصروف صيانة للوحدة',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
