import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  /// آخر لغة معروفة على مستوى التطبيق — تُستخدم من طبقة الخدمات
  /// والكنترولرز حيث لا يوجد `BuildContext` لاستدعاء `AppLocalizations`.
  static Locale current = const Locale('ar');

  Locale _locale = const Locale('ar');
  
  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_localeKey);
    
    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      _locale = const Locale('ar'); // Default to Arabic
    }
    current = _locale;
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    
    _locale = newLocale;
    current = newLocale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
  }
}
