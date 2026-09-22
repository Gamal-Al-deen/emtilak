import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
        ...children,
      ],
    );
  }
}
