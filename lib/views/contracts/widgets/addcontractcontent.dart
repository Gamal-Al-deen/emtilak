import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'add_contract_header.dart';
import 'add_contract_form.dart';
import 'add_contract_summary.dart';

class AddContractContent extends StatefulWidget {
  const AddContractContent({super.key});

  @override
  State<AddContractContent> createState() => _AddContractContentState();
}

class _AddContractContentState extends State<AddContractContent> {
  final AppControllers _dataService = AppControllers.instance;
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
    final vacantUnits = _dataService.units.where((u) => u.status == 'فارغة').toList();
    if (vacantUnits.isNotEmpty) {
      _selectedUnit =
          '${vacantUnits.first.number} - ${vacantUnits.first.buildingName}';
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
      // التقويم يتبع ثيم التطبيق تلقائيًا (فاتح/داكن) — لا فرض وضع فاتح يدويًا.
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final rent =
          double.tryParse(_rentController.text.trim()) ?? 0.0;
      final startFormatted = _startDate != null
          ? '${_startDate!.year}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.day.toString().padLeft(2, '0')}'
          : '2024/05/01';
      final endFormatted = _endDate != null
          ? '${_endDate!.year}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.day.toString().padLeft(2, '0')}'
          : '2025/05/01';

      final vacantUnits = _dataService.units.where((u) => u.status == 'فارغة').toList();
      final matchedUnit = _dataService.units.cast<dynamic>().firstWhere(
        (u) => '${u.number} - ${u.buildingName}' == _selectedUnit,
        orElse: () => vacantUnits.isNotEmpty ? vacantUnits.first : null,
      );

      final selectedUnitStr = _selectedUnit ?? (matchedUnit != null ? '${matchedUnit.number} - ${matchedUnit.buildingName}' : '');
      final bName = matchedUnit?.buildingName ?? (selectedUnitStr.contains('-') ? selectedUnitStr.split('-').last.trim() : '');

      final error = await _dataService.addContract(
        tenantName: _selectedTenant ?? 'مستأجر عام',
        unitName: selectedUnitStr,
        buildingName: bName,
        monthlyRent: rent,
        currency: _selectedCurrency ?? 'USD',
        startDate: startFormatted,
        endDate: endFormatted,
        notes: _notesController.text.trim(),
        unitId: matchedUnit?.id,
      );

      if (!mounted) return;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء وحفظ العقد بنجاح!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tenantOptions = _dataService.tenants.map((t) => t.name).toList();
    final vacantUnits = _dataService.units.where((u) => u.status == 'فارغة').toList();
    final unitOptions = vacantUnits
        .map((u) => '${u.number} - ${u.buildingName}')
        .toList();
    final currencyOptions = _dataService.currencies.map((c) => c.code).toList();
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: 'إنشاء عقد جديد'),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          children: [
            AddContractHeader(
              title: 'بيانات العقد',
              onClose: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            AddContractForm(
              formKey: _formKey,
              notesController: _notesController,
              selectedTenant: _selectedTenant,
              selectedUnit: _selectedUnit,
              tenantOptions: tenantOptions,
              unitOptions: unitOptions,
              onTenantChanged: (v) => setState(() => _selectedTenant = v),
              onUnitChanged: (v) => setState(() => _selectedUnit = v),
              summarySection: AddContractSummary(
                rentController: _rentController,
                selectedCurrency: _selectedCurrency,
                currencyOptions: currencyOptions,
                onCurrencyChanged: (v) => setState(() => _selectedCurrency = v),
                startDate: _startDate,
                endDate: _endDate,
                onStartDateTapped: () => _pickDate(context, true),
                onEndDateTapped: () => _pickDate(context, false),
              ),
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
