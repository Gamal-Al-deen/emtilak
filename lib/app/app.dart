import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/layout/main_layout.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/auth/login_page.dart';
import '../views/auth/sign_up_page.dart';
import '../views/auth/forgot_password_page.dart';
import '../views/contracts/add_contract_page.dart';
import '../views/contracts/contracts_page.dart';
import '../views/dashboard/dashboard_page.dart';
import '../views/notifications/notifications_page.dart';
import '../views/properties/buildings_page.dart';
import '../views/properties/unit_details_page.dart';
import '../views/properties/units_grid_page.dart';
import '../views/reports/financial_report_page.dart';
import '../views/settings/currencies_page.dart';
import '../views/settings/settings_page.dart';
import '../views/tenants/tenant_statement_page.dart';
import '../views/tenants/tenants_page.dart';
import '../views/transactions/add_maintenance_page.dart';
import '../views/transactions/add_payment_page.dart';
import '../views/transactions/payments_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../controllers/app_controllers.dart';
import '../core/theme.dart';
import '../routes/routes.dart';

class EmtilakApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const EmtilakApp({super.key, this.hasSeenOnboarding = false});

  @override
  Widget build(BuildContext context) {
    // عند عدم تهيئة Firebase (كاختبارات الوحدات) نتّبع المنطق القديم دون قيود.
    if (Firebase.apps.isEmpty) {
      return _buildApp(
        hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding,
        guardAuthenticatedRoutes: false,
      );
    }

    // ننتظر أول إشعار بحالة المصادقة حتى لا تظهر الشاشة الخاطئة أثناء
    // تحميل جلسة Firebase المستعادة من الجهاز.
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      initialData: AuthService.instance.currentUser,
      builder: (context, snapshot) {
        final bool resolved = snapshot.connectionState ==
                ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done;
        final bool signedIn = snapshot.hasData;

        if (!signedIn && !resolved) {
          // خارج `MaterialApp` لا يوجد `Theme.of(context)`، فنُعطي الشاشة
          // المؤقتة الثيم الفعّال مباشرة كي تتبع الوضع المختار.
          return Theme(
            data: AppTheme.resolvedThemeFor(
              AppControllers.instance.themeController.mode,
            ),
            child: const _AuthLoadingView(),
          );
        }

        final String initialRoute;
        if (!hasSeenOnboarding) {
          initialRoute = AppRoutes.onboarding;
        } else {
          initialRoute =
              signedIn ? AppRoutes.mainLayout : AppRoutes.login;
        }

        return _buildApp(initialRoute, guardAuthenticatedRoutes: true);
      },
    );
  }

  Widget _buildApp(
    String initialRoute, {
    required bool guardAuthenticatedRoutes,
  }) {
    // يمنع دخول منشأة محمية دون تسجيل دخول.
    Widget guard(Widget child) =>
        guardAuthenticatedRoutes ? AuthGuard(child: child) : child;

    return ListenableBuilder(
      listenable: AppControllers.instance.localeController,
      builder: (context, _) {
        final currentLocale = AppControllers.instance.localeController.locale;

        // استماع منفصل للمظهر: تبديل الفاتح/الداكن يعيد بناء `MaterialApp`
        // وحده دون المساس باللغة (وكذلك العكس) — مفتاحان مستقلان.
        return ListenableBuilder(
          listenable: AppControllers.instance.themeController,
          builder: (context, _) {
            final ThemeMode themeMode =
                AppControllers.instance.themeController.mode;

            return MaterialApp(
              title: 'إمتلاك',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              locale: currentLocale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: initialRoute,
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingView(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.signUp: (_) => const SignUpPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.mainLayout: (_) => guard(const MainLayout()),
        AppRoutes.dashboard: (_) => guard(const DashboardPage()),
        AppRoutes.buildings: (_) => guard(const BuildingsPage()),
        AppRoutes.unitsGrid: (_) => guard(const UnitsGridPage()),
        AppRoutes.unitDetails: (_) => guard(const UnitDetailsPage()),
        AppRoutes.contracts: (_) => guard(const ContractsPage()),
        AppRoutes.addContract: (_) => guard(const AddContractPage()),
        AppRoutes.tenants: (_) => guard(const TenantsPage()),
        AppRoutes.tenantStatement: (_) =>
            guard(const TenantStatementPage()),
        AppRoutes.payments: (_) => guard(const PaymentsPage()),
        AppRoutes.addPayment: (_) => guard(const AddPaymentPage()),
        AppRoutes.maintenance: (_) => guard(const AddMaintenancePage()),
        AppRoutes.addMaintenance: (_) => guard(const AddMaintenancePage()),
        AppRoutes.financialReport: (_) =>
            guard(const FinancialReportPage()),
        AppRoutes.currencies: (_) => guard(const CurrenciesPage()),
        AppRoutes.notifications: (_) => guard(const NotificationsPage()),
        AppRoutes.settings: (_) => guard(const SettingsPage()),
          },
        );
          },
        );
      },
    );
  }
}

/// يمنع الوصول إلى الشاشات المخصّصة لمستخدم مسجّل الدخول دون مصادقة.
class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key, required this.child});

  final Widget child;

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _redirecting = false;

  @override
  Widget build(BuildContext context) {
    // Firebase مهيّأ بالفعل عند بناء المسارات (انظر `Firebase.apps.isEmpty`).
    if (AuthService.instance.currentUser != null) {
      return widget.child;
    }

    if (!_redirecting) {
      _redirecting = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      });
    }

    // لا نعرض محتوى محميًا ولو لحظة واحدة (الثيم مُمرَّر من نقطة البناء).
    return Theme(
      data: AppTheme.resolvedThemeFor(
        AppControllers.instance.themeController.mode,
      ),
      child: const _AuthLoadingView(),
    );
  }
}

/// شاشة تحميل بسيطة تُستخدم أثناء التحقق من حالة المصادقة.
class _AuthLoadingView extends StatelessWidget {
  const _AuthLoadingView();

  @override
  Widget build(BuildContext context) {
    // اتجاه حسب لغة التطبيق: العربية RTL والإنجليزية LTR — لا يُفرض
    // اتجاه ثابت حتى أثناء شاشة التحميل قبل بناء التطبيق.
    final Locale locale = AppControllers.instance.localeController.locale;
    // الثيم يأتي من `Theme` المحيط (ثيم فعّال محسوب في نقطة البناء)، لا من
    // `Theme.of(context)` الافتراضي — كي تتبع الشاشة الوضع المختار.
    final ThemeData theme = Theme.of(context);
    return Directionality(
      textDirection:
          locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}
