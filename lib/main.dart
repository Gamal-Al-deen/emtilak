import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'controllers/app_controllers.dart';
import 'firebase_options.dart';
import 'services/profile_service.dart';
import 'supabase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await Supabase.initialize(
      url: SupabaseOptions.projectUrl,
      publishableKey: SupabaseOptions.publishableKey,
      accessToken: ProfileService.instance.accessTokenForSupabase,
      debug: false,
    );
  } catch (e) {
    debugPrint('Supabase init failed: $e');
  }

  // مزامنة الملف بعد استعادة جلسة Firebase عند إعادة التشغيل، وتفريغ
  // الذاكرة المؤقتة عند الخروج — بلا حذف أي بيانات من القاعدة.
  ProfileService.instance.startAuthListener();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  await AppControllers.instance.initControllers();

  runApp(EmtilakApp(hasSeenOnboarding: hasSeenOnboarding));
}
