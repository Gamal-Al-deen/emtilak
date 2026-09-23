import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'add_payment_header.dart';
import 'add_payment_form.dart';
import 'add_payment_summary.dart';

class AddPaymentContent extends StatefulWidget {
  const AddPaymentContent({super.key});

  @override
  State<AddPaymentContent> createState() => _AddPaymentContentState();
}

class _AddPaymentContentState extends State<AddPaymentContent> {
  final AppControllers _dataService = AppControllers.instance;
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
      final tenantContracts = _dataService.getContractsForTenant(_selectedTenant!);
      if (tenantContracts.isNotEmpty) {
        final c = tenantContracts.first;
        _selectedContract = 'عقد #${c.id} (${c.unitName})';
        _amountController.text = c.monthlyRent.toInt().toString();
      }
    } else if (_dataService.contracts.isNotEmpty) {
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final amount =
          double.tryParse(_amountController.text.trim()) ?? 0.0;
      final dateFormatted =
          '${_paymentDate.year}/${_paymentDate.month.toString().padLeft(2, '0')}/${_paymentDate.day.toString().padLeft(2, '0')}';

      final tenantContracts = _dataService.getContractsForTenant(_selectedTenant ?? '');
      final matchedContract = tenantContracts.where((c) => 'عقد #${c.id} (${c.unitName})' == _selectedContract).firstOrNull ??
          (tenantContracts.isNotEmpty ? tenantContracts.first : null);

      final error = await _dataService.addPayment(
        contractId: matchedContract?.id,
        tenantName: _selectedTenant ?? 'مستأجر عام',
        contractInfo: _selectedContract ?? (matchedContract != null ? 'عقد #${matchedContract.id} (${matchedContract.unitName})' : 'عقد عام'),
        amount: amount,
        currency: _selectedCurrency == 'USD' ? '\$' : _selectedCurrency,
        paymentDate: dateFormatted,
        status: 'مدفوع',
        method: _paymentMethod,
        notes: _notesController.text.trim(),
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
            content: Text('تم تسجيل الدفعة وحفظها بنجاح!'),
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
    final tenantContracts = _dataService.getContractsForTenant(_selectedTenant ?? '');
    final contractOptions = tenantContracts.isNotEmpty
        ? tenantContracts.map((c) => 'عقد #${c.id} (${c.unitName})').toList()
        : _dataService.contracts.map((c) => 'عقد #${c.id} (${c.unitName})').toList();
    final currencyOptions = _dataService.currencies.map((c) => c.code).toList();
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'تسجيل دفعة جديدة'),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          children: [
            const AddPaymentHeader(),
            AddPaymentForm(
              formKey: _formKey,
              amountController: _amountController,
              notesController: _notesController,
              paymentDate: _paymentDate,
              selectedTenant: _selectedTenant,
              selectedContract: _selectedContract,
              selectedCurrency: _selectedCurrency,
              paymentMethod: _paymentMethod,
              tenantOptions: tenantOptions,
              contractOptions: contractOptions,
              currencyOptions: currencyOptions,
              onTenantChanged: (v) {
                setState(() {
                  _selectedTenant = v;
                  final updatedContracts = _dataService.getContractsForTenant(v ?? '');
                  if (updatedContracts.isNotEmpty) {
                    final c = updatedContracts.first;
                    _selectedContract = 'عقد #${c.id} (${c.unitName})';
                    _amountController.text = c.monthlyRent.toInt().toString();
                  } else {
                    _selectedContract = null;
                    _amountController.clear();
                  }
                });
              },
              onContractChanged: (v) {
                setState(() {
                  _selectedContract = v;
                  final contracts = _dataService.getContractsForTenant(_selectedTenant ?? '');
                  final matched = contracts.where((c) => 'عقد #${c.id} (${c.unitName})' == v).firstOrNull;
                  if (matched != null) {
                    _amountController.text = matched.monthlyRent.toInt().toString();
                  }
                });
              },
              onCurrencyChanged: (v) => setState(() => _selectedCurrency = v),
              onDateTap: () => _pickDate(context),
              onMethodChanged: (label) => setState(() => _paymentMethod = label),
            ),
            AddPaymentSummary(
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
