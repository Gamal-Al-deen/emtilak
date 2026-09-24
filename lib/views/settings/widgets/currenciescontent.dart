import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../models/app_models.dart';
import '../../../widgets/auth/auth_text_field.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'add_currency_dialog.dart';
import 'currencies_empty_state.dart';
import 'currency_tile.dart';

class CurrenciesContent extends StatefulWidget {
  const CurrenciesContent({super.key});

  @override
  State<CurrenciesContent> createState() => _CurrenciesContentState();
}

class _CurrenciesContentState extends State<CurrenciesContent> {
  final AppControllers _dataService = AppControllers.instance;

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showAddCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddCurrencyDialog(
          onSubmit: ({
            required String code,
            required String name,
            required String symbol,
            required double rate,
          }) {
            _dataService.addCurrency(
              code: code,
              name: name,
              symbol: symbol,
              rate: rate,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة العملة بنجاح!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  void _showEditRateDialog(CurrencyModel c) {
    final formKey = GlobalKey<FormState>();
    final rateController = TextEditingController(text: c.rate.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text(
            'تعديل سعر صرف ${c.name}',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: AuthFormField(
                controller: rateController,
                hintText: 'سعر الصرف الجديد',
                fieldType: AuthFieldType.number,
                prefixIcon: Icons.currency_exchange,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newRate =
                      double.tryParse(rateController.text.trim()) ?? c.rate;
                  _dataService.updateCurrencyRate(c.code, newRate);
                  Navigator.pop(context);
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencies = _dataService.currencies;
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: 'إدارة العملات وأسعار الصرف'),
      body: ResponsiveContainer(
        maxWidth: 1000,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'العملة الأساسية هي التي تُستخدم في التقارير المالية وحسابات الصافي.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: currencies.isEmpty
                    ? const CurrenciesEmptyState()
                    : ListView.builder(
                        itemCount: currencies.length,
                        itemBuilder: (context, index) {
                          final c = currencies[index];
                          return CurrencyTile(
                            currency: c,
                            onSetBase: () {
                              _dataService.setBaseCurrency(c.code);
                            },
                            onEditRate: () {
                              _showEditRateDialog(c);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        onPressed: _showAddCurrencyDialog,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          'إضافة عملة',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
