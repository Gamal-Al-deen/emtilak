import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../widgets/common/custom_search_field.dart';
import '../../widgets/common/status_badge.dart';

class ContractsPage extends StatelessWidget {
  const ContractsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contracts = [
      {
        'id': '105',
        'tenant': 'محمد أحمد',
        'unit': 'A102 - عمارة القدس',
        'rent': '500 \$',
        'start': '2024/01/01',
        'end': '2025/12/31',
        'status': 'نشط',
        'statusColor': AppColors.success,
      },
      {
        'id': '104',
        'tenant': 'أحمد علي',
        'unit': 'B101 - عمارة النور',
        'rent': '450 \$',
        'start': '2024/02/01',
        'end': '2025/12/31',
        'status': 'نشط',
        'statusColor': AppColors.success,
      },
      {
        'id': '103',
        'tenant': 'عبدالله حسين',
        'unit': 'A101 - عمارة القدس',
        'rent': '500 \$',
        'start': '2023/01/01',
        'end': '2023/12/31',
        'status': 'منتهي',
        'statusColor': AppColors.error,
      },
    ];

    void showContractDetailsModal(BuildContext context, Map<String, dynamic> c) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                    Text('تفاصيل عقد #${c['id']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Cairo')),
                    StatusBadge(label: c['status'] as String, color: c['statusColor'] as Color),
                  ],
                ),
                const Divider(height: 24, color: AppColors.divider),
                _buildRow('اسم المستأجر', c['tenant'] as String),
                _buildRow('الوحدة السكنية', c['unit'] as String),
                _buildRow('قيمة الإيجار الشهري', c['rent'] as String, color: AppColors.gold),
                _buildRow('تاريخ بداية العقد', c['start'] as String),
                _buildRow('تاريخ نهاية العقد', c['end'] as String),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/tenant-statement', arguments: c['tenant']);
                        },
                        icon: const Icon(Icons.receipt_long, size: 18),
                        label: const Text('كشف الحساب', style: TextStyle(fontFamily: 'Cairo')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/add-payment');
                        },
                        icon: const Icon(Icons.add_card, size: 18, color: AppColors.primary),
                        label: const Text('تسجيل دفعة', style: TextStyle(fontFamily: 'Cairo', color: AppColors.primary, fontWeight: FontWeight.bold)),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: CustomSearchField(hintText: 'بحث عن عقد...'),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  backgroundColor: AppColors.gold,
                  elevation: 2,
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-contract');
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: contracts.length,
                itemBuilder: (context, index) {
                  final c = contracts[index];
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'عقد #${c['id']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                StatusBadge(
                                  label: c['status'] as String,
                                  color: c['statusColor'] as Color,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c['tenant'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              c['unit'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const Divider(height: 20, color: AppColors.divider),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('تاريخ النهاية', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontFamily: 'Cairo')),
                                    Text(c['end'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('تاريخ البداية', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontFamily: 'Cairo')),
                                    Text(c['start'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('الإيجار الشهري', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontFamily: 'Cairo')),
                                    Text(c['rent'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gold, fontFamily: 'Cairo')),
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
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontFamily: 'Cairo')),
          Text(value, style: TextStyle(color: color ?? AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Cairo')),
        ],
      ),
    );
  }
}
