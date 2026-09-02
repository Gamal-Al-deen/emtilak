import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../mockData/mock_data_service.dart';
import '../../models/app_models.dart';
import '../../routes/routes.dart';
import '../../widgets/common/custom_search_field.dart';
import '../../widgets/common/status_badge.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final MockDataService _dataService = MockDataService.instance;
  String _selectedFilter = 'الكل';
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مدفوع':
        return AppColors.success;
      case 'جزئي':
        return AppColors.warning;
      case 'متأخر':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showPaymentDetailsModal(Payment p) {
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
                      const Text(
                        'تفاصيل الدفعة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      StatusBadge(
                        label: p.status,
                        color: _getStatusColor(p.status),
                      ),
                    ],
                  ),
                  const Divider(height: 14, color: AppColors.divider),
                  _buildRow('المستأجر', p.tenantName),
                  _buildRow('العقد المرتبط', p.contractInfo),
                  _buildRow(
                    'المبلغ',
                    '${p.amount.toInt()} ${p.currency}',
                    color: AppColors.gold,
                  ),
                  _buildRow('تاريخ الدفع', p.paymentDate),
                  _buildRow('طريقة الدفع', p.method),
                  if (p.notes != null && p.notes!.isNotEmpty) ...[
                    _buildRow('ملاحظات', p.notes!),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('جاري تحميل وتصدير سند القبض PDF...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.print_outlined, size: 18),
                    label: const Text(
                      'طباعة / مشاركة سند القبض (PDF)',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
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
    final allPayments = _dataService.payments;
    var filteredPayments = _selectedFilter == 'الكل'
        ? allPayments
        : allPayments.where((p) => p.status == _selectedFilter).toList();

    if (_searchQuery.isNotEmpty) {
      filteredPayments = filteredPayments
          .where(
            (p) =>
                p.tenantName.contains(_searchQuery) ||
                p.contractInfo.contains(_searchQuery),
          )
          .toList();
    }

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    // Responsive aspect ratio
    final double gridAspectRatio;
    if (Responsive.isLargeDesktop(context)) {
      gridAspectRatio = 2.4;
    } else if (Responsive.isDesktop(context)) {
      gridAspectRatio = 2.2;
    } else {
      gridAspectRatio = 2.0; // Tablet
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
                      hintText: 'بحث عن دفعة...',
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
                      Navigator.pushNamed(context, AppRoutes.addPayment);
                    },
                    child: const Icon(Icons.add, color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter Chips
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل'),
                      _buildFilterChip('مدفوع'),
                      _buildFilterChip('متأخر'),
                      _buildFilterChip('جزئي'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // List on Mobile, Responsive Grid on Wide Screens
              Expanded(
                child: filteredPayments.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد دفعات مطابقة للفلتر',
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
                            itemCount: filteredPayments.length,
                            itemBuilder: (context, index) {
                              return _buildPaymentCard(
                                context,
                                filteredPayments[index],
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredPayments.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildPaymentCard(
                                  context,
                                  filteredPayments[index],
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

  Widget _buildPaymentCard(BuildContext context, Payment p) {
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
        onTap: () => _showPaymentDetailsModal(p),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      p.tenantName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      p.contractInfo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p.paymentDate,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${p.amount.toInt()} ${p.currency}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(
                    label: p.status,
                    color: _getStatusColor(p.status),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
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
