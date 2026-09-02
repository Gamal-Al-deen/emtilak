import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../mockData/mock_data_service.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';

class AddContractPage extends StatefulWidget {
  const AddContractPage({super.key});

  @override
  State<AddContractPage> createState() => _AddContractPageState();
}

class _AddContractPageState extends State<AddContractPage> {
  final MockDataService _dataService = MockDataService.instance;
  final _formKey = GlobalKey<FormState>();
  final _rentController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedTenant;
  String? _selectedUnit;
  String? _selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    if (_dataService.tenants.isNotEmpty) {
      _selectedTenant = _dataService.tenants.first.name;
    }
    if (_dataService.units.isNotEmpty) {
      _selectedUnit =
          '${_dataService.units.first.number} - ${_dataService.units.first.buildingName}';
    }
  }

  @override
  void dispose() {
    _rentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantOptions = _dataService.tenants.map((t) => t.name).toList();
    final unitOptions = _dataService.units
        .map((u) => '${u.number} - ${u.buildingName}')
        .toList();
    final currencyOptions = _dataService.currencies.map((c) => c.code).toList();
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'إنشاء عقد جديد'),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            children: [
              _buildSectionTitle('بيانات العقد'),
              const SizedBox(height: 12),

              // Tenant Dropdown
              _buildDropdown(
                label: 'المستأجر',
                hint: 'اختر المستأجر',
                value: _selectedTenant,
                items: tenantOptions.isNotEmpty
                    ? tenantOptions
                    : ['مستأجر افتراضي'],
                onChanged: (v) => setState(() => _selectedTenant = v),
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 12),

              // Unit Dropdown
              _buildDropdown(
                label: 'الوحدة',
                hint: 'اختر الوحدة',
                value: _selectedUnit,
                items: unitOptions.isNotEmpty ? unitOptions : ['وحدة افتراضية'],
                onChanged: (v) => setState(() => _selectedUnit = v),
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: 12),

              // Rent Amount + Currency Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _rentController,
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
                      label: 'العملة',
                      hint: 'العملة',
                      value: _selectedCurrency,
                      items: currencyOptions.isNotEmpty
                          ? currencyOptions
                          : ['USD', 'SAR', 'YER'],
                      onChanged: (v) => setState(() => _selectedCurrency = v),
                      icon: Icons.currency_exchange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date Range Row
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: 'تاريخ البداية',
                      date: _startDate,
                      onTap: () => _pickDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatePicker(
                      label: 'تاريخ النهاية',
                      date: _endDate,
                      onTap: () => _pickDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Notes
              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات',
                hint: 'أي ملاحظات إضافية...',
                maxLines: 3,
                icon: Icons.notes_outlined,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final rent =
                        double.tryParse(_rentController.text.trim()) ?? 0.0;
                    final startFormatted = _startDate != null
                        ? '${_startDate!.year}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.day.toString().padLeft(2, '0')}'
                        : '2024/05/01';
                    final endFormatted = _endDate != null
                        ? '${_endDate!.year}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.day.toString().padLeft(2, '0')}'
                        : '2025/05/01';

                    final selectedUnitStr = _selectedUnit ?? 'A101';
                    final bName = selectedUnitStr.contains('-')
                        ? selectedUnitStr.split('-').last.trim()
                        : 'عمارة عامة';

                    _dataService.addContract(
                      tenantName: _selectedTenant ?? 'مستأجر عام',
                      unitName: selectedUnitStr,
                      buildingName: bName,
                      monthlyRent: rent,
                      currency: _selectedCurrency ?? 'USD',
                      startDate: startFormatted,
                      endDate: endFormatted,
                      notes: _notesController.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إنشاء وحفظ العقد بنجاح!'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'حفظ العقد',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        fontFamily: 'Cairo',
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

  Widget _buildTextField({
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
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
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

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                  date != null
                      ? '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}'
                      : 'اختر تاريخ',
                  style: TextStyle(
                    fontSize: 13,
                    color: date != null
                        ? AppColors.textPrimary
                        : AppColors.textLight,
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
