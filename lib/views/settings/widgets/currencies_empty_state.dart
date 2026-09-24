import 'package:flutter/material.dart';

class CurrenciesEmptyState extends StatelessWidget {
  final String message;

  const CurrenciesEmptyState({
    super.key,
    this.message = 'لا توجد عملات مضافة بعد',
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
