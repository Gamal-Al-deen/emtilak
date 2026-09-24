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
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              '$startStr - $endStr',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
