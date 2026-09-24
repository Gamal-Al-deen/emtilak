import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// متحكّم مظهر التطبيق: يختار بين الفاتح/الداكن/حسب النظام ويحفظ الاختيار.
///
/// التصميم مطابق تمامًا لـ [LocaleController]: `ChangeNotifier` + مفتاح واحد في
/// `SharedPreferences`. المظهر واللغة مستقلان تمامًا — تبديل أحدهما لا يمسّ
/// الآخر (مفتاحان مختلفان: `app_theme` و `app_locale`).
class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'app_theme';

  /// الوضع الافتراضي عند أول تشغيل: يتبع نظام الجهاز.
  static const ThemeMode _defaultMode = ThemeMode.system;

  ThemeMode _mode = _defaultMode;

  ThemeMode get mode => _mode;

  /// اسم المفتاح المحفوظ — لتوثيق السلوك في مكان واحد.
  static const String preferenceKey = _themeKey;

  /// يقرأ الاختيار المحفوظ، ويترك النظام هو الافتراضي لم يوجد شيء.
  Future<void> loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString(_themeKey);

    ThemeMode loaded;
    switch (saved) {
      case 'light':
        loaded = ThemeMode.light;
        break;
      case 'dark':
        loaded = ThemeMode.dark;
        break;
      case 'system':
        loaded = ThemeMode.system;
        break;
      default:
        loaded = _defaultMode;
    }

    if (loaded != _mode) {
      _mode = loaded;
      notifyListeners();
    }
  }

  /// يطبّق المظهر فورًا ثم يحفظه — لا ينتظر الحفظ لإعادة البناء.
  Future<void> setMode(ThemeMode newMode) async {
    if (_mode == newMode) return;

    _mode = newMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _mode.name);
  }

  /// يحوّل القيمة المحفوظة إلى `ThemeMode` (يُستخدم عند التحميل فقط).
  static ThemeMode modeFromName(String? name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return _defaultMode;
    }
  }

  /// الاسم المحفوظ للوضع الحالي (`light` / `dark` / `system`).
  String get preferenceValue => _mode.name;
}
