import 'package:flutter/material.dart';

class ContractsEmptyState extends StatelessWidget {
  const ContractsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد عقود مطابقة للبحث',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
