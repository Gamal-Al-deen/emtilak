import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddContractHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onClose;

  const AddContractHeader({
    super.key,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Cairo',
          ),
        ),
        if (onClose != null)
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            splashRadius: 20,
          ),
      ],
    );
  }
}
