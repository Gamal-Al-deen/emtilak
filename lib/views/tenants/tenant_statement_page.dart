import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/common/custom_app_bar.dart';

class TenantStatementPage extends StatelessWidget {
  const TenantStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tenantName = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'محمد أحمد';

    final statements = [
      {
        'date': '2024/01/01',
        'desc': 'إيجار شهر يناير 2024',
        'due': '500 \$',
        'paid': '0 \$',
        'balance': '-500 \$',
      },
      {
        'date': '2024/01/05',
        'desc': 'دفعة نقداً (سند قبض #1001)',
        'due': '0 \$',
        'paid': '500 \$',
        'balance': '0 \$',
      },
      {
        'date': '2024/02/01',
        'desc': 'إيجار شهر فبراير 2024',
        'due': '500 \$',
        'paid': '0 \$',
        'balance': '-500 \$',
      },
      {
        'date': '2024/02/03',
        'desc': 'دفعة تحويل بنكي (سند قبض #1042)',
        'due': '0 \$',
        'paid': '500 \$',
        'balance': '0 \$',
      },
      {
        'date': '2024/03/01',
        'desc': 'إيجار شهر مارس 2024',
        'due': '500 \$',
        'paid': '0 \$',
        'balance': '-500 \$',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'كشف حساب: $tenantName'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tenant summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenantName,
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo'),
                      ),
                      const Text(
                        'عمارة القدس - شقة A102',
                        style: TextStyle(color: AppColors.white70, fontSize: 12, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('الرصيد الحالي', style: TextStyle(color: AppColors.white70, fontSize: 11, fontFamily: 'Cairo')),
                      Text(
                        '0 \$ (مستوفى)',
                        style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Transactions Table Header
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ListView.separated(
                  itemCount: statements.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final s = statements[index];
                    final isPayment = s['paid'] != '0 \$';

                    return Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            isPayment ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isPayment ? AppColors.success : AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s['desc']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo'),
                                ),
                                Text(
                                  s['date']!,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textLight, fontFamily: 'Cairo'),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                isPayment ? '+ ${s['paid']}' : '- ${s['due']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isPayment ? AppColors.success : AppColors.error,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                'الرصيد: ${s['balance']}',
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Cairo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Export PDF Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('جاري تصدير كشف الحساب كملف PDF...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('تصدير كشف الحساب (PDF)', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
