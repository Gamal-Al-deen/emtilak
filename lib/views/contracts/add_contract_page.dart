import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/common/custom_app_bar.dart';

class AddContractPage extends StatefulWidget {
  const AddContractPage({super.key});

  @override
  State<AddContractPage> createState() => _AddContractPageState();
}

class _AddContractPageState extends State<AddContractPage> {
  final _formKey = GlobalKey<FormState>();
  final _rentController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedTenant;
  String? _selectedUnit;
  String? _selectedCurrency = 'USD';

  final List<String> _tenants = ['محمد أحمد', 'أحمد علي', 'عبدالله حسين', 'يوسف محمد'];
  final List<String> _units = ['A101 - عمارة القدس', 'A102 - عمارة القدس', 'B101 - عمارة النور', 'B103 - عمارة الريان'];
  final List<String> _currencies = ['USD', 'SAR', 'YER'];

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
            onPrimary: Colors.white,
            surface: Colors.white,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'إنشاء عقد جديد'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('بيانات العقد'),
            const SizedBox(height: 12),

            // Tenant Dropdown
            _buildDropdown(
              label: 'المستأجر',
              hint: 'اختر المستأجر',
              value: _selectedTenant,
              items: _tenants,
              onChanged: (v) => setState(() => _selectedTenant = v),
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 12),

            // Unit Dropdown
            _buildDropdown(
              label: 'الوحدة',
              hint: 'اختر الوحدة',
              value: _selectedUnit,
              items: _units,
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
                    icon: Icons.attach_money,
                    validator: (v) => v == null || v.isEmpty ? 'أدخل قيمة الإيجار' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    label: 'العملة',
                    hint: 'العملة',
                    value: _selectedCurrency,
                    items: _currencies,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إنشاء العقد بنجاح!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('حفظ العقد', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            hint: Text(hint, style: const TextStyle(fontSize: 13, color: AppColors.textLight, fontFamily: 'Cairo')),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)))).toList(),
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
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight, fontFamily: 'Cairo'),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
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
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Cairo')),
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
                const Icon(Icons.calendar_month_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  date != null ? '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}' : 'اختر تاريخ',
                  style: TextStyle(
                    fontSize: 13,
                    color: date != null ? AppColors.textPrimary : AppColors.textLight,
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
