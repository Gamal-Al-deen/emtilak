import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../models/app_models.dart';
import '../../../routes/routes.dart';

class UnitOptionsModal extends StatelessWidget {
  final Unit unit;
  final VoidCallback onChangeStatus;

  const UnitOptionsModal({
    super.key,
    required this.unit,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      maxWidth: 550,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'خيارات الوحدة ${unit.number} (${unit.status})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                dense: true,
                leading: Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
                title: const Text(
                  'عرض التفاصيل والعقد',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.unitDetails,
                    arguments: unit.number,
                  );
                },
              ),
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.change_circle_outlined,
                  color: AppColors.gold,
                  size: 22,
                ),
                title: const Text(
                  'تغيير حالة الوحدة',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onChangeStatus();
                },
              ),
              ListTile(
                dense: true,
                leading: const Icon(
                  Icons.build_outlined,
                  color: AppColors.maintenance,
                  size: 22,
                ),
                title: const Text(
                  'تسجيل مصروف صيانة',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.addMaintenance);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
