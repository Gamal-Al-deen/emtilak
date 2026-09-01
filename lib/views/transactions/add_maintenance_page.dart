import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/common/custom_app_bar.dart';

class AddMaintenancePage extends StatefulWidget {
  const AddMaintenancePage({super.key});

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedUnit;

  final List<String> _units = [
    'مصروف عام (بدون تحديد وحدة)',
    'A101 - عمارة القدس',
    'A102 - عمارة القدس',
    'B101 - عمارة النور',
    'B103 - عمارة الريان',
  ];

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'تسجيل مصروف صيانة'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'تفاصيل مصروف الصيانة / الترميم',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('وصف المصروف', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descController,
                  validator: (v) => v == null || v.isEmpty ? 'أدخل وصف المصروف' : null,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'مثال: إصلاح سباكة الشقة، دهان الممر...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight, fontFamily: 'Cairo'),
                    prefixIcon: const Icon(Icons.build_outlined, color: AppColors.textSecondary, size: 20),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المبلغ (بالعملة الأساسية)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'أدخل المبلغ' : null,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '0.00 \$',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight, fontFamily: 'Cairo'),
                    prefixIcon: const Icon(Icons.attach_money, color: AppColors.textSecondary, size: 20),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Unit (Optional)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الوحدة المرتبطة (اختياري)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedUnit,
                    hint: const Text('اختر وحدة أو اتركه مصروف عام', style: TextStyle(fontSize: 13, color: AppColors.textLight, fontFamily: 'Cairo')),
                    items: _units.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)))).toList(),
                    onChanged: (v) => setState(() => _selectedUnit = v),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.home_work_outlined, color: AppColors.textSecondary, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Notes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ملاحظات إضافية', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'ملاحظات إضافية...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight, fontFamily: 'Cairo'),
                    prefixIcon: const Icon(Icons.notes, color: AppColors.textSecondary, size: 20),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تسجيل مصروف الصيانة بنجاح!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('حفظ المصروف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }
}
