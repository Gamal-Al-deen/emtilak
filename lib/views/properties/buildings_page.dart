import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../mockData/mock_data_service.dart';
import '../../models/app_models.dart';
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
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
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

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              // Top Search & Add Bar
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
                  const SizedBox(width: 12),
                  FloatingActionButton.small(
                    backgroundColor: AppColors.gold,
                    elevation: 2,
                    onPressed: _showAddBuildingDialog,
                    child: const Icon(Icons.add, color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Building Cards (List on mobile, Responsive Grid on Wide Screens)
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
                    : isWide
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isDesktop(context) ||
                                      Responsive.isLargeDesktop(context)
                                  ? 3
                                  : 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: filteredBuildings.length,
                            itemBuilder: (context, index) {
                              return _buildBuildingCard(context, filteredBuildings[index]);
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredBuildings.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildBuildingCard(
                                  context,
                                  filteredBuildings[index],
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

  Widget _buildBuildingCard(BuildContext context, Building b) {
    final buildingUnits = _dataService.getUnitsForBuilding(b.name);
    final total = buildingUnits.isNotEmpty ? buildingUnits.length : b.totalUnits;
    final rented = buildingUnits.where((u) => u.status == 'مؤجرة').length;
    final vacant = buildingUnits.where((u) => u.status == 'فارغة').length;

    return Container(
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      b.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      b.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem('$total', 'إجمالي الوحدات'),
                        _buildInfoItem('$rented', 'مؤجرة', color: AppColors.rented),
                        _buildInfoItem('$vacant', 'فارغة', color: AppColors.vacant),
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
  }

  Widget _buildInfoItem(String count, String label, {Color? color}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 13,
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
