import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_search_field.dart';

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  final List<Map<String, String>> buildings = [
    {
      'name': 'عمارة القدس',
      'location': 'صنعاء - حدة',
      'total': '15',
      'rented': '12',
      'vacant': '3',
    },
    {
      'name': 'عمارة النور',
      'location': 'صنعاء - الجامعة',
      'total': '10',
      'rented': '8',
      'vacant': '2',
    },
    {
      'name': 'عمارة الريان',
      'location': 'صنعاء - بيت بوس',
      'total': '8',
      'rented': '6',
      'vacant': '2',
    },
  ];

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
          title: const Text('إضافة مبنى جديد', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
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
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final totalStr = totalCtrl.text.trim();
                  setState(() {
                    buildings.add({
                      'name': nameCtrl.text.trim(),
                      'location': locCtrl.text.trim(),
                      'total': totalStr,
                      'rented': '0',
                      'vacant': totalStr,
                    });
                  });
                  Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: CustomSearchField(hintText: 'بحث عن مبنى...'),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  backgroundColor: AppColors.gold,
                  elevation: 2,
                  onPressed: _showAddBuildingDialog,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: buildings.length,
                itemBuilder: (context, index) {
                  final b = buildings[index];
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
                        // Pass building name in arguments so the units grid reflects the selected building correctly!
                        Navigator.pushNamed(context, '/units-grid', arguments: b['name']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  Text(
                                    b['location']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem(b['total']!, 'إجمالي الوحدات'),
                                      _buildInfoItem(b['rented']!, 'مؤجرة', color: AppColors.rented),
                                      _buildInfoItem(b['vacant']!, 'فارغة', color: AppColors.vacant),
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
