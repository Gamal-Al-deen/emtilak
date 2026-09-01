import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../widgets/common/custom_search_field.dart';
import '../../widgets/common/status_badge.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  String _selectedFilter = 'الكل';

  final List<Map<String, dynamic>> allPayments = [
    {
      'tenant': 'محمد أحمد',
      'contract': '#105 - A102',
      'amount': '500 \$',
      'date': '2024/05/01',
      'status': 'مدفوع',
      'statusColor': AppColors.success,
      'method': 'نقداً (Cash)',
    },
    {
      'tenant': 'أحمد علي',
      'contract': '#104 - B101',
      'amount': '250 \$',
      'date': '2024/05/01',
      'status': 'جزئي',
      'statusColor': AppColors.warning,
      'method': 'تحويل بنكي',
    },
    {
      'tenant': 'عبدالله حسين',
      'contract': '#103 - A101',
      'amount': '500 \$',
      'date': '2024/04/30',
      'status': 'متأخر',
      'statusColor': AppColors.error,
      'method': 'غير مدفوع بعد',
    },
    {
      'tenant': 'يوسف محمد',
      'contract': '#102 - B103',
      'amount': '450 \$',
      'date': '2024/05/01',
      'status': 'مدفوع',
      'statusColor': AppColors.success,
      'method': 'نقداً (Cash)',
    },
  ];

  void _showPaymentDetailsModal(Map<String, dynamic> p) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('تفاصيل الدفعة', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Cairo')),
                  StatusBadge(label: p['status'] as String, color: p['statusColor'] as Color),
                ],
              ),
              const Divider(height: 20, color: AppColors.divider),
              _buildRow('المستأجر', p['tenant'] as String),
              _buildRow('العقد المرتبط', p['contract'] as String),
              _buildRow('المبلغ', p['amount'] as String, color: AppColors.gold),
              _buildRow('تاريخ الدفع', p['date'] as String),
              _buildRow('طريقة الدفع', p['method'] as String),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size.fromHeight(48)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('جاري تحميل وتصدير سند القبض PDF...'), behavior: SnackBarBehavior.floating),
                  );
                },
                icon: const Icon(Icons.print_outlined),
                label: const Text('طباعة / مشاركة سند القبض (PDF)', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPayments = _selectedFilter == 'الكل'
        ? allPayments
        : allPayments.where((p) => p['status'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: CustomSearchField(hintText: 'بحث عن دفعة...'),
                ),
                const SizedBox(width: 10),
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

            // Tabs filter
            SingleChildScrollView(
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
            const SizedBox(height: 16),

            Expanded(
              child: filteredPayments.isEmpty
                  ? const Center(
                      child: Text('لا توجد دفعات مطابقة للفلتر', style: TextStyle(fontFamily: 'Cairo', color: AppColors.textSecondary)),
                    )
                  : ListView.builder(
                      itemCount: filteredPayments.length,
                      itemBuilder: (context, index) {
                        final p = filteredPayments[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showPaymentDetailsModal(p),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['tenant'] as String,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        Text(
                                          p['contract'] as String,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          p['date'] as String,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textLight,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        p['amount'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      StatusBadge(
                                        label: p['status'] as String,
                                        color: p['statusColor'] as Color,
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
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
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
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Cairo')),
          Text(value, style: TextStyle(color: color ?? AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
