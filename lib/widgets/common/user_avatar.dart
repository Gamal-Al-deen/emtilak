import 'package:flutter/material.dart';

import '../../controllers/profile_controller.dart';
import '../../core/colors.dart';
import '../../models/profile_model.dart';
import '../../services/auth_service.dart';

/// صورة المستخدم الموحّدة بالأولوية: صورة Supabase المرفوعة، ثم صورة
/// Firebase (photoURL)، ثم أول حرف من اسم المستخدم (يتحدّث تلقائيًا مع
/// تعديل الاسم)، وإن كان الاسم فارغًا تعرض أيقونة آمنة لا تُسقط التطبيق.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.radius,
    this.profile,
    this.fallbackName,
    this.backgroundColor = AppColors.primary,
    this.iconColor = AppColors.white,
  });

  final double radius;
  final UserProfile? profile;
  final String? fallbackName;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final String url = profile?.avatarUrl ?? '';
    if (url.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(url),
        // فشل تحميل الصورة من الشبكة لا يُسقط التطبيق — يبقى لون الخلفية.
        onBackgroundImageError: (_, __) {},
      );
    }

    // الأولوية الثانية: صورة الحساب من Firebase (photoURL) مثل صور Google.
    final String photoUrl = AuthService.instance.currentPhotoURL ?? '';
    if (photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(photoUrl),
        onBackgroundImageError: (_, __) {},
      );
    }

    final String name = ProfileController.resolveName(
      profile,
      fallback: fallbackName,
    );
    if (name.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: Icon(Icons.person, color: iconColor, size: radius),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        String.fromCharCode(name.runes.first),
        style: TextStyle(
          fontFamily: 'Cairo',
          color: iconColor,
          fontSize: radius * 0.85,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
