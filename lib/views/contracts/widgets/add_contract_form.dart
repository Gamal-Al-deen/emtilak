import 'package:flutter/material.dart';
import '../../../widgets/auth/auth_text_field.dart';

class AddContractForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController notesController;
  final String? selectedTenant;
  final String? selectedUnit;
  final List<String> tenantOptions;
  final List<String> unitOptions;
  final ValueChanged<String?> onTenantChanged;
  final ValueChanged<String?> onUnitChanged;
  final Widget summarySection;
  final VoidCallback onSubmit;

  const AddContractForm({
    super.key,
    required this.formKey,
    required this.notesController,
    required this.selectedTenant,
    required this.selectedUnit,
    required this.tenantOptions,
    required this.unitOptions,
    required this.onTenantChanged,
    required this.onUnitChanged,
    required this.summarySection,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            context,
            label: 'المستأجر',
            hint: 'اختر المستأجر',
            value: selectedTenant,
            items: tenantOptions.isNotEmpty
                ? tenantOptions
                : ['مستأجر افتراضي'],
            onChanged: onTenantChanged,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            context,
            label: 'الوحدة',
            hint: 'اختر الوحدة',
            value: selectedUnit,
            items: unitOptions.isNotEmpty ? unitOptions : ['وحدة افتراضية'],
            onChanged: onUnitChanged,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: 12),
          summarySection,
          const SizedBox(height: 12),
          _buildTextField(
            context,
            controller: notesController,
            label: 'ملاحظات',
            hint: 'أي ملاحظات إضافية...',
            maxLines: 3,
            icon: Icons.notes_outlined,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: onSubmit,
            icon: const Icon(Icons.save_outlined),
            label: const Text(
              'حفظ العقد',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
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
}
