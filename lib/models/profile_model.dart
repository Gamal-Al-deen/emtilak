/// الملف الشخصي للمستخدم في `public.profiles` (Supabase).
///
/// الهوية: `id` = معرّف Firebase (UID) — مصدر الهوية الوحيد في التطبيق.
/// لا يحتوي هذا الموديل — ولا الجدول — على أي كلمة مرور إطلاقًا؛
/// بيانات الدخول تبقى في Firebase، والبريد هنا نسخة عرض منها.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// معرّف المستخدم = Firebase UID (نص — نفس مفتاح صف `profiles`).
  final String id;

  /// الاسم الكامل.
  final String fullName;

  /// رقم الهاتف (اختياري).
  final String? phone;

  /// نسخة عرض من البريد — مرجعية البريد الحقيقية هي Firebase.
  final String? email;

  /// رابط الصورة في التخزين العام `avatars/{user_id}/...`.
  final String? avatarUrl;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name']?.toString() ?? '',
      phone: _emptyToNull(map['phone']?.toString()),
      email: _emptyToNull(map['email']?.toString()),
      avatarUrl: _emptyToNull(map['avatar_url']?.toString()),
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  static String? _emptyToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  static DateTime? _parseDate(Object? value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toLocal();
    }
    return null;
  }
}
