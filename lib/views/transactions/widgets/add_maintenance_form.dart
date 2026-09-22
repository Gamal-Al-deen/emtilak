import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class AddMaintenanceForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController descController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final String? selectedUnit;
  final List<String> unitOptions;
  final ValueChanged<String?> onUnitChanged;
  final VoidCallback? onSubmit;

  const AddMaintenanceForm({
    super.key,
    required this.formKey,
    required this.descController,
    required this.amountController,
    required this.notesController,
    required this.selectedUnit,
    required this.unitOptions,
    required this.onUnitChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'وصف المصروف',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: descController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'أدخل وصف المصروف' : null,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'مثال: إصلاح سباكة الشقة، دهان الممر...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontFamily: 'Cairo',
                  ),
                  prefixIcon: const Icon(
                    Icons.build_outlined,
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
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'المبلغ (بالعملة الأساسية)',
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
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                decoration: InputDecoration(
                  hintText: '0.00 \$',
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
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الوحدة المرتبطة (اختياري)',
                style: TextStyle(
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
                  initialValue: unitOptions.contains(selectedUnit)
                      ? selectedUnit
                      : unitOptions.first,
                  hint: const Text(
                    'اختر وحدة أو اتركه مصروف عام',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  items: unitOptions
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onUnitChanged,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.home_work_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ملاحظات إضافية',
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
                  hintText: 'ملاحظات إضافية...',
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
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: onSubmit,
            icon: const Icon(Icons.save_outlined),
            label: const Text(
              'حفظ المصروف',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
