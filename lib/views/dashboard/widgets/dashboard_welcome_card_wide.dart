import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class DashboardWelcomeCardWide extends StatelessWidget {
  final double totalIncome;

  const DashboardWelcomeCardWide({
    super.key,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.white24,
                child: Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'مرحباً بك',
                      style: TextStyle(
                        color: AppColors.white70,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      'أحمد محمد',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'لوحة إدارة العقارات الذكية',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'إجمالي التدفق المحصل',
                        style: TextStyle(
                          color: AppColors.white70,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${totalIncome.toInt()} \$',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '12.5%+ عن الشهر الماضي',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 11,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.show_chart,
                  color: AppColors.gold,
                  size: 48,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
