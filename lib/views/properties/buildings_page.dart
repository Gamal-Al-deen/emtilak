import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../mockData/mock_data_service.dart';
import '../../routes/routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_search_field.dart';

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  final MockDataService _dataService = MockDataService.instance;
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

  void _showAddBuildingDialog() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final totalCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'إضافة مبنى جديد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthFormField(
                    controller: nameCtrl,
                    hintText: 'اسم المبنى (مثال: عمارة السلام)',
                    fieldType: AuthFieldType.name,
                    prefixIcon: Icons.domain_outlined,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: locCtrl,
                    hintText: 'العنوان / الموقع',
                    fieldType: AuthFieldType.text,
                    prefixIcon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: totalCtrl,
                    hintText: 'عدد الوحدات الكلي',
                    fieldType: AuthFieldType.number,
                    prefixIcon: Icons.numbers_outlined,
                  ),
                ],
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
                  final totalInt = int.tryParse(totalCtrl.text.trim()) ?? 1;
                  _dataService.addBuilding(
                    name: nameCtrl.text.trim(),
                    location: locCtrl.text.trim(),
                    totalUnits: totalInt,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إضافة المبنى بنجاح!'),
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
  }

  @override
  Widget build(BuildContext context) {
    final allBuildings = _dataService.buildings;
    final filteredBuildings = _searchQuery.isEmpty
        ? allBuildings
        : allBuildings
              .where(
                (b) =>
                    b.name.contains(_searchQuery) ||
                    b.location.contains(_searchQuery),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    hintText: 'بحث عن مبنى...',
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  backgroundColor: AppColors.gold,
                  elevation: 2,
                  onPressed: _showAddBuildingDialog,
                  child: const Icon(Icons.add, color: AppColors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredBuildings.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد مباني مطابقة للبحث',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredBuildings.length,
                      itemBuilder: (context, index) {
                        final b = filteredBuildings[index];
                        final buildingUnits = _dataService.getUnitsForBuilding(
                          b.name,
                        );
                        final total = buildingUnits.isNotEmpty
                            ? buildingUnits.length
                            : b.totalUnits;
                        final rented = buildingUnits
                            .where((u) => u.status == 'مؤجرة')
                            .length;
                        final vacant = buildingUnits
                            .where((u) => u.status == 'فارغة')
                            .length;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.unitsGrid,
                                arguments: b.name,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.apartment_rounded,
                                      color: AppColors.primary,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          b.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        Text(
                                          b.location,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildInfoItem(
                                              '$total',
                                              'إجمالي الوحدات',
                                            ),
                                            _buildInfoItem(
                                              '$rented',
                                              'مؤجرة',
                                              color: AppColors.rented,
                                            ),
                                            _buildInfoItem(
                                              '$vacant',
                                              'فارغة',
                                              color: AppColors.vacant,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String count, String label, {Color? color}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
