import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  final List<Map<String, dynamic>> _currencies = [
    {
      'code': 'USD',
      'name': 'دولار أمريكي',
      'symbol': '\$',
      'isBase': true,
      'rate': '1.0',
    },
    {
      'code': 'SAR',
      'name': 'ريال سعودي',
      'symbol': '﷼',
      'isBase': false,
      'rate': '3.75',
    },
    {
      'code': 'YER',
      'name': 'ريال يمني',
      'symbol': '﷼',
      'isBase': false,
      'rate': '530.0',
    },
  ];

  void _showAddCurrencyDialog() {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final symbolController = TextEditingController();
    final rateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('إضافة عملة جديدة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthFormField(
                    controller: codeController,
                    hintText: 'رمز العملة (USD, SAR...)',
                    fieldType: AuthFieldType.text,
                    prefixIcon: Icons.code,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: nameController,
                    hintText: 'اسم العملة',
                    fieldType: AuthFieldType.name,
                    prefixIcon: Icons.label_outline,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: symbolController,
                    hintText: 'الرمز (\$, ﷼...)',
                    fieldType: AuthFieldType.text,
                    prefixIcon: Icons.monetization_on_outlined,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: rateController,
                    hintText: 'سعر الصرف مقابل الأساسية',
                    fieldType: AuthFieldType.number,
                    prefixIcon: Icons.currency_exchange,
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
                    _currencies.add({
                      'code': codeController.text,
                      'name': nameController.text,
                      'symbol': symbolController.text,
                      'isBase': false,
                      'rate': rateController.text,
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
      appBar: const CustomAppBar(title: 'إدارة العملات وأسعار الصرف'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'العملة الأساسية هي التي تُستخدم في التقارير المالية وحسابات الصافي.',
                      style: TextStyle(fontSize: 12, color: AppColors.primary, fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _currencies.length,
                itemBuilder: (context, index) {
                  final c = _currencies[index];
                  final isBase = c['isBase'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isBase ? AppColors.gold : AppColors.border, width: isBase ? 1.5 : 1),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: isBase ? AppColors.gold : AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          c['symbol'] as String,
                          style: TextStyle(
                            color: isBase ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            c['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          if (isBase)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(10)),
                              child: const Text('الأساسية', style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Cairo')),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        'الرمز: ${c['code']} | سعر الصرف: ${c['rate']}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo'),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (val) {
                          if (val == 'setBase') {
                            setState(() {
                              for (var item in _currencies) {
                                item['isBase'] = false;
                              }
                              c['isBase'] = true;
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          if (!isBase)
                            const PopupMenuItem(
                              value: 'setBase',
                              child: Text('تعيين كعملة أساسية', style: TextStyle(fontFamily: 'Cairo')),
                            ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('تعديل سعر الصرف', style: TextStyle(fontFamily: 'Cairo')),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        onPressed: _showAddCurrencyDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة عملة', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
