import 'package:flutter/material.dart';

import '../../../controllers/app_controllers.dart';
import '../../../l10n/app_localizations.dart';

/// بطاقة اختيار المظهر في الإعدادات — نسخة مطابقة من بطاقة اللغة:
/// عنوان + الوضع الحالي، وعند اللمس تفتح قائمة بثلاثة خيارات (فاتح / داكن /
/// حسب النظام) تُطبَّق فورًا وتُحفظ في `SharedPreferences` عبر
/// [ThemeController].
class SettingsThemeToggle extends StatelessWidget {
  const SettingsThemeToggle({super.key});

  String _labelFor(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.settingsThemeLight;
      case ThemeMode.dark:
        return l10n.settingsThemeDark;
      case ThemeMode.system:
        return l10n.settingsThemeSystem;
    }
  }

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ThemeController controller =
        AppControllers.instance.themeController;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final ThemeMode currentMode = controller.mode;

        Widget option({
          required ThemeMode mode,
          required String label,
          required IconData icon,
        }) {
          final bool selected = currentMode == mode;
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
              controller.setMode(mode);
            },
          );
        }

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          title: Text(
            l10n.settingsThemeDialogTitle,
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
                  mode: ThemeMode.light,
                  label: l10n.settingsThemeLight,
                  icon: Icons.light_mode_outlined,
                ),
                option(
                  mode: ThemeMode.dark,
                  label: l10n.settingsThemeDark,
                  icon: Icons.dark_mode_outlined,
                ),
                option(
                  mode: ThemeMode.system,
                  label: l10n.settingsThemeSystem,
                  icon: Icons.settings_brightness_outlined,
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
    final ThemeController controller = AppControllers.instance.themeController;

    // استماع مباشر: العنوان الفرعي يتحدّث مع كل تغيّر في الوضع، ولا يعتمد
    // على إعادة بناء الأب التي قد يتجاوزها `const`.
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _SettingsThemeTile(
        label: _labelFor(l10n, controller.mode),
        onTap: () => _showThemeDialog(context),
      ),
    );
  }
}

class _SettingsThemeTile extends StatelessWidget {
  const _SettingsThemeTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.palette_outlined, color: Theme.of(context).colorScheme.primary),
        title: Text(
          l10n.settingsTheme,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
