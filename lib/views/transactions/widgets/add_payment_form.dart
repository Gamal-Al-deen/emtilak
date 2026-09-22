import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddPaymentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final DateTime paymentDate;
  final String? selectedTenant;
  final String? selectedContract;
  final String selectedCurrency;
  final String paymentMethod;
  final List<String> tenantOptions;
  final List<String> contractOptions;
  final List<String> currencyOptions;
  final ValueChanged<String?> onTenantChanged;
  final ValueChanged<String?> onContractChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onDateTap;
  final ValueChanged<String> onMethodChanged;

  const AddPaymentForm({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.notesController,
    required this.paymentDate,
    required this.selectedTenant,
    required this.selectedContract,
    required this.selectedCurrency,
    required this.paymentMethod,
    required this.tenantOptions,
    required this.contractOptions,
    required this.currencyOptions,
    required this.onTenantChanged,
    required this.onContractChanged,
    required this.onCurrencyChanged,
    required this.onDateTap,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildDropdown(
            label: 'المستأجر',
            hint: 'اختر المستأجر',
            value: selectedTenant,
            items: tenantOptions.isNotEmpty ? tenantOptions : ['مستأجر عام'],
            onChanged: onTenantChanged,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: 'العقد المرتبط',
            hint: 'اختر العقد',
            value: selectedContract,
            items: contractOptions.isNotEmpty ? contractOptions : ['عقد عام'],
            onChanged: onContractChanged,
            icon: Icons.assignment_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المبلغ المدفوع',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'أدخل المبلغ' : null,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textLight,
                          fontFamily: 'Cairo',
                        ),
                        prefixIcon: const Icon(
                          Icons.attach_money,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildDropdown(
                  label: 'العملة',
                  hint: 'العملة',
                  value: selectedCurrency,
                  items: currencyOptions.isNotEmpty
                      ? currencyOptions
                      : ['USD', 'SAR', 'YER'],
                  onChanged: (v) => onCurrencyChanged(v!),
                  icon: Icons.currency_exchange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تاريخ الدفع',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onDateTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${paymentDate.year}/${paymentDate.month.toString().padLeft(2, '0')}/${paymentDate.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'طريقة الدفع',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMethodChip('نقداً (Cash)'),
                  _buildMethodChip('تحويل بنكي'),
                  _buildMethodChip('شيك'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ملاحظات',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: notesController,
                maxLines: 2,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'ملاحظات اختيارية...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontFamily: 'Cairo',
                  ),
                  prefixIcon: const Icon(
                    Icons.notes,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDropdown({
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
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: validValue,
            hint: Text(
              hint,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
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
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            isExpanded: true,
            dropdownColor: AppColors.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildMethodChip(String label) {
    final isSelected = paymentMethod == label;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.white : AppColors.textPrimary,
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      onSelected: (_) => onMethodChanged(label),
    );
  }
}
