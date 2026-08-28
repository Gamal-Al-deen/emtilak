import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (From design & logo)
  static const Color primary = Color(0xFF082B5B);
  static const Color gold = Color(0xFFD4A017);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF2563EB);

  // Unit Visual Grid Status Colors (Matches Design Image 4)
  static const Color rented = Color(0xFF16A34A);       // مؤجرة (أخضر)
  static const Color vacant = Color(0xFF2563EB);       // فارغة (أزرق)
  static const Color maintenance = Color(0xFFEF4444);  // صيانة (أحمر)
  static const Color preparing = Color(0xFFF59E0B);    // قيد التجهيز (أصفر/برتقالي)
  static const Color afterExit = Color(0xFF8B5CF6);    // بعد الخروج (بنفسجي)

  // Borders & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Dashboard & Charts
  static const Color chartLine = Color(0xFFD4A017);
  static const Color cardShadow = Color(0x0F000000);

  // Navigation
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF94A3B8);
}