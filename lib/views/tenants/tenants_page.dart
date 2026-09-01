import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_search_field.dart';

class TenantsPage extends StatefulWidget {
  const TenantsPage({super.key});

  @override
  State<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends State<TenantsPage> {
  final List<Map<String, String>> tenants = [
    {
      'name': 'محمد أحمد',
      'phone': '777 888 999',
      'unit': 'عمارة القدس - A102',
    },
    {
      'name': 'أحمد علي',
      'phone': '711 222 333',
      'unit': 'عمارة النور - B101',
    },
    {
      'name': 'عبدالله حسين',
      'phone': '733 444 555',
      'unit': 'عمارة القدس - A101',
    },
    {
      'name': 'يوسف محمد',
      'phone': '770 666 777',
      'unit': 'عمارة الريان - B103',
    },
  ];

  void _showAddTenantDialog() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final idCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('إضافة مستأجر جديد', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthFormField(
                    controller: nameCtrl,
                    hintText: 'الاسم الكامل',
                    fieldType: AuthFieldType.name,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: phoneCtrl,
                    hintText: 'رقم الهاتف',
                    fieldType: AuthFieldType.phone,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: idCtrl,
                    hintText: 'رقم الهوية / الوثيقة',
                    fieldType: AuthFieldType.text,
                    prefixIcon: Icons.badge_outlined,
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
                  setState(() {
                    tenants.add({
                      'name': nameCtrl.text,
                      'phone': phoneCtrl.text,
                      'unit': 'بدون وحدة سكنية حالياً',
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

  void _showTenantDetailsModal(Map<String, String> t) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.divider,
                    radius: 24,
                    child: Icon(Icons.person, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      Text(t['unit']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.divider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('رقم الهاتف:', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Cairo', fontSize: 13)),
                  Text(t['phone']!, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(48)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/tenant-statement', arguments: t['name']);
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('عرض كشف الحساب التفضيلى', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
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
                  child: CustomSearchField(hintText: 'بحث عن مستأجر...'),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  backgroundColor: AppColors.gold,
                  elevation: 2,
                  onPressed: _showAddTenantDialog,
                  child: const Icon(Icons.person_add_alt_1, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, index) {
                  final t = tenants[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () => _showTenantDetailsModal(t),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.divider,
                        child: Icon(Icons.person, color: AppColors.textSecondary),
                      ),
                      title: Text(
                        t['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      subtitle: Text(
                        t['unit']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('جاري الاتصال بـ ${t['phone']}...'), behavior: SnackBarBehavior.floating),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.receipt_long_outlined, color: AppColors.gold),
                            onPressed: () {
                              Navigator.pushNamed(context, '/tenant-statement', arguments: t['name']);
                            },
                          ),
                        ],
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
}
