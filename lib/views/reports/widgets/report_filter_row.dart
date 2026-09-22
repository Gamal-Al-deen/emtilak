import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class ReportFilterRow extends StatelessWidget {
  final String startStr;
  final String endStr;
  final VoidCallback? onTap;

  const ReportFilterRow({
    super.key,
    required this.startStr,
    required this.endStr,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_month, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              '$startStr - $endStr',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
