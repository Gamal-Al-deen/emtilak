import 'package:flutter/material.dart';

import '../../../controllers/app_controllers.dart';
import '../../../core/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routes/routes.dart';
import '../../../services/auth_service.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/auth/auth_text_field.dart';
import '../../../widgets/common/auth_message.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'settings_tile.dart';
import 'settings_section.dart';
import 'settings_header.dart';
import 'settings_theme_toggle.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool _notificationsEnabled = true;
  bool _biometricLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
    // تحميل الملف الشخصي من Supabase + إعادة البناء عند أي تغيّر فيه.
    AppControllers.instance.loadProfile();
    AppControllers.instance.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppControllers.instance.removeListener(_onDataChanged);
    super.dispose();
  }

  Future<void> _loadBiometricPreference() async {
    final bool enabled = await AuthService.instance.isBiometricLoginEnabled();
    if (mounted && enabled != _biometricLoginEnabled) {
      setState(() => _biometricLoginEnabled = enabled);
    }
  }

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

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text(
            l10n.settingsBackupDialogTitle,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(
              l10n.settingsBackupDialogBody,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.settingsBackupSuccess),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(l10n.settingsBackupNow),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPass = TextEditingController();
    final newPass = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text(
            l10n.settingsChangePasswordTitle,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthFormField(
                      controller: oldPass,
                      hintText: l10n.settingsChangePasswordOldHint,
                      fieldType: AuthFieldType.password,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 12),
                    AuthFormField(
                      controller: newPass,
                      hintText: l10n.settingsChangePasswordNewHint,
                      fieldType: AuthFieldType.password,
                      obscureText: true,
                      prefixIcon: Icons.lock_reset_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsChangePasswordSuccess),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(l10n.settingsChangePasswordButton),
            ),
          ],
        );
      },
    );
  }

  /// يعرض قائمة اختيار اللغة ويبدّلها فورًا عبر [LocaleController] —
  /// يكفي تغيير.Locale حتى يعيد `MaterialApp` بناء التطبيق بالاتجاه الجديد.
  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final LocaleController controller = AppControllers.instance.localeController;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final String currentCode = controller.locale.languageCode;

        Widget option({
          required String code,
          required String label,
          required IconData icon,
        }) {
          final bool selected = currentCode == code;
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Icon(
              icon,
              color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: selected
                ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                : Icon(Icons.circle_outlined, color: Theme.of(context).hintColor),
            onTap: () {
              Navigator.pop(dialogContext);
              controller.setLocale(Locale(code));
            },
          );
        }

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text(
            l10n.settingsLanguageDialogTitle,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                option(
                  code: 'ar',
                  label: l10n.settingsLanguageArabic,
                  icon: Icons.translate,
                ),
                option(
                  code: 'en',
                  label: l10n.settingsLanguageEnglish,
                  icon: Icons.translate_outlined,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final bool isArabic =
        AppControllers.instance.localeController.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: l10n.settingsTitle),
      body: ResponsiveContainer(
        maxWidth: 850,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          children: [
            SettingsHeader(),
            const SizedBox(height: 12),
            const SettingsThemeToggle(),
            SettingsSection(
              children: [
                SettingsTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'النسخ الاحتياطي',
                  subtitle: 'Google Drive',
                  onTap: _showBackupDialog,
                ),
                SettingsTile(
                  icon: Icons.currency_exchange,
                  title: l10n.settingsCurrency,
                  subtitle: l10n.settingsCurrencySubtitle,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.currencies);
                  },
                ),
                SettingsTile(
                  icon: Icons.language_outlined,
                  title: l10n.settingsLanguage,
                  subtitle: isArabic
                      ? l10n.settingsLanguageSubtitle
                      : l10n.settingsLanguageSubtitleEn,
                  onTap: () => _showLanguageDialog(context),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                  ),
                  child: SwitchListTile(
                    secondary: Icon(
                      Icons.notifications_none_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      l10n.settingsNotifications,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      l10n.settingsNotificationsSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: _notificationsEnabled,
                    activeThumbColor: AppColors.gold,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                  ),
                  child: SwitchListTile(
                    secondary: Icon(
                      Icons.fingerprint,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      l10n.settingsBiometric,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      l10n.settingsBiometricSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: _biometricLoginEnabled,
                    activeThumbColor: AppColors.gold,
                    onChanged: (val) async {
                      setState(() => _biometricLoginEnabled = val);
                      await AuthService.instance.setBiometricLoginEnabled(val);
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.lock_outline,
                  title: l10n.settingsChangePassword,
                  onTap: _showChangePasswordDialog,
                ),
                SettingsTile(
                  icon: Icons.info_outline,
                  title: l10n.settingsAbout,
                  subtitle: l10n.settingsAboutVersion,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: l10n.appName,
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(
                        Icons.home_work,
                        color: Theme.of(context).colorScheme.primary,
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
              ],
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.logout,
              title: l10n.settingsSignOut,
              titleColor: AppColors.error,
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
