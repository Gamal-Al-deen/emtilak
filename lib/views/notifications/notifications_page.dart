import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'إيجار مستحق قريبًا',
        'body': 'إيجار شقة A102 (محمد أحمد) يستحق بعد 3 أيام (500 \$)',
        'time': 'منذ ساعتين',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.warning,
      },
      {
        'title': 'تم استلام دفعة جديدة',
        'body': 'قام المستأجر أحمد علي بدفع مبلغ 250 \$ لعقد #104',
        'time': 'منذ يوم واحد',
        'icon': Icons.check_circle_outline,
        'color': AppColors.success,
      },
      {
        'title': 'عقد ينتهي قريباً',
        'body': 'عقد #103 للمستأجر عبدالله حسين ينتهي بنهاية الشهر الحالي',
        'time': 'منذ 3 أيام',
        'icon': Icons.info_outline,
        'color': AppColors.info,
      },
    ];

    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'الإشعارات والتنبيهات'),
      body: ResponsiveContainer(
        maxWidth: 900,
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  'لا توجد إشعارات حالياً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: (n['color'] as Color).withValues(alpha: 0.15),
                        child: Icon(n['icon'] as IconData, color: n['color'] as Color),
                      ),
                      title: Text(
                        n['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            n['body'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            n['time'] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textLight,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
