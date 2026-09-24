import 'package:flutter/material.dart';

class TenantsEmptyState extends StatelessWidget {
  const TenantsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا يوجد مستأجرون مطابقون للبحث',
        style: TextStyle(
          fontFamily: 'Cairo',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
