import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application name
  ///
  /// In ar, this message translates to:
  /// **'إمتلاك'**
  String get appName;

  /// App tagline shown on login screen
  ///
  /// In ar, this message translates to:
  /// **'منصة متكاملة لإدارة العقارات والموارد'**
  String get appTagline;

  /// Dashboard subtitle
  ///
  /// In ar, this message translates to:
  /// **'لوحة إدارة العقارات الذكية'**
  String get appSmartDashboard;

  /// Notifications page title
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات والتنبيهات'**
  String get notifications;

  /// Empty notifications message
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات حالياً'**
  String get noNotifications;

  /// Notification type: rent due soon
  ///
  /// In ar, this message translates to:
  /// **'إيجار مستحق قريبًا'**
  String get rentDueSoon;

  /// Rent due soon notification body
  ///
  /// In ar, this message translates to:
  /// **'إيجار شقة A102 (محمد أحمد) يستحق بعد 3 أيام (500 \$)'**
  String get rentDueSoonBody;

  /// Notification type: payment received
  ///
  /// In ar, this message translates to:
  /// **'تم استلام دفعة جديدة'**
  String get paymentReceived;

  /// Payment received notification body
  ///
  /// In ar, this message translates to:
  /// **'قام المستأجر أحمد علي بدفع مبلغ 250 \$ لعقد #104'**
  String get paymentReceivedBody;

  /// Notification type: contract expiring
  ///
  /// In ar, this message translates to:
  /// **'عقد ينتهي قريباً'**
  String get contractExpiringSoon;

  /// Contract expiring notification body
  ///
  /// In ar, this message translates to:
  /// **'عقد #103 للمستأجر عبدالله حسين ينتهي بنهاية الشهر الحالي'**
  String get contractExpiringSoonBody;

  /// Time ago: 2 hours
  ///
  /// In ar, this message translates to:
  /// **'منذ ساعتين'**
  String get hoursAgo2;

  /// Time ago: 1 day
  ///
  /// In ar, this message translates to:
  /// **'منذ يوم واحد'**
  String get dayAgo1;

  /// Time ago: 3 days
  ///
  /// In ar, this message translates to:
  /// **'منذ 3 أيام'**
  String get daysAgo3;

  /// Onboarding page 1 title
  ///
  /// In ar, this message translates to:
  /// **'تقارير دقيقة و واضحة'**
  String get onboardingTitle1;

  /// Onboarding page 1 body
  ///
  /// In ar, this message translates to:
  /// **'احصل على تقارير مالية شاملة واستعرض أداء عقاراتك في مكان واحد.'**
  String get onboardingBody1;

  /// Onboarding page 2 title
  ///
  /// In ar, this message translates to:
  /// **'تتبع الإيرادات والمدفوعات'**
  String get onboardingTitle2;

  /// Onboarding page 2 body
  ///
  /// In ar, this message translates to:
  /// **'سجل الإيجارات والمدفوعات واطلع على المتأخرات وأصدر سندات قبض رسمية.'**
  String get onboardingBody2;

  /// Onboarding page 3 title
  ///
  /// In ar, this message translates to:
  /// **'إدارة عقاراتك بسهولة'**
  String get onboardingTitle3;

  /// Onboarding page 3 body
  ///
  /// In ar, this message translates to:
  /// **'أضف مبانيك ووحداتك وتابع حالة كل وحدة بكل سهولة واحترافية.'**
  String get onboardingBody3;

  /// Onboarding skip button
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get onboardingSkip;

  /// Onboarding next button
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get onboardingNext;

  /// Onboarding done button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get onboardingDone;

  /// Login screen title
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// Login welcome subtitle
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك مرة أخرى'**
  String get loginWelcome;

  /// Login email/phone field hint
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو رقم الهاتف'**
  String get loginEmailHint;

  /// Login password field hint
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get loginPasswordHint;

  /// Forgot password link
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get loginForgotPassword;

  /// Login button text
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginButton;

  /// Or divider text on login
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get loginOr;

  /// Google sign in button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول باستخدام Google'**
  String get loginWithGoogle;

  /// Facebook sign in button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول باستخدام Facebook'**
  String get loginWithFacebook;

  /// Biometric sign in button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول بالبصمة'**
  String get loginWithBiometric;

  /// Loading text on social login buttons
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحقق...'**
  String get loginVerifying;

  /// No account prompt
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟ '**
  String get loginNoAccount;

  /// Create account link
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get loginCreateAccount;

  /// Google sign-in cancelled message
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء تسجيل الدخول باستخدام Google.'**
  String get loginCancelledGoogle;

  /// Facebook sign-in cancelled message
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء تسجيل الدخول باستخدام فيسبوك.'**
  String get loginCancelledFacebook;

  /// Biometric cancelled message
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء التحقق بالبصمة.'**
  String get loginCancelledBiometric;

  /// Generic login error
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع، حاول مرة أخرى.'**
  String get loginUnexpectedError;

  /// Sign up screen title
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signUpTitle;

  /// Sign up subtitle
  ///
  /// In ar, this message translates to:
  /// **'سجل حسابك لبدء إدارة عقاراتك'**
  String get signUpSubtitle;

  /// Sign up name field hint
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get signUpNameHint;

  /// Sign up email field hint
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get signUpEmailHint;

  /// Sign up password field hint
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get signUpPasswordHint;

  /// Sign up confirm password hint
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get signUpConfirmHint;

  /// Sign up button text
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get signUpButton;

  /// Already have account prompt
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب بالفعل؟ '**
  String get signUpHaveAccount;

  /// Sign in link on sign up page
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signUpLogin;

  /// Forgot password screen title
  ///
  /// In ar, this message translates to:
  /// **'استعادة كلمة المرور'**
  String get forgotPasswordTitle;

  /// Forgot password subtitle
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين'**
  String get forgotPasswordSubtitle;

  /// Forgot password email hint
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get forgotPasswordEmailHint;

  /// Forgot password send button
  ///
  /// In ar, this message translates to:
  /// **'إرسال رابط الاستعادة'**
  String get forgotPasswordButton;

  /// Back to login link
  ///
  /// In ar, this message translates to:
  /// **'العودة لتسجيل الدخول'**
  String get forgotPasswordBack;

  /// Dashboard navigation label
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboard;

  /// Home navigation label
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// Buildings navigation label
  ///
  /// In ar, this message translates to:
  /// **'المباني'**
  String get buildings;

  /// Contracts navigation label
  ///
  /// In ar, this message translates to:
  /// **'العقود'**
  String get contracts;

  /// Payments navigation label
  ///
  /// In ar, this message translates to:
  /// **'الدفعات'**
  String get payments;

  /// Tenants navigation label
  ///
  /// In ar, this message translates to:
  /// **'المستأجرون'**
  String get tenants;

  /// Welcome greeting on dashboard
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك'**
  String get welcomeGreeting;

  /// Total collected income label on dashboard
  ///
  /// In ar, this message translates to:
  /// **'إجمالي التدفق المحصل'**
  String get totalCollected;

  /// Comparison vs last month
  ///
  /// In ar, this message translates to:
  /// **'12.5%+ عن الشهر الماضي'**
  String get vsLastMonth;

  /// Total units stat card label
  ///
  /// In ar, this message translates to:
  /// **'الوحدات'**
  String get totalUnits;

  /// Rented units stat card label
  ///
  /// In ar, this message translates to:
  /// **'المؤجرة'**
  String get rentedUnits;

  /// Vacant units stat card label
  ///
  /// In ar, this message translates to:
  /// **'الفارغة'**
  String get vacantUnits;

  /// Collection chart title
  ///
  /// In ar, this message translates to:
  /// **'نظرة عامة'**
  String get collectionOverview;

  /// Collection rate label in chart
  ///
  /// In ar, this message translates to:
  /// **'نسبة التحصيل'**
  String get collectionRate;

  /// Payment status: paid
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get statusPaid;

  /// Payment status: delayed
  ///
  /// In ar, this message translates to:
  /// **'متأخر'**
  String get statusDelayed;

  /// Payment status: pending collection
  ///
  /// In ar, this message translates to:
  /// **'قيد التحصيل'**
  String get statusPending;

  /// Payment status: partial
  ///
  /// In ar, this message translates to:
  /// **'جزئي'**
  String get statusPartial;

  /// Quick actions section title
  ///
  /// In ar, this message translates to:
  /// **'الإجراءات السريعة'**
  String get quickActions;

  /// Record payment quick action button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة'**
  String get recordPayment;

  /// Record new payment button (wide screen)
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة جديدة'**
  String get recordPaymentNew;

  /// New contract quick action button
  ///
  /// In ar, this message translates to:
  /// **'عقد جديد'**
  String get newContract;

  /// Create new contract button (wide screen)
  ///
  /// In ar, this message translates to:
  /// **'إنشاء عقد جديد'**
  String get createNewContract;

  /// Record maintenance expense button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل مصروف صيانة'**
  String get recordMaintenance;

  /// Sidebar main section label
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get sidebarMainSection;

  /// Sidebar management section label
  ///
  /// In ar, this message translates to:
  /// **'الإدارة والتقارير'**
  String get sidebarManagementSection;

  /// Reports and profits menu item
  ///
  /// In ar, this message translates to:
  /// **'التقارير والأرباح'**
  String get reportsAndProfits;

  /// Manage currencies menu item
  ///
  /// In ar, this message translates to:
  /// **'إدارة العملات'**
  String get manageCurrencies;

  /// Maintenance expenses menu item
  ///
  /// In ar, this message translates to:
  /// **'مصاريف الصيانة'**
  String get maintenanceExpenses;

  /// Settings menu item / page title
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// Settings and backup menu item
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات والنسخ الاحتياطي'**
  String get settingsAndBackup;

  /// About app menu/page item
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get aboutApp;

  /// About app description
  ///
  /// In ar, this message translates to:
  /// **'نظام احترافي لإدارة العقارات السكنية وتتبع الإيجارات.'**
  String get aboutAppDescription;

  /// Sign out button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOut;

  /// Sign out error message
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تسجيل الخروج، حاول مرة أخرى.'**
  String get signOutError;

  /// New payment button in wide header
  ///
  /// In ar, this message translates to:
  /// **'دفعة جديدة'**
  String get newPaymentButton;

  /// Building card: total units label
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الوحدات'**
  String get buildingsTotalUnits;

  /// Building card: rented units label
  ///
  /// In ar, this message translates to:
  /// **'مؤجرة'**
  String get buildingsRented;

  /// Building card: vacant units label
  ///
  /// In ar, this message translates to:
  /// **'فارغة'**
  String get buildingsVacant;

  /// Buildings search bar hint
  ///
  /// In ar, this message translates to:
  /// **'البحث في المباني...'**
  String get buildingsSearchHint;

  /// Add building button
  ///
  /// In ar, this message translates to:
  /// **'إضافة مبنى'**
  String get addBuilding;

  /// Add building dialog title
  ///
  /// In ar, this message translates to:
  /// **'إضافة مبنى جديد'**
  String get addBuildingTitle;

  /// Building name field hint
  ///
  /// In ar, this message translates to:
  /// **'اسم المبنى (مثال: عمارة السلام)'**
  String get addBuildingNameHint;

  /// Building location field hint
  ///
  /// In ar, this message translates to:
  /// **'العنوان / الموقع'**
  String get addBuildingLocationHint;

  /// Building total units field hint
  ///
  /// In ar, this message translates to:
  /// **'عدد الوحدات الكلي'**
  String get addBuildingUnitsHint;

  /// Cancel button
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// Add button
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// Building added success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة المبنى بنجاح!'**
  String get buildingAddedSuccess;

  /// Buildings empty state message
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مباني مسجلة بعد'**
  String get buildingsEmpty;

  /// Buildings empty state subtitle
  ///
  /// In ar, this message translates to:
  /// **'أضف مبنى جديد للبدء'**
  String get buildingsEmptySubtitle;

  /// Unit status: rented
  ///
  /// In ar, this message translates to:
  /// **'مؤجرة'**
  String get unitStatusRented;

  /// Unit status: vacant
  ///
  /// In ar, this message translates to:
  /// **'فارغة'**
  String get unitStatusVacant;

  /// Unit status: under preparation
  ///
  /// In ar, this message translates to:
  /// **'قيد التجهيز'**
  String get unitStatusPreparing;

  /// Unit status: maintenance
  ///
  /// In ar, this message translates to:
  /// **'صيانة'**
  String get unitStatusMaintenance;

  /// Unit status: after exit
  ///
  /// In ar, this message translates to:
  /// **'بعد الخروج'**
  String get unitStatusAfterExit;

  /// Units grid page title
  ///
  /// In ar, this message translates to:
  /// **'وحدات {buildingName}'**
  String unitsOfBuilding(String buildingName);

  /// Unit count label
  ///
  /// In ar, this message translates to:
  /// **'{count} وحدة'**
  String unitCount(int count);

  /// Units empty state message
  ///
  /// In ar, this message translates to:
  /// **'لا توجد وحدات مسجلة لهذا المبنى'**
  String get unitsEmpty;

  /// Add unit button
  ///
  /// In ar, this message translates to:
  /// **'إضافة وحدة جديدة'**
  String get addUnit;

  /// Add unit dialog title
  ///
  /// In ar, this message translates to:
  /// **'إضافة وحدة لـ {buildingName}'**
  String addUnitTitle(String buildingName);

  /// Unit number field hint
  ///
  /// In ar, this message translates to:
  /// **'رقم الوحدة (مثال: C101)'**
  String get addUnitNumberHint;

  /// Unit rent field hint
  ///
  /// In ar, this message translates to:
  /// **'الإيجار المقترح (اختياري)'**
  String get addUnitRentHint;

  /// Unit status dropdown label
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get addUnitStatusLabel;

  /// Unit added success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة الوحدة السكنية بنجاح!'**
  String get unitAddedSuccess;

  /// Unit details page title
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الوحدة {unitNumber}'**
  String unitDetailsTitle(String unitNumber);

  /// Apartment number label in unit details
  ///
  /// In ar, this message translates to:
  /// **'شقة رقم {unitNumber}'**
  String unitApartmentNumber(String unitNumber);

  /// Unit floor info
  ///
  /// In ar, this message translates to:
  /// **'{buildingName} - الطابق الأول'**
  String unitFloor(String buildingName);

  /// Unit details: active contract section title
  ///
  /// In ar, this message translates to:
  /// **'العقد النشط حالياً'**
  String get unitActiveContract;

  /// Contract row: tenant label
  ///
  /// In ar, this message translates to:
  /// **'المستأجر'**
  String get contractTenant;

  /// Contract row: rent value label
  ///
  /// In ar, this message translates to:
  /// **'قيمة الإيجار'**
  String get contractRentValue;

  /// Contract monthly rent display
  ///
  /// In ar, this message translates to:
  /// **'{amount} \$ / شهرياً'**
  String contractRentMonthly(int amount);

  /// Contract start date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ بداية العقد'**
  String get contractStartDate;

  /// Contract end date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ نهاية العقد'**
  String get contractEndDate;

  /// Contract status label
  ///
  /// In ar, this message translates to:
  /// **'حالة العقد'**
  String get contractStatus;

  /// View tenant statement button
  ///
  /// In ar, this message translates to:
  /// **'عرض كشف حساب المستأجر'**
  String get viewTenantStatement;

  /// Record maintenance for unit button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل مصروف صيانة للوحدة'**
  String get recordMaintenanceForUnit;

  /// Change unit status dialog title / option
  ///
  /// In ar, this message translates to:
  /// **'تغيير حالة الوحدة'**
  String get changeUnitStatus;

  /// View contract details option
  ///
  /// In ar, this message translates to:
  /// **'عرض تفاصيل العقد'**
  String get viewContractDetails;

  /// Unit options modal title
  ///
  /// In ar, this message translates to:
  /// **'خيارات الوحدة'**
  String get unitOptionsTitle;

  /// Contracts search hint
  ///
  /// In ar, this message translates to:
  /// **'البحث في العقود...'**
  String get contractsSearchHint;

  /// Add contract button
  ///
  /// In ar, this message translates to:
  /// **'إضافة عقد'**
  String get addContract;

  /// Add contract page title
  ///
  /// In ar, this message translates to:
  /// **'إنشاء عقد جديد'**
  String get addContractTitle;

  /// Contract form section title
  ///
  /// In ar, this message translates to:
  /// **'بيانات العقد'**
  String get contractDataTitle;

  /// Contract form: tenant dropdown label
  ///
  /// In ar, this message translates to:
  /// **'المستأجر'**
  String get contractTenantLabel;

  /// Contract form: tenant dropdown hint
  ///
  /// In ar, this message translates to:
  /// **'اختر المستأجر'**
  String get contractTenantHint;

  /// Contract form: unit dropdown label
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get contractUnitLabel;

  /// Contract form: unit dropdown hint
  ///
  /// In ar, this message translates to:
  /// **'اختر الوحدة'**
  String get contractUnitHint;

  /// Contract form: monthly rent label
  ///
  /// In ar, this message translates to:
  /// **'قيمة الإيجار الشهري'**
  String get contractMonthlyRentLabel;

  /// Contract form: rent validation message
  ///
  /// In ar, this message translates to:
  /// **'أدخل قيمة الإيجار'**
  String get contractEnterRent;

  /// Contract form: currency label
  ///
  /// In ar, this message translates to:
  /// **'العملة'**
  String get contractCurrencyLabel;

  /// Contract form: start date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البداية'**
  String get contractStartDateLabel;

  /// Contract form: end date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ النهاية'**
  String get contractEndDateLabel;

  /// Contract form: notes label
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get contractNotesLabel;

  /// Contract form: notes hint
  ///
  /// In ar, this message translates to:
  /// **'أي ملاحظات إضافية...'**
  String get contractNotesHint;

  /// Save contract button
  ///
  /// In ar, this message translates to:
  /// **'حفظ العقد'**
  String get contractSaveButton;

  /// Contract saved success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء وحفظ العقد بنجاح!'**
  String get contractSavedSuccess;

  /// Date picker placeholder
  ///
  /// In ar, this message translates to:
  /// **'اختر تاريخ'**
  String get contractSelectDate;

  /// Default tenant option in contract form
  ///
  /// In ar, this message translates to:
  /// **'مستأجر افتراضي'**
  String get contractDefaultTenant;

  /// Default unit option in contract form
  ///
  /// In ar, this message translates to:
  /// **'وحدة افتراضية'**
  String get contractDefaultUnit;

  /// Contracts empty state
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عقود مسجلة بعد'**
  String get contractsEmpty;

  /// Contracts empty state subtitle
  ///
  /// In ar, this message translates to:
  /// **'أضف عقد إيجار جديد للبدء'**
  String get contractsEmptySubtitle;

  /// Contract card ID label
  ///
  /// In ar, this message translates to:
  /// **'عقد #{contractId}'**
  String contractCardId(String contractId);

  /// Contract details modal title
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل العقد'**
  String get contractDetailsTitle;

  /// Add payment for contract button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة'**
  String get addPaymentForContract;

  /// View statement button in contract modal
  ///
  /// In ar, this message translates to:
  /// **'كشف الحساب'**
  String get viewStatement;

  /// Payments filter: all
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get paymentsFilterAll;

  /// Add payment page title
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة جديدة'**
  String get addPaymentTitle;

  /// Add payment header title
  ///
  /// In ar, this message translates to:
  /// **'تسجيل دفعة إيجار جديدة'**
  String get addPaymentHeaderTitle;

  /// Payment form: tenant label
  ///
  /// In ar, this message translates to:
  /// **'المستأجر'**
  String get paymentTenantLabel;

  /// Payment form: tenant hint
  ///
  /// In ar, this message translates to:
  /// **'اختر المستأجر'**
  String get paymentTenantHint;

  /// Payment form: contract label
  ///
  /// In ar, this message translates to:
  /// **'عقد المستأجر'**
  String get paymentContractLabel;

  /// Payment form: contract hint
  ///
  /// In ar, this message translates to:
  /// **'اختر العقد'**
  String get paymentContractHint;

  /// Payment form: amount label
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get paymentAmountLabel;

  /// Payment form: amount hint
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get paymentAmountHint;

  /// Payment form: date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الدفع'**
  String get paymentDateLabel;

  /// Payment form: current date label
  ///
  /// In ar, this message translates to:
  /// **'التاريخ الحالي'**
  String get paymentCurrentDate;

  /// Payment form: method label
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentMethodLabel;

  /// Payment method: cash
  ///
  /// In ar, this message translates to:
  /// **'نقداً (Cash)'**
  String get paymentMethodCash;

  /// Payment method: bank transfer
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي'**
  String get paymentMethodBank;

  /// Payment method: check
  ///
  /// In ar, this message translates to:
  /// **'شيك'**
  String get paymentMethodCheck;

  /// Payment form: notes label
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get paymentNotesLabel;

  /// Payment form: notes hint
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات إضافية...'**
  String get paymentNotesHint;

  /// Payment summary section title
  ///
  /// In ar, this message translates to:
  /// **'ملخص الدفعة الجديدة'**
  String get paymentSummaryTitle;

  /// Payment submit button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل وحفظ الدفعة'**
  String get paymentSummarySubmit;

  /// Payment saved success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدفعة وحفظها بنجاح!'**
  String get paymentSavedSuccess;

  /// Payment validation error snackbar
  ///
  /// In ar, this message translates to:
  /// **'يرجى ملء جميع الحقول المطلوبة أولاً!'**
  String get paymentValidationError;

  /// Payments empty state
  ///
  /// In ar, this message translates to:
  /// **'لا توجد دفعات مسجلة بعد'**
  String get paymentsEmpty;

  /// Payments search hint
  ///
  /// In ar, this message translates to:
  /// **'البحث في الدفعات...'**
  String get paymentsSearchHint;

  /// Payment details modal title
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الدفعة'**
  String get paymentDetailsTitle;

  /// Payment details: tenant label
  ///
  /// In ar, this message translates to:
  /// **'المستأجر'**
  String get paymentDetailsTenant;

  /// Payment details: contract label
  ///
  /// In ar, this message translates to:
  /// **'العقد المرتبط'**
  String get paymentDetailsContract;

  /// Payment details: amount label
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get paymentDetailsAmount;

  /// Payment details: date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الدفع'**
  String get paymentDetailsDate;

  /// Payment details: method label
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentDetailsMethod;

  /// Payment details: notes label
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get paymentDetailsNotes;

  /// Print receipt PDF button
  ///
  /// In ar, this message translates to:
  /// **'طباعة / مشاركة سند القبض (PDF)'**
  String get printReceiptPdf;

  /// Print receipt loading snackbar
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل وتصدير سند القبض PDF...'**
  String get printReceiptLoading;

  /// Add maintenance page title
  ///
  /// In ar, this message translates to:
  /// **'تسجيل مصروف صيانة'**
  String get maintenanceTitle;

  /// Add maintenance header title
  ///
  /// In ar, this message translates to:
  /// **'تسجيل مصاريف الصيانة / المصاريف'**
  String get maintenanceHeaderTitle;

  /// Maintenance description label
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get maintenanceDescLabel;

  /// Maintenance description hint
  ///
  /// In ar, this message translates to:
  /// **'مثال: إصلاح سخان الماء الساخن في شقة...'**
  String get maintenanceDescHint;

  /// Maintenance description validation
  ///
  /// In ar, this message translates to:
  /// **'الوصف مطلوب'**
  String get maintenanceDescRequired;

  /// Maintenance amount label
  ///
  /// In ar, this message translates to:
  /// **'المبلغ (بالعملة الافتراضية)'**
  String get maintenanceAmountLabel;

  /// Maintenance amount validation
  ///
  /// In ar, this message translates to:
  /// **'أدخل المبلغ'**
  String get maintenanceAmountRequired;

  /// Maintenance unit label
  ///
  /// In ar, this message translates to:
  /// **'الوحدة السكنية (اختياري)'**
  String get maintenanceUnitLabel;

  /// General maintenance option (no specific unit)
  ///
  /// In ar, this message translates to:
  /// **'مصروف عام (بدون تحديد وحدة)'**
  String get maintenanceUnitGeneral;

  /// Maintenance notes label
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get maintenanceNotesLabel;

  /// Maintenance notes hint
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات إضافية...'**
  String get maintenanceNotesHint;

  /// Maintenance submit button
  ///
  /// In ar, this message translates to:
  /// **'تسجيل المصروف'**
  String get maintenanceSubmitButton;

  /// Maintenance saved success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل مصروف الصيانة بنجاح!'**
  String get maintenanceSavedSuccess;

  /// Maintenance validation error
  ///
  /// In ar, this message translates to:
  /// **'يرجى ملء جميع الحقول المطلوبة أولاً!'**
  String get maintenanceValidationError;

  /// General maintenance unit name (short)
  ///
  /// In ar, this message translates to:
  /// **'مصروف عام'**
  String get maintenanceGeneralUnit;

  /// Tenants search bar hint
  ///
  /// In ar, this message translates to:
  /// **'البحث في المستأجرين...'**
  String get tenantsSearchHint;

  /// Add tenant button
  ///
  /// In ar, this message translates to:
  /// **'إضافة مستأجر'**
  String get addTenant;

  /// Add tenant dialog title
  ///
  /// In ar, this message translates to:
  /// **'إضافة مستأجر جديد'**
  String get addTenantTitle;

  /// Tenant name field hint
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get addTenantNameHint;

  /// Tenant phone field hint
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get addTenantPhoneHint;

  /// Tenant national ID field hint
  ///
  /// In ar, this message translates to:
  /// **'رقم الهوية (اختياري)'**
  String get addTenantIdHint;

  /// Save tenant button
  ///
  /// In ar, this message translates to:
  /// **'إضافة المستأجر'**
  String get addTenantSave;

  /// Tenant added success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة المستأجر بنجاح!'**
  String get tenantAddedSuccess;

  /// Tenants empty state message
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد مستأجرون مسجلون بعد'**
  String get tenantsEmpty;

  /// Tenants empty state subtitle
  ///
  /// In ar, this message translates to:
  /// **'أضف مستأجرًا جديدًا للبدء'**
  String get tenantsEmptySubtitle;

  /// Tenant card: no unit assigned
  ///
  /// In ar, this message translates to:
  /// **'بدون وحدة سكنية حالياً'**
  String get tenantNoUnit;

  /// Calling tenant snackbar message
  ///
  /// In ar, this message translates to:
  /// **'جاري الاتصال بـ {phone}...'**
  String tenantCallingPrefix(String phone);

  /// Tenant details: phone label
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف:'**
  String get tenantDetailsPhone;

  /// Tenant details: national ID label
  ///
  /// In ar, this message translates to:
  /// **'رقم الهوية:'**
  String get tenantDetailsId;

  /// Tenant details: contracts section title
  ///
  /// In ar, this message translates to:
  /// **'العقود والوحدات المرتبطة:'**
  String get tenantDetailsContracts;

  /// No active contracts for tenant
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عقود نشطة حالياً لهذا المستأجر.'**
  String get tenantNoContracts;

  /// Tenant contract row info
  ///
  /// In ar, this message translates to:
  /// **'عقد #{contractId} • الإيجار: {rent} \$'**
  String tenantContractInfo(String contractId, int rent);

  /// View full statement button
  ///
  /// In ar, this message translates to:
  /// **'عرض كشف الحساب الشامل'**
  String get tenantViewStatement;

  /// Tenant statement page title
  ///
  /// In ar, this message translates to:
  /// **'كشف حساب المستأجر'**
  String get tenantStatementTitle;

  /// Export statement PDF button
  ///
  /// In ar, this message translates to:
  /// **'تصدير كشف الحساب (PDF)'**
  String get tenantStatementExportPdf;

  /// Tenant statement: no payments message
  ///
  /// In ar, this message translates to:
  /// **'لا توجد دفعات مسجلة لهذا المستأجر بعد.'**
  String get tenantStatementNoPayments;

  /// Tenant statement balance label
  ///
  /// In ar, this message translates to:
  /// **'الرصيد / المستحقات'**
  String get tenantStatementBalanceLabel;

  /// Tenant statement: paid status
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get tenantStatementPaidStatus;

  /// Tenant statement tile payment info
  ///
  /// In ar, this message translates to:
  /// **'دفعة من {contractInfo} ({method})'**
  String tenantStatementPaymentInfo(String contractInfo, String method);

  /// Tenant statement tile status
  ///
  /// In ar, this message translates to:
  /// **'الحالة: {status}'**
  String tenantStatementPaymentStatus(String status);

  /// Financial reports page title
  ///
  /// In ar, this message translates to:
  /// **'التقارير المالية'**
  String get financialReportTitle;

  /// Report filter label
  ///
  /// In ar, this message translates to:
  /// **'تصفية حسب الفترة'**
  String get reportFilterLabel;

  /// Report: total collected stat
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المحصل'**
  String get reportTotalCollected;

  /// Report: total due stat
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المستحقات'**
  String get reportTotalDue;

  /// Report: collection rate stat
  ///
  /// In ar, this message translates to:
  /// **'نسبة التحصيل'**
  String get reportCollectionRate;

  /// Report: arrears stat
  ///
  /// In ar, this message translates to:
  /// **'المتأخرات'**
  String get reportArrears;

  /// Currencies page title
  ///
  /// In ar, this message translates to:
  /// **'إدارة العملات'**
  String get currenciesTitle;

  /// Currencies empty state
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عملات مضافة بعد'**
  String get currenciesEmpty;

  /// Add currency button
  ///
  /// In ar, this message translates to:
  /// **'إضافة عملة'**
  String get addCurrency;

  /// Add currency dialog title
  ///
  /// In ar, this message translates to:
  /// **'إضافة عملة جديدة'**
  String get addCurrencyTitle;

  /// Currency code field hint
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة (USD)'**
  String get currencyCodeHint;

  /// Currency name field hint
  ///
  /// In ar, this message translates to:
  /// **'اسم العملة (دولار أمريكي)'**
  String get currencyNameHint;

  /// Currency symbol field hint
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة (\$)'**
  String get currencySymbolHint;

  /// Currency rate field hint
  ///
  /// In ar, this message translates to:
  /// **'سعر الصرف مقابل الأساس'**
  String get currencyRateHint;

  /// Save currency button
  ///
  /// In ar, this message translates to:
  /// **'إضافة العملة'**
  String get currencySaveButton;

  /// Settings page title
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// Settings: backup item title
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي'**
  String get settingsBackup;

  /// Settings: backup subtitle
  ///
  /// In ar, this message translates to:
  /// **'Google Drive'**
  String get settingsBackupSubtitle;

  /// Backup dialog title
  ///
  /// In ar, this message translates to:
  /// **'النسخ الاحتياطي'**
  String get settingsBackupDialogTitle;

  /// Backup dialog body text
  ///
  /// In ar, this message translates to:
  /// **'سيتم نسخ قاعدة بيانات العقارات والمستأجرين كاملة إلى حساب Google Drive الخاص بك.'**
  String get settingsBackupDialogBody;

  /// Backup now button
  ///
  /// In ar, this message translates to:
  /// **'نسخ الآن'**
  String get settingsBackupNow;

  /// Backup success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم رفع النسخة الاحتياطية إلى Google Drive بنجاح!'**
  String get settingsBackupSuccess;

  /// Settings: currency item title
  ///
  /// In ar, this message translates to:
  /// **'العملة الافتراضية وإدارتها'**
  String get settingsCurrency;

  /// Settings: currency subtitle
  ///
  /// In ar, this message translates to:
  /// **'دولار أمريكي - USD'**
  String get settingsCurrencySubtitle;

  /// Settings: language item title
  ///
  /// In ar, this message translates to:
  /// **'اللغة الحالية'**
  String get settingsLanguage;

  /// Settings: language subtitle (Arabic)
  ///
  /// In ar, this message translates to:
  /// **'العربية (RTL)'**
  String get settingsLanguageSubtitle;

  /// Settings: language subtitle (English)
  ///
  /// In ar, this message translates to:
  /// **'English (LTR)'**
  String get settingsLanguageSubtitleEn;

  /// Language selection dialog title
  ///
  /// In ar, this message translates to:
  /// **'اختر اللغة'**
  String get settingsLanguageDialogTitle;

  /// Arabic language option
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// English language option
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Settings: theme item title
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get settingsTheme;

  /// Theme selection dialog title
  ///
  /// In ar, this message translates to:
  /// **'اختر المظهر'**
  String get settingsThemeDialogTitle;

  /// Light theme option
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get settingsThemeLight;

  /// Dark theme option
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get settingsThemeDark;

  /// Follow system theme option
  ///
  /// In ar, this message translates to:
  /// **'حسب النظام'**
  String get settingsThemeSystem;

  /// Settings: notifications toggle title
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات والإشعارات'**
  String get settingsNotifications;

  /// Settings: notifications subtitle
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات الإيجارات المتأخرة والعقود'**
  String get settingsNotificationsSubtitle;

  /// Settings: biometric toggle title
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول بالبصمة'**
  String get settingsBiometric;

  /// Settings: biometric subtitle
  ///
  /// In ar, this message translates to:
  /// **'إظهار زر البصمة في شاشة تسجيل الدخول'**
  String get settingsBiometricSubtitle;

  /// Settings: change password item
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get settingsChangePassword;

  /// Change password dialog title
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get settingsChangePasswordTitle;

  /// Old password field hint
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الحالية'**
  String get settingsChangePasswordOldHint;

  /// New password field hint
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get settingsChangePasswordNewHint;

  /// Change password button
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get settingsChangePasswordButton;

  /// Change password success snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير كلمة المرور بنجاح'**
  String get settingsChangePasswordSuccess;

  /// Settings: about item
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get settingsAbout;

  /// App version in settings
  ///
  /// In ar, this message translates to:
  /// **'v1.0.0'**
  String get settingsAboutVersion;

  /// Sign out button in settings
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get settingsSignOut;

  /// Field required validation message
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get validationRequired;

  /// Invalid email validation message
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بريد إلكتروني صحيح'**
  String get validationEmail;

  /// Password too short validation
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 6 أحرف على الأقل'**
  String get validationPasswordLength;

  /// Password mismatch validation
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور غير متطابقة'**
  String get validationPasswordMismatch;

  /// Phone too short validation
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف قصير جدًا'**
  String get validationPhoneTooShort;

  /// Invalid phone validation
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب أن يحتوي على أرقام فقط'**
  String get validationPhoneInvalid;

  /// Name too short validation
  ///
  /// In ar, this message translates to:
  /// **'الاسم قصير جدًا'**
  String get validationNameTooShort;

  /// Invalid number validation
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رقم صحيح'**
  String get validationNumberInvalid;

  /// Generic save button
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// Retry button when profile fails to load
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get profileRetry;

  /// Edit profile dialog title
  ///
  /// In ar, this message translates to:
  /// **'تعديل البيانات'**
  String get profileEditTitle;

  /// Profile saved snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ البيانات بنجاح'**
  String get profileSaved;

  /// Shown when the profile has no phone
  ///
  /// In ar, this message translates to:
  /// **'لم يُضف رقم هاتف بعد'**
  String get profileNoPhone;

  /// Avatar options bottom sheet title
  ///
  /// In ar, this message translates to:
  /// **'صورة الملف الشخصي'**
  String get profileAvatarSheetTitle;

  /// Pick avatar from gallery
  ///
  /// In ar, this message translates to:
  /// **'اختيار من المعرض'**
  String get profileAvatarFromGallery;

  /// Take avatar with camera
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة بالكاميرا'**
  String get profileAvatarTakePhoto;

  /// Remove current avatar
  ///
  /// In ar, this message translates to:
  /// **'إزالة الصورة'**
  String get profileAvatarRemove;

  /// Avatar updated snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الصورة بنجاح'**
  String get profileAvatarUpdated;

  /// Avatar removed snackbar
  ///
  /// In ar, this message translates to:
  /// **'تم حذف صورة الملف الشخصي'**
  String get profileAvatarRemoved;

  /// Report chart section title: revenue for the selected period
  ///
  /// In ar, this message translates to:
  /// **'الإيرادات خلال الفترة المحددة'**
  String get reportRevenuePeriod;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
