import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddPaymentFab extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddPaymentFab({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: AppColors.gold,
      elevation: 2,
      onPressed: onPressed,
      child: const Icon(Icons.add, color: AppColors.white),
    );
  }
}
