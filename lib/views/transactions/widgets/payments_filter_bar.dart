import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../widgets/common/custom_search_field.dart';

class PaymentsFilterBar extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const PaymentsFilterBar({
    super.key,
    this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchField(
          hintText: 'بحث عن دفعة...',
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, 'الكل'),
                _buildFilterChip(context, 'مدفوع'),
                _buildFilterChip(context, 'متأخر'),
                _buildFilterChip(context, 'جزئي'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => onFilterSelected(label),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
