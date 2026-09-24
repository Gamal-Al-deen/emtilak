/// إعدادات Supabase للعميل — قيم آمنة للتطبيق فقط (رابط المشروع والمفتاح
/// العام للنشر).
///
/// يُشابه نمط `firebase_options.dart` الحالي: ملف إعداد عميل داخل المشروع.
///
/// ⛔ لا يُوضع هنا مفتاح service-role أو أي سرّ خادم أبدًا.
abstract class SupabaseOptions {
  /// رابط مشروع Supabase (Project URL بدون مسار `/rest/v1/`).
  static const String projectUrl = 'https://ozsgjxyovhvivreuojfv.supabase.co';

  /// المفتاح العام للعميل (publishable/anon key) — آمن بتصميمه للتطبيق.
  static const String publishableKey =
      'sb_publishable_YZIqxhTzd0ZbD3XwU56oeA_W9dEMO79';
}
