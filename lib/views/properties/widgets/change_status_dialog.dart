import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../models/app_models.dart';

class ChangeStatusDialog extends StatefulWidget {
  final Unit unit;
  final void Function(String newStatus) onSubmit;

  const ChangeStatusDialog({
    super.key,
    required this.unit,
    required this.onSubmit,
  });

  @override
  State<ChangeStatusDialog> createState() => _ChangeStatusDialogState();
}

class _ChangeStatusDialogState extends State<ChangeStatusDialog> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.unit.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'تغيير حالة الوحدة ${widget.unit.number}',
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'مؤجرة',
            'فارغة',
            'قيد التجهيز',
            'صيانة',
            'بعد الخروج',
          ].map((st) {
            return ListTile(
              title: Text(
                st,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
              ),
              leading: Icon(
                selectedStatus == st
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selectedStatus == st
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              onTap: () {
                setState(() => selectedStatus = st);
              },
            );
          }).toList(),
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
            widget.onSubmit(selectedStatus);
            Navigator.pop(context);
          },
          child: const Text('حفظ التغيير'),
        ),
      ],
    );
  }
}
