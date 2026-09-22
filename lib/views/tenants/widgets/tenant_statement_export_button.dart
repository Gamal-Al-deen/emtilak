import 'package:flutter/material.dart';
import '../../../../core/colors.dart';

class TenantStatementExportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TenantStatementExportButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(48),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.picture_as_pdf_outlined),
      label: const Text(
        'تصدير كشف الحساب (PDF)',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
