import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../widgets/auth/auth_text_field.dart';

class AddCurrencyDialog extends StatefulWidget {
  final void Function({
    required String code,
    required String name,
    required String symbol,
    required double rate,
  }) onSubmit;

  const AddCurrencyDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddCurrencyDialog> createState() => _AddCurrencyDialogState();
}

class _AddCurrencyDialogState extends State<AddCurrencyDialog> {
  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final symbolController = TextEditingController();
  final rateController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    symbolController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'إضافة عملة جديدة',
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
              final rate =
                  double.tryParse(rateController.text.trim()) ?? 1.0;
              widget.onSubmit(
                code: codeController.text.trim().toUpperCase(),
                name: nameController.text.trim(),
                symbol: symbolController.text.trim(),
                rate: rate,
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
