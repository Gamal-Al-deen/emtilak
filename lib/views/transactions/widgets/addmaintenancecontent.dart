import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'add_maintenance_header.dart';
import 'add_maintenance_form.dart';

class AddMaintenanceContent extends StatefulWidget {
  const AddMaintenanceContent({super.key});

  @override
  State<AddMaintenanceContent> createState() => _AddMaintenanceContentState();
}

class _AddMaintenanceContentState extends State<AddMaintenanceContent> {
  final AppControllers _dataService = AppControllers.instance;
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedUnit = 'مصروف عام (بدون تحديد وحدة)';

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final amount =
          double.tryParse(_amountController.text.trim()) ?? 0.0;
      final now = DateTime.now();
      final dateFormatted =
          '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

      _dataService.addMaintenance(
        description: _descController.text.trim(),
        amount: amount,
        unitName: _selectedUnit ?? 'مصروف عام',
        date: dateFormatted,
        notes: _notesController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تسجيل مصروف الصيانة بنجاح!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitOptions = [
      'مصروف عام (بدون تحديد وحدة)',
      ..._dataService.units.map((u) => '${u.number} - ${u.buildingName}'),
    ];
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: 'تسجيل مصروف صيانة'),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          children: [
            const AddMaintenanceHeader(),
            AddMaintenanceForm(
              formKey: _formKey,
              descController: _descController,
              amountController: _amountController,
              notesController: _notesController,
              selectedUnit: _selectedUnit,
              unitOptions: unitOptions,
              onUnitChanged: (v) => setState(() => _selectedUnit = v),
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
