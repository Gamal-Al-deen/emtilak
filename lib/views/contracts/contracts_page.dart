import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../mockData/mock_data_service.dart';
import '../../models/app_models.dart';
import '../../routes/routes.dart';
import '../../widgets/common/custom_search_field.dart';
import '../../widgets/common/status_badge.dart';

class ContractsPage extends StatefulWidget {
  const ContractsPage({super.key});

  @override
  State<ContractsPage> createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  final MockDataService _dataService = MockDataService.instance;
  String _searchQuery = '';

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

  void showContractDetailsModal(BuildContext context, Contract c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفاصيل عقد #${c.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  StatusBadge(
                    label: c.status,
                    color: c.status == 'نشط'
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.divider),
              _buildRow('اسم المستأجر', c.tenantName),
              _buildRow('الوحدة السكنية', c.unitName),
              _buildRow(
                'قيمة الإيجار الشهري',
                '${c.monthlyRent.toInt()} ${c.currency}',
                color: AppColors.gold,
              ),
              _buildRow('تاريخ بداية العقد', c.startDate),
              _buildRow('تاريخ نهاية العقد', c.endDate),
              if (c.notes != null && c.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildRow('ملاحظات', c.notes!),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.tenantStatement,
                          arguments: c.tenantName,
                        );
                      },
                      icon: const Icon(Icons.receipt_long, size: 18),
                      label: const Text(
                        'كشف الحساب',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.addPayment);
                      },
                      icon: const Icon(
                        Icons.add_card,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: const Text(
                        'تسجيل دفعة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allContracts = _dataService.contracts;
    final filteredContracts = _searchQuery.isEmpty
        ? allContracts
        : allContracts
              .where(
                (c) =>
                    c.tenantName.contains(_searchQuery) ||
                    c.unitName.contains(_searchQuery) ||
                    c.id.contains(_searchQuery),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    hintText: 'بحث عن عقد...',
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  backgroundColor: AppColors.gold,
                  elevation: 2,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addContract);
                  },
                  child: const Icon(Icons.add, color: AppColors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredContracts.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد عقود مطابقة للبحث',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredContracts.length,
                      itemBuilder: (context, index) {
                        final c = filteredContracts[index];
                        final isAct = c.status == 'نشط';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => showContractDetailsModal(context, c),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'عقد #${c.id}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      StatusBadge(
                                        label: c.status,
                                        color: isAct
                                            ? AppColors.success
                                            : AppColors.error,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.tenantName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  Text(
                                    c.unitName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  const Divider(
                                    height: 20,
                                    color: AppColors.divider,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'تاريخ النهاية',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textLight,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          Text(
                                            c.endDate,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'تاريخ البداية',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textLight,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          Text(
                                            c.startDate,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'الإيجار الشهري',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.textLight,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          Text(
                                            '${c.monthlyRent.toInt()} ${c.currency}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.gold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
