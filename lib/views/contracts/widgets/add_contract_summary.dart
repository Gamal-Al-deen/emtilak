import 'package:flutter/material.dart';
import '../../../widgets/auth/auth_text_field.dart';

class AddContractSummary extends StatelessWidget {
  final TextEditingController rentController;
  final String? selectedCurrency;
  final List<String> currencyOptions;
  final ValueChanged<String?> onCurrencyChanged;
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onStartDateTapped;
  final VoidCallback onEndDateTapped;

  const AddContractSummary({
    super.key,
    required this.rentController,
    required this.selectedCurrency,
    required this.currencyOptions,
    required this.onCurrencyChanged,
    required this.startDate,
    required this.endDate,
    required this.onStartDateTapped,
    required this.onEndDateTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildTextField(
                context,
                controller: rentController,
                label: 'قيمة الإيجار الشهري',
                hint: '0.00',
                keyboardType: TextInputType.number,
                fieldType: AuthFieldType.number,
                icon: Icons.attach_money,
                validator: (v) =>
                    v == null || v.isEmpty ? 'أدخل قيمة الإيجار' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildDropdown(
                context,
                label: 'العملة',
                hint: 'العملة',
                value: selectedCurrency,
                items: currencyOptions.isNotEmpty
                    ? currencyOptions
                    : ['USD', 'SAR', 'YER'],
                onChanged: onCurrencyChanged,
                icon: Icons.currency_exchange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                context,
                label: 'تاريخ البداية',
                date: startDate,
                onTap: onStartDateTapped,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDatePicker(
                context,
                label: 'تاريخ النهاية',
                date: endDate,
                onTap: onEndDateTapped,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    final validValue = items.contains(value)
        ? value
        : (items.isNotEmpty ? items.first : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: validValue,
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).hintColor,
                fontFamily: 'Cairo',
              ),
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            isExpanded: true,
            dropdownColor: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    AuthFieldType fieldType = AuthFieldType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        AuthFormField(
          controller: controller,
          hintText: hint,
          prefixIcon: icon,
          keyboardType: keyboardType,
          maxLines: maxLines,
          fieldType: fieldType,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  date != null
                      ? '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}'
                      : 'اختر تاريخ',
                  style: TextStyle(
                    fontSize: 13,
                    color: date != null
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).hintColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
