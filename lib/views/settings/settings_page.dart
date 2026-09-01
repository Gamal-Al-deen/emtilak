import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/common/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'النسخ الاحتياطي',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: const Text(
            'سيتم نسخ قاعدة بيانات العقارات والمستأجرين كاملة إلى حساب Google Drive الخاص بك.',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم رفع النسخة الاحتياطية إلى Google Drive بنجاح!',
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('نسخ الآن'),
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
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'تغيير كلمة المرور',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthFormField(
                    controller: oldPass,
                    hintText: 'كلمة المرور الحالية',
                    fieldType: AuthFieldType.password,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 12),
                  AuthFormField(
                    controller: newPass,
                    hintText: 'كلمة المرور الجديدة',
                    fieldType: AuthFieldType.password,
                    obscureText: true,
                    prefixIcon: Icons.lock_reset_outlined,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تغيير كلمة المرور بنجاح'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('تغيير'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'الإعدادات'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsItem(
            icon: Icons.cloud_upload_outlined,
            title: 'النسخ الاحتياطي',
            subtitle: 'Google Drive',
            onTap: _showBackupDialog,
          ),
          _buildSettingsItem(
            icon: Icons.currency_exchange,
            title: 'العملة الافتراضية وإدارتها',
            subtitle: 'دولار أمريكي - USD',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.currencies);
            },
          ),
          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: 'اللغة الحالية',
            subtitle: 'العربية (RTL)',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('التطبيق يدعم اللغة العربية بالكامل حالياً'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              secondary: const Icon(
                Icons.notifications_none_outlined,
                color: AppColors.primary,
              ),
              title: const Text(
                'التنبيهات والإشعارات',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: const Text(
                'تنبيهات الإيجارات المتأخرة والعقود',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
              value: _notificationsEnabled,
              activeThumbColor: AppColors.gold,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'تغيير كلمة المرور',
            onTap: _showChangePasswordDialog,
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: 'حول التطبيق',
            subtitle: 'v1.0.0',
            onTap: () {
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
          const SizedBox(height: 12),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            titleColor: AppColors.error,
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: titleColor ?? AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: titleColor ?? AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
