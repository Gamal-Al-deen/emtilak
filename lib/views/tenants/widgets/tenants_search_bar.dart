import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../widgets/common/custom_search_field.dart';

class TenantsSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onAddPressed;

  const TenantsSearchBar({
    super.key,
    required this.onChanged,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            hintText: 'بحث عن مستأجر...',
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          backgroundColor: AppColors.gold,
          elevation: 2,
          onPressed: onAddPressed,
          child: const Icon(
            Icons.person_add_alt_1,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
