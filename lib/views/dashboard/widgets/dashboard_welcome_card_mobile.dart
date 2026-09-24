import 'package:flutter/material.dart';
import '../../../controllers/app_controllers.dart';
import '../../../core/colors.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/common/user_avatar.dart';

class DashboardWelcomeCardMobile extends StatelessWidget {
  final double totalIncome;

  const DashboardWelcomeCardMobile({
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بك',
                    style: TextStyle(
                      color: AppColors.white70,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            UserAvatar(
              radius: 24,
              profile: profile,
              fallbackName: AuthService.instance.currentUser?.displayName ?? '',
              backgroundColor: AppColors.white24,
              iconColor: AppColors.white,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إجمالي التدفق المحصل',
                      style: TextStyle(
                        color: AppColors.white70,
                        fontSize: 11,
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
                          fontSize: 22,
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
                        fontSize: 10,
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
                size: 42,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
