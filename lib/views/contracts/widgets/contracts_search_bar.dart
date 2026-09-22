import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../routes/routes.dart';
import '../../../widgets/common/custom_search_field.dart';

class ContractsSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const ContractsSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            hintText: 'بحث عن عقد...',
            onChanged: (val) {
              onChanged(val.trim());
            },
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          backgroundColor: AppColors.gold,
          elevation: 2,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addContract);
          },
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ],
    );
  }
}
