import 'package:flutter/material.dart';

import '../../controllers/app_controllers.dart';
import '../../core/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../routes/routes.dart';
import '../../services/auth_service.dart';
import 'auth_message.dart';
import 'user_avatar.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  /// ينهي جلسة المستخدم ثم يعيدها إلى شاشة تسجيل الدخول.
  Future<void> _signOut(BuildContext context) async {
    final bool signedOut = await AuthService.instance.signOut();
    if (!context.mounted) return;
    if (!signedOut) {
      showAuthMessage(context, AppLocalizations.of(context)!.signOutError);
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // بيانات المستخدم الحقيقية: Supabase أولًا ثم Firebase (لا أسماء ثابتة).
    final profile = AppControllers.instance.profile;
    final String firebaseName =
        AuthService.instance.currentUser?.displayName ?? '';
    final String displayName = ProfileController.resolveName(
      profile,
      fallback: firebaseName,
    );
    final String email = ProfileController.resolveEmail(
      profile,
      fallback: AuthService.instance.currentUser?.email,
    );

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            currentAccountPicture: UserAvatar(
              radius: 36,
              profile: profile,
              fallbackName: firebaseName,
              backgroundColor: AppColors.gold,
              iconColor: AppColors.white,
            ),
            accountName: Text(
              displayName,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
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
            title: Text(
              l10n.reportsAndProfits,
              style: const TextStyle(fontFamily: 'Cairo'),
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
            title: Text(
              l10n.manageCurrencies,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.currencies);
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_outlined, color: AppColors.primary),
            title: Text(
              l10n.maintenanceExpenses,
              style: const TextStyle(fontFamily: 'Cairo'),
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
            title: Text(
              l10n.settingsAndBackup,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: Text(
              l10n.settingsAbout,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: l10n.appName,
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.home_work,
                  color: AppColors.primary,
                  size: 40,
                ),
                children: [
                  Text(
                    l10n.aboutAppDescription,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              l10n.settingsSignOut,
              style: const TextStyle(fontFamily: 'Cairo', color: AppColors.error),
            ),
            onTap: () => _signOut(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
