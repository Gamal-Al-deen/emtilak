import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../mockData/mock_data_service.dart';
import '../../../models/app_models.dart';
import '../../../routes/routes.dart';
import '../../../widgets/common/status_badge.dart';
import 'payment_card.dart';
import 'add_payment_fab.dart';
import 'payments_empty_state.dart';
import 'payments_filter_bar.dart';

class PaymentsContent extends StatefulWidget {
  const PaymentsContent({super.key});

  @override
  State<PaymentsContent> createState() => _PaymentsContentState();
}

class _PaymentsContentState extends State<PaymentsContent> {
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

    final double gridAspectRatio;
    if (Responsive.isLargeDesktop(context)) {
      gridAspectRatio = 2.4;
    } else if (Responsive.isDesktop(context)) {
      gridAspectRatio = 2.2;
    } else {
      gridAspectRatio = 2.0;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PaymentsFilterBar(
                      onSearchChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                      selectedFilter: _selectedFilter,
                      onFilterSelected: (label) {
                        setState(() => _selectedFilter = label);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: AddPaymentFab(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.addPayment);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredPayments.isEmpty
                    ? const PaymentsEmptyState()
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
                              return PaymentCard(
                                payment: filteredPayments[index],
                                onTap: () => _showPaymentDetailsModal(
                                  filteredPayments[index],
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredPayments.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PaymentCard(
                                  payment: filteredPayments[index],
                                  onTap: () => _showPaymentDetailsModal(
                                    filteredPayments[index],
                                  ),
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
