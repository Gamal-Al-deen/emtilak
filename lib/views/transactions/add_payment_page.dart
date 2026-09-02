import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../mockData/mock_data_service.dart';
import '../../widgets/common/custom_app_bar.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({super.key});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final MockDataService _dataService = MockDataService.instance;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _paymentDate = DateTime.now();
  String? _selectedTenant;
  String? _selectedContract;
  String _selectedCurrency = 'USD';
  String _paymentMethod = 'نقداً (Cash)';

  @override
  void initState() {
    super.initState();
    if (_dataService.tenants.isNotEmpty) {
      _selectedTenant = _dataService.tenants.first.name;
    }
    if (_dataService.contracts.isNotEmpty) {
      final c = _dataService.contracts.first;
      _selectedContract = 'عقد #${c.id} (${c.unitName})';
      _amountController.text = c.monthlyRent.toInt().toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _paymentDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantOptions = _dataService.tenants.map((t) => t.name).toList();
    final contractOptions = _dataService.contracts
        .map((c) => 'عقد #${c.id} (${c.unitName})')
        .toList();
    final currencyOptions = _dataService.currencies.map((c) => c.code).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'تسجيل دفعة جديدة'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'بيانات الدفعة المالية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),

            // Tenant Dropdown
            _buildDropdown(
              label: 'المستأجر',
              hint: 'اختر المستأجر',
              value: _selectedTenant,
              items: tenantOptions.isNotEmpty ? tenantOptions : ['مستأجر عام'],
              onChanged: (v) => setState(() => _selectedTenant = v),
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),

            // Contract Dropdown
            _buildDropdown(
              label: 'العقد المرتبط',
              hint: 'اختر العقد',
              value: _selectedContract,
              items: contractOptions.isNotEmpty ? contractOptions : ['عقد عام'],
              onChanged: (v) => setState(() => _selectedContract = v),
              icon: Icons.assignment_outlined,
            ),
            const SizedBox(height: 12),

            // Amount & Currency
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
                        controller: _amountController,
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
                    value: _selectedCurrency,
                    items: currencyOptions.isNotEmpty
                        ? currencyOptions
                        : ['USD', 'SAR', 'YER'],
                    onChanged: (v) => setState(() => _selectedCurrency = v!),
                    icon: Icons.currency_exchange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date Selection
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
                  onTap: () => _pickDate(context),
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
                          '${_paymentDate.year}/${_paymentDate.month.toString().padLeft(2, '0')}/${_paymentDate.day.toString().padLeft(2, '0')}',
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

            // Payment Method Selector
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
                Row(
                  children: [
                    _buildMethodChip('نقداً (Cash)'),
                    const SizedBox(width: 8),
                    _buildMethodChip('تحويل بنكي'),
                    const SizedBox(width: 8),
                    _buildMethodChip('شيك'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Notes
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
                  controller: _notesController,
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

            // Save Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final amount =
                      double.tryParse(_amountController.text.trim()) ?? 0.0;
                  final dateFormatted =
                      '${_paymentDate.year}/${_paymentDate.month.toString().padLeft(2, '0')}/${_paymentDate.day.toString().padLeft(2, '0')}';

                  _dataService.addPayment(
                    tenantName: _selectedTenant ?? 'مستأجر عام',
                    contractInfo: _selectedContract ?? 'عقد عام',
                    amount: amount,
                    currency: _selectedCurrency == 'USD'
                        ? '\$'
                        : _selectedCurrency,
                    paymentDate: dateFormatted,
                    status: 'مدفوع',
                    method: _paymentMethod,
                    notes: _notesController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تسجيل الدفعة وحفظها بنجاح!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.print_outlined),
              label: const Text(
                'حفظ وإصدار سند قبض',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
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
    final isSelected = _paymentMethod == label;
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
      onSelected: (_) => setState(() => _paymentMethod = label),
    );
  }
}
