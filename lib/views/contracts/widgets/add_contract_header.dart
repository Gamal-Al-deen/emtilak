import 'package:flutter/material.dart';

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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Cairo',
          ),
        ),
        if (onClose != null)
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurfaceVariant),
            splashRadius: 20,
          ),
      ],
    );
  }
}
