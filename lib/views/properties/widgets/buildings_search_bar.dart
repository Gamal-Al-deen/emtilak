import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../widgets/common/custom_search_field.dart';

class BuildingsSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddPressed;

  const BuildingsSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            hintText: 'بحث عن مبنى...',
            onChanged: (val) {
              onSearchChanged(val.trim());
            },
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          backgroundColor: AppColors.gold,
          elevation: 2,
          onPressed: onAddPressed,
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ],
    );
  }
}
