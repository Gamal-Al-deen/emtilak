import 'package:flutter/material.dart';

class AddPaymentTenantContractSection extends StatelessWidget {
  final String? selectedTenant;
  final String? selectedContract;
  final List<String> tenantOptions;
  final List<String> contractOptions;
  final ValueChanged<String?> onTenantChanged;
  final ValueChanged<String?> onContractChanged;

  const AddPaymentTenantContractSection({
    super.key,
    required this.selectedTenant,
    required this.selectedContract,
    required this.tenantOptions,
    required this.contractOptions,
    required this.onTenantChanged,
    required this.onContractChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(
          context,
          label: 'المستأجر',
          hint: 'اختر المستأجر',
          value: selectedTenant,
          items: tenantOptions.isNotEmpty ? tenantOptions : ['مستأجر عام'],
          onChanged: onTenantChanged,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          context,
          label: 'العقد المرتبط',
          hint: 'اختر العقد',
          value: selectedContract,
          items: contractOptions.isNotEmpty ? contractOptions : ['عقد عام'],
          onChanged: onContractChanged,
          icon: Icons.assignment_outlined,
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
}
