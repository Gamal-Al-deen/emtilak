import 'package:flutter/material.dart';

import '../../core/colors.dart';

enum AuthFieldType {
  email,
  password,
  confirmPassword,
  phone,
  name,
  number,
  text,
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final AuthFieldType fieldType;
  final String? compareValue;
  final int maxLines;
  final bool isRequired;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.fieldType = AuthFieldType.text,
    this.compareValue,
    this.maxLines = 1,
    this.isRequired = true,
  });

  String? _defaultValidator(String? value) {
    final trimmed = value?.trim() ?? '';

    if (isRequired && trimmed.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (trimmed.isNotEmpty) {
      switch (fieldType) {
        case AuthFieldType.email:
          final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          if (!emailRegExp.hasMatch(trimmed)) {
            return 'يرجى إدخال بريد إلكتروني صحيح';
          }
          break;
        case AuthFieldType.password:
          if (trimmed.length < 6) {
            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
          }
          break;
        case AuthFieldType.confirmPassword:
          if (compareValue != null && trimmed != compareValue) {
            return 'كلمة المرور غير متطابقة';
          }
          break;
        case AuthFieldType.phone:
          if (trimmed.length < 8) {
            return 'رقم الهاتف قصير جدًا';
          }
          final phoneRegExp = RegExp(r'^[0-9+\s-]+$');
          if (!phoneRegExp.hasMatch(trimmed)) {
            return 'رقم الهاتف يجب أن يحتوي على أرقام فقط';
          }
          break;
        case AuthFieldType.name:
          if (trimmed.length < 2) {
            return 'الاسم قصير جدًا';
          }
          break;
        case AuthFieldType.number:
          if (double.tryParse(trimmed) == null) {
            return 'يرجى إدخال رقم صحيح';
          }
          break;
        case AuthFieldType.text:
          break;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveKeyboardType = fieldType == AuthFieldType.email
        ? TextInputType.emailAddress
        : (fieldType == AuthFieldType.phone
            ? TextInputType.phone
            : (fieldType == AuthFieldType.number
                ? const TextInputType.numberWithOptions(decimal: true)
                : keyboardType));

    return TextFormField(
      controller: controller,
      keyboardType: effectiveKeyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      // يتبع اتجاه اللغة تلقائيًا: يمين للعربية ويسار للإنجليزية.
      textAlign: TextAlign.start,
      validator: (value) {
        if (validator != null) {
          final customResult = validator!(value);
          if (customResult != null) return customResult;
        }
        return _defaultValidator(value);
      },
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          color: Theme.of(context).hintColor,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          color: Theme.of(context).colorScheme.primary,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

typedef AuthFormField = AuthTextField;

