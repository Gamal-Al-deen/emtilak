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
                _buildFilterChip('الكل'),
                _buildFilterChip('مدفوع'),
                _buildFilterChip('متأخر'),
                _buildFilterChip('جزئي'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => onFilterSelected(label),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
