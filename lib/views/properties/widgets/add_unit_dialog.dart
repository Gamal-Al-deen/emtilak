import 'package:flutter/material.dart';
import '../../../widgets/auth/auth_text_field.dart';

class AddUnitDialog extends StatefulWidget {
  final String buildingName;
  final void Function({
    required String number,
    required String status,
    required double monthlyRent,
  }) onSubmit;

  const AddUnitDialog({
    super.key,
    required this.buildingName,
    required this.onSubmit,
  });

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final formKey = GlobalKey<FormState>();
  final numberCtrl = TextEditingController();
  final rentCtrl = TextEditingController();
  String selectedStatus = 'فارغة';

  @override
  void dispose() {
    numberCtrl.dispose();
    rentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(
        'إضافة وحدة لـ ${widget.buildingName}',
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
                      setState(() => selectedStatus = val);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'الحالة',
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
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
          child: Text(
            'إلغاء',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final rent = double.tryParse(rentCtrl.text.trim()) ?? 0.0;
              widget.onSubmit(
                number: numberCtrl.text.trim(),
                status: selectedStatus,
                monthlyRent: rent,
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
