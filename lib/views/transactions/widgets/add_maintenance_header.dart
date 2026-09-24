import 'package:flutter/material.dart';

class AddMaintenanceHeader extends StatelessWidget {
  const AddMaintenanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل مصروف الصيانة / الترميم',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
