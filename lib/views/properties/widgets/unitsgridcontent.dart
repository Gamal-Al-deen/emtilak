import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../mockData/mock_data_service.dart';
import '../../../models/app_models.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/unit/unit_card.dart';
import 'units_grid_header.dart';
import 'add_unit_dialog.dart';
import 'change_status_dialog.dart';
import 'unit_options_modal.dart';

class UnitsGridContent extends StatefulWidget {
  const UnitsGridContent({super.key});

  @override
  State<UnitsGridContent> createState() => _UnitsGridContentState();
}

class _UnitsGridContentState extends State<UnitsGridContent> {
  final MockDataService _dataService = MockDataService.instance;

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مؤجرة':
        return AppColors.rented;
      case 'قيد التجهيز':
        return AppColors.preparing;
      case 'فارغة':
        return AppColors.vacant;
      case 'صيانة':
        return AppColors.maintenance;
      case 'بعد الخروج':
        return AppColors.afterExit;
      default:
        return AppColors.textLight;
    }
  }

  void _showAddUnitDialog(String buildingName) {
    showDialog(
      context: context,
      builder: (context) {
        return AddUnitDialog(
          buildingName: buildingName,
          onSubmit: ({
            required String number,
            required String status,
            required double monthlyRent,
          }) {
            _dataService.addUnit(
              buildingName: buildingName,
              number: number,
              status: status,
              monthlyRent: monthlyRent,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة الوحدة السكنية بنجاح!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  void _showChangeStatusDialog(Unit unit) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangeStatusDialog(
          unit: unit,
          onSubmit: (String newStatus) {
            _dataService.updateUnitStatus(unit.number, newStatus);
          },
        );
      },
    );
  }

  void _showUnitOptionsModal(BuildContext context, Unit unit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return UnitOptionsModal(
          unit: unit,
          onChangeStatus: () => _showChangeStatusDialog(unit),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final buildingName =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        'عمارة القدس';
    final units = _dataService.getUnitsForBuilding(buildingName);

    final int crossAxisCount;
    if (Responsive.isLargeDesktop(context)) {
      crossAxisCount = 8;
    } else if (Responsive.isDesktop(context)) {
      crossAxisCount = 6;
    } else if (Responsive.isTablet(context)) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 3;
    }

    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'وحدات $buildingName',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showAddUnitDialog(buildingName),
          ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              UnitsGridHeader(
                buildingName: buildingName,
                unitsCount: units.length,
              ),
              const SizedBox(height: 16),
              const UnitsGridLegend(),
              const SizedBox(height: 16),
              Expanded(
                child: units.isEmpty
                    ? UnitsGridEmptyState(
                        onAddUnit: () => _showAddUnitDialog(buildingName),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: units.length,
                        itemBuilder: (context, index) {
                          final u = units[index];
                          return UnitCard(
                            unitNumber: u.number,
                            statusText: u.status,
                            statusColor: _getStatusColor(u.status),
                            onTap: () {
                              _showUnitOptionsModal(context, u);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColors.gold,
        onPressed: () => _showAddUnitDialog(buildingName),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
