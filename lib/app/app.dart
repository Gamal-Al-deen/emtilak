import 'package:flutter/material.dart';

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
import '../core/theme.dart';
import '../routes/routes.dart';

class EmtilakApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const EmtilakApp({super.key, this.hasSeenOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إمتلاك',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: hasSeenOnboarding ? AppRoutes.login : AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingView(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.signUp: (_) => const SignUpPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.mainLayout: (_) => const MainLayout(),
        AppRoutes.dashboard: (_) => const DashboardPage(),
        AppRoutes.buildings: (_) => const BuildingsPage(),
        AppRoutes.unitsGrid: (_) => const UnitsGridPage(),
        AppRoutes.unitDetails: (_) => const UnitDetailsPage(),
        AppRoutes.contracts: (_) => const ContractsPage(),
        AppRoutes.addContract: (_) => const AddContractPage(),
        AppRoutes.tenants: (_) => const TenantsPage(),
        AppRoutes.tenantStatement: (_) => const TenantStatementPage(),
        AppRoutes.payments: (_) => const PaymentsPage(),
        AppRoutes.addPayment: (_) => const AddPaymentPage(),
        AppRoutes.maintenance: (_) => const AddMaintenancePage(),
        AppRoutes.addMaintenance: (_) => const AddMaintenancePage(),
        AppRoutes.financialReport: (_) => const FinancialReportPage(),
        AppRoutes.currencies: (_) => const CurrenciesPage(),
        AppRoutes.notifications: (_) => const NotificationsPage(),
        AppRoutes.settings: (_) => const SettingsPage(),
      },
    );
  }
}
