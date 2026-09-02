import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ResponsiveContainer(
          maxWidth: 550,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: SingleChildScrollView(
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
                          fontSize: 16,
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
                  const Divider(height: 14, color: AppColors.divider),
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
                    _buildRow('ملاحظات', c.notes!),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.tenantStatement,
                              arguments: c.tenantName,
                            );
                          },
                          icon: const Icon(Icons.receipt_long, size: 16),
                          label: const Text(
                            'كشف الحساب',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, AppRoutes.addPayment);
                          },
                          icon: const Icon(
                            Icons.add_card,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            'تسجيل دفعة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    // Responsive aspect ratio for wide screens
    final double gridAspectRatio;
    if (Responsive.isLargeDesktop(context)) {
      gridAspectRatio = 1.9;
    } else if (Responsive.isDesktop(context)) {
      gridAspectRatio = 1.75;
    } else {
      gridAspectRatio = 1.6; // Tablet 2 columns
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              // Search & Add Bar
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
                  const SizedBox(width: 12),
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

              // Contracts list or grid
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
                    : isWide
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isDesktop(context) ||
                                      Responsive.isLargeDesktop(context)
                                  ? 3
                                  : 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: gridAspectRatio,
                            ),
                            itemCount: filteredContracts.length,
                            itemBuilder: (context, index) {
                              return _buildContractCard(context, filteredContracts[index]);
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredContracts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildContractCard(
                                  context,
                                  filteredContracts[index],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractCard(BuildContext context, Contract c) {
    final isAct = c.status == 'نشط';

    return Container(
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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عقد #${c.id}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  StatusBadge(
                    label: c.status,
                    color: isAct ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                c.tenantName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                c.unitName,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(
                height: 12,
                color: AppColors.divider,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'الإيجار الشهري',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLight,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${c.monthlyRent.toInt()} ${c.currency}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
