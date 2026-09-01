import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/unit/unit_card.dart';

class UnitsGridPage extends StatelessWidget {
  const UnitsGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive building name dynamically from route arguments!
    final buildingName = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'عمارة القدس';

    final units = [
      {'number': 'A101', 'status': 'مؤجرة', 'color': AppColors.rented},
      {'number': 'A102', 'status': 'مؤجرة', 'color': AppColors.rented},
      {'number': 'A103', 'status': 'فارغة', 'color': AppColors.vacant},
      {'number': 'A104', 'status': 'مؤجرة', 'color': AppColors.rented},
      {'number': 'A105', 'status': 'قيد التجهيز', 'color': AppColors.preparing},
      {'number': 'A106', 'status': 'صيانة', 'color': AppColors.maintenance},
      {'number': 'B101', 'status': 'مؤجرة', 'color': AppColors.rented},
      {'number': 'B102', 'status': 'فارغة', 'color': AppColors.vacant},
      {'number': 'B103', 'status': 'مؤجرة', 'color': AppColors.rented},
      {'number': 'B104', 'status': 'مؤجرة', 'color': AppColors.rented},
      {'number': 'B105', 'status': 'فارغة', 'color': AppColors.vacant},
      {'number': 'B106', 'status': 'مؤجرة', 'color': AppColors.rented},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'وحدات $buildingName'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown & Building Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    buildingName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const Icon(Icons.apartment, color: AppColors.primary),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Color status indicator legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend('مؤجرة', AppColors.rented),
                _buildLegend('قيد التجهيز', AppColors.preparing),
                _buildLegend('فارغة', AppColors.vacant),
                _buildLegend('صيانة', AppColors.maintenance),
              ],
            ),
            const SizedBox(height: 16),

            // Grid View
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: units.length,
                itemBuilder: (context, index) {
                  final u = units[index];
                  return UnitCard(
                    unitNumber: u['number'] as String,
                    statusText: u['status'] as String,
                    statusColor: u['color'] as Color,
                    onTap: () {
                      _showUnitOptionsModal(context, u['number'] as String);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Cairo'),
        ),
      ],
    );
  }

  void _showUnitOptionsModal(BuildContext context, String unitNumber) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'خيارات الوحدة $unitNumber',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppColors.primary),
                title: const Text('عرض التفاصيل والعقد', style: TextStyle(fontFamily: 'Cairo')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/unit-details', arguments: unitNumber);
                },
              ),
              ListTile(
                leading: const Icon(Icons.change_circle_outlined, color: AppColors.gold),
                title: const Text('تغيير حالة الوحدة', style: TextStyle(fontFamily: 'Cairo')),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.build_outlined, color: AppColors.maintenance),
                title: const Text('تسجيل مصروف صيانة', style: TextStyle(fontFamily: 'Cairo')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add-maintenance');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
