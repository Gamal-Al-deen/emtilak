import 'package:flutter/material.dart';

class BuildingsEmptyState extends StatelessWidget {
  final String message;

  const BuildingsEmptyState({
    super.key,
    this.message = 'لا توجد مباني مطابقة للبحث',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'Cairo',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
