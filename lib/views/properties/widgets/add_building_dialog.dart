import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../widgets/auth/auth_text_field.dart';

class AddBuildingDialog extends StatefulWidget {
  final void Function({
    required String name,
    required String location,
    required int totalUnits,
  }) onSubmit;

  const AddBuildingDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddBuildingDialog> createState() => _AddBuildingDialogState();
}

class _AddBuildingDialogState extends State<AddBuildingDialog> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final locCtrl = TextEditingController();
  final totalCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    locCtrl.dispose();
    totalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.onSubmit(
                name: nameCtrl.text.trim(),
                location: locCtrl.text.trim(),
                totalUnits: totalInt,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
