import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../mockData/mock_data_service.dart';
import '../../models/app_models.dart';
import '../../routes/routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/unit/unit_card.dart';

class UnitsGridPage extends StatefulWidget {
  const UnitsGridPage({super.key});

  @override
  State<UnitsGridPage> createState() => _UnitsGridPageState();
}

class _UnitsGridPageState extends State<UnitsGridPage> {
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
    final formKey = GlobalKey<FormState>();
    final numberCtrl = TextEditingController();
    final rentCtrl = TextEditingController();
    String selectedStatus = 'فارغة';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                'إضافة وحدة لـ $buildingName',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AuthFormField(
                          controller: numberCtrl,
                          hintText: 'رقم الوحدة (مثال: C101)',
                          fieldType: AuthFieldType.text,
                          prefixIcon: Icons.tag,
                        ),
                        const SizedBox(height: 12),
                        AuthFormField(
                          controller: rentCtrl,
                          hintText: 'الإيجار المقترح (اختياري)',
                          fieldType: AuthFieldType.number,
                          prefixIcon: Icons.attach_money,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: selectedStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'فارغة',
                              child: Text(
                                'فارغة',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'مؤجرة',
                              child: Text(
                                'مؤجرة',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'قيد التجهيز',
                              child: Text(
                                'قيد التجهيز',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'صيانة',
                              child: Text(
                                'صيانة',
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedStatus = val);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'الحالة',
                            labelStyle: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final rent = double.tryParse(rentCtrl.text.trim()) ?? 0.0;
                      _dataService.addUnit(
                        buildingName: buildingName,
                        number: numberCtrl.text.trim(),
                        status: selectedStatus,
                        monthlyRent: rent,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إضافة الوحدة السكنية بنجاح!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showChangeStatusDialog(Unit unit) {
    String selectedStatus = unit.status;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                'تغيير حالة الوحدة ${unit.number}',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      [
                        'مؤجرة',
                        'فارغة',
                        'قيد التجهيز',
                        'صيانة',
                        'بعد الخروج',
                      ].map((st) {
                        return ListTile(
                          title: Text(
                            st,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                          leading: Icon(
                            selectedStatus == st
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selectedStatus == st
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          onTap: () {
                            setDialogState(() => selectedStatus = st);
                          },
                        );
                      }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _dataService.updateUnitStatus(unit.number, selectedStatus);
                    Navigator.pop(context);
                  },
                  child: const Text('حفظ التغيير'),
                ),
              ],
            );
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
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
                      _showChangeStatusDialog(unit);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final buildingName =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        'عمارة القدس';
    final units = _dataService.getUnitsForBuilding(buildingName);

    // Adaptive crossAxisCount based on screen size
    final int crossAxisCount;
    if (Responsive.isLargeDesktop(context)) {
      crossAxisCount = 8;
    } else if (Responsive.isDesktop(context)) {
      crossAxisCount = 6;
    } else if (Responsive.isTablet(context)) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 3; // Mobile: exactly 3 columns
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
                    Row(
                      children: [
                        Text(
                          '${units.length} وحدة',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.apartment, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Color status indicator legend (wrapped for safety on any screen)
              Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegend('مؤجرة', AppColors.rented),
                  _buildLegend('قيد التجهيز', AppColors.preparing),
                  _buildLegend('فارغة', AppColors.vacant),
                  _buildLegend('صيانة', AppColors.maintenance),
                ],
              ),
              const SizedBox(height: 16),

              // Responsive Grid View
              Expanded(
                child: units.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لا توجد وحدات مسجلة لهذا المبنى',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => _showAddUnitDialog(buildingName),
                              icon: const Icon(Icons.add),
                              label: const Text('إضافة وحدة جديدة'),
                            ),
                          ],
                        ),
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
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppColors.gold,
        onPressed: () => _showAddUnitDialog(buildingName),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
