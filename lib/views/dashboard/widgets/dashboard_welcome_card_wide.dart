import 'package:flutter/material.dart';
import '../../../controllers/app_controllers.dart';
import '../../../core/colors.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/common/user_avatar.dart';

class DashboardWelcomeCardWide extends StatelessWidget {
  final double totalIncome;

  const DashboardWelcomeCardWide({
    super.key,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    // اسم المستخدم الحقيقي (يتحدّث تلقائيًا مع الملف الشخصي — لا اسم ثابت).
    final profile = AppControllers.instance.profile;
    final String displayName = ProfileController.resolveName(
      profile,
      fallback: AuthService.instance.currentUser?.displayName ?? '',
    );

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              UserAvatar(
                radius: 28,
                profile: profile,
                fallbackName: AuthService.instance.currentUser?.displayName ?? '',
                backgroundColor: AppColors.white24,
                iconColor: AppColors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'مرحباً بك',
                      style: TextStyle(
                        color: AppColors.white70,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
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
