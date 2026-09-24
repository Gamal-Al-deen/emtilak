import 'package:flutter/material.dart';

import 'colors.dart';

/// المصدر المركزي الوحيد لمظهر التطبيق.
///
/// قاعدة التصميم: لا يوجد شاشة تحدّد ألوانها بنفسها حسب الوضع الداكن. كل شاشة
/// تقرأ ألوانها من `Theme.of(context).colorScheme`، والقيمة الفعلية تُحدَّد هنا
/// في مكان واحد.
///
/// [lightTheme] و [darkTheme] يستخدمان نفس الهوية البصرية (كحلي عميق + ذهبي
/// دافئ): الوضع الداكن تكييف لها — لا انعكاس للألوان ولا أسود صرف.
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Cairo';

  // ---------------------------------------------------------------------------
  // Light — قيم مطابقة تمامًا لهوية `AppColors` الحالية.
  // ---------------------------------------------------------------------------
  //
  // `colorScheme.surface`        = خلفية الصفحة  (AppColors.background)
  // `colorScheme.surfaceContainerLow` = البطاقات والأسطح (AppColors.surface)
  // `colorScheme.onSurface`      = النص الأساسي  (AppColors.textPrimary)
  // `colorScheme.onSurfaceVariant` = النص الثانوي (AppColors.textSecondary)
  // `colorScheme.outline`        = الحدود        (AppColors.border)
  // `colorScheme.outlineVariant` = الفواصل       (AppColors.divider)
  // `Theme.of(context).hintColor` = النص الخافت  (AppColors.textLight)
  // `colorScheme.primary`        = كحلي العلامة  (AppColors.primary)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    hintColor: AppColors.textLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.gold,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.gold,
      onSecondaryContainer: AppColors.white,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surface,
      surfaceContainerHighest: AppColors.surface,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.white,
      shadow: Color(0xFF000000),
      scrim: Color(0x99000000),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textPrimary),
      bodySmall: TextStyle(color: AppColors.textSecondary),
      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontFamily: fontFamily,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.surface,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      textStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontFamily: fontFamily,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: const WidgetStatePropertyAll(AppColors.white),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.textLight,
      type: BottomNavigationBarType.shifting,
      elevation: 4,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: fontFamily,
        fontSize: 13,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: fontFamily,
        fontSize: 12,
      ),
    ),
  );

  // ---------------------------------------------------------------------------
  // Dark — تكييف داكن لهوية كحلي/ذهبي نفسها: أسطح متدرّجة لا أسود صرف.
  // ---------------------------------------------------------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    hintColor: AppColors.darkTextLight,
    colorScheme: const ColorScheme.dark(
      // كحلي تفاعلي أفتح: يُستخدم كنص/أيقونة/خلفية زر — الكحلي الأصلي يختفي
      // على الخلفية الداكنة، وهذا بديله المقروء.
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.gold,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.gold,
      onSecondaryContainer: AppColors.primary,
      // الصفحة أعمق من البطاقة: تباين يمنع اختفاء البطاقات في الخلفية.
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerLowest: AppColors.darkBackground,
      surfaceContainerLow: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurface,
      surfaceContainerHigh: AppColors.darkSurfaceElevated,
      surfaceContainerHighest: AppColors.darkSurfaceElevated,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      // نفس قيمة `dividerTheme` بالأسفل: خط الفواصل مطابق لحدّ البطاقة
      // كي لا يختلف `Divider()` عن `Border.all(color: outlineVariant)`.
      outlineVariant: AppColors.darkBorder,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.white,
      shadow: Color(0xFF000000),
      scrim: Color(0xB3000000),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
      bodySmall: TextStyle(color: AppColors.darkTextSecondary),
      titleLarge: TextStyle(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurfaceElevated,
      foregroundColor: AppColors.darkTextPrimary,
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.darkSurfaceElevated,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 13,
        fontFamily: fontFamily,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.darkSurfaceElevated,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      textStyle: const TextStyle(
        color: AppColors.darkTextPrimary,
        fontFamily: fontFamily,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.darkPrimary),
        foregroundColor: const WidgetStatePropertyAll(AppColors.white),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(50)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: const BorderSide(color: AppColors.darkPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.darkTextLight,
      type: BottomNavigationBarType.shifting,
      elevation: 4,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkSurfaceElevated,
      contentTextStyle: const TextStyle(
        color: AppColors.darkTextPrimary,
        fontFamily: fontFamily,
        fontSize: 13,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: AppColors.darkTextPrimary,
        fontFamily: fontFamily,
        fontSize: 12,
      ),
    ),
  );

  /// يرجّع الثيم الفعّال لوضعٍ معيّن.
  ///
  /// مخصّص للشاشة المؤقتة التي تُبنى **خارج** `MaterialApp` (شاشة التحميل قبل
  /// حلول حالة المصادقة) فلا يوجد فيها `Theme.of(context)` يعمل. لا استماع ولا
  /// مؤقّتات: قراءة واحدة لسطوع المنصّة عند البناء فقط.
  static ThemeData resolvedThemeFor(ThemeMode mode) {
    if (mode == ThemeMode.light) return lightTheme;
    if (mode == ThemeMode.dark) return darkTheme;

    final Brightness platformBrightness = WidgetsBinding
        .instance
        .platformDispatcher
        .platformBrightness;
    return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
  }
}
