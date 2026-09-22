import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../routes/routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppColors.gold,
              child: Icon(Icons.person, color: AppColors.white, size: 36),
            ),
            accountName: const Text(
              'أحمد محمد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: const Text(
              'مدير العقارات',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.white70,
                fontSize: 12,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.analytics_outlined,
              color: AppColors.primary,
            ),
            title: const Text(
              'التقارير والأرباح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.financialReport);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.currency_exchange,
              color: AppColors.primary,
            ),
            title: const Text(
              'إدارة العملات',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.currencies);
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_outlined, color: AppColors.primary),
            title: const Text(
              'مصاريف الصيانة',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.addMaintenance);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: AppColors.primary,
            ),
            title: const Text(
              'الإعدادات والنسخ الاحتياطي',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: const Text(
              'حول التطبيق',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'إمتلاك',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.home_work,
                  color: AppColors.primary,
                  size: 40,
                ),
                children: const [
                  Text(
                    'نظام احترافي لإدارة العقارات السكنية وتتبع الإيجارات.',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(fontFamily: 'Cairo', color: AppColors.error),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
