import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../widgets/auth/auth_text_field.dart';

class AddTenantDialog extends StatefulWidget {
  final void Function(String name, String phone, String nationalId) onSubmit;

  const AddTenantDialog({super.key, required this.onSubmit});

  @override
  State<AddTenantDialog> createState() => _AddTenantDialogState();
}

class _AddTenantDialogState extends State<AddTenantDialog> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final idCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    idCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'إضافة مستأجر جديد',
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
              widget.onSubmit(
                nameCtrl.text.trim(),
                phoneCtrl.text.trim(),
                idCtrl.text.trim(),
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
