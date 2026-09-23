import 'package:flutter/material.dart';

import '../../core/colors.dart';

/// يعرض رسالة قصيرة للمستخدم بنفس أسلوب الواجهة الحالية (عربية/RTL).
///
/// تُستخدم لرسائل المصادقة فقط، ولا تُعرض معها أي رسائل خام من المزوّد.
void showAuthMessage(
  BuildContext context,
  String message, {
  bool isError = true,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
      ),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
