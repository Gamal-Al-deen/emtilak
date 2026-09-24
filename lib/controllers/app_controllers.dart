import 'package:flutter/foundation.dart';
import 'building_controller.dart';
import 'unit_controller.dart';
import 'tenant_controller.dart';
import 'contract_controller.dart';
import 'payment_controller.dart';
import 'maintenance_controller.dart';
import 'currency_controller.dart';
import 'profile_controller.dart';
import 'locale_controller.dart';
import '../models/app_models.dart';

export 'building_controller.dart';
export 'unit_controller.dart';
export 'tenant_controller.dart';
export 'contract_controller.dart';
export 'payment_controller.dart';
export 'maintenance_controller.dart';
export 'currency_controller.dart';
export 'profile_controller.dart';
export 'locale_controller.dart';

class AppControllers extends ChangeNotifier {
  static final AppControllers _instance = AppControllers._internal();
  factory AppControllers() => _instance;
  static AppControllers get instance => _instance;

  final BuildingController buildingController = BuildingController();
  final UnitController unitController = UnitController();
  final TenantController tenantController = TenantController();
  final ContractController contractController = ContractController();
  final PaymentController paymentController = PaymentController();
  final MaintenanceController maintenanceController = MaintenanceController();
  final CurrencyController currencyController = CurrencyController();
  final ProfileController profileController = ProfileController();
  final LocaleController localeController = LocaleController();

  bool _isInitialized = false;

  AppControllers._internal() {
    // Forward notifications from sub-controllers
    buildingController.addListener(notifyListeners);
    unitController.addListener(notifyListeners);
    tenantController.addListener(notifyListeners);
    contractController.addListener(notifyListeners);
    paymentController.addListener(notifyListeners);
    maintenanceController.addListener(notifyListeners);
    currencyController.addListener(notifyListeners);
    profileController.addListener(notifyListeners);
    localeController.addListener(notifyListeners);

    initControllers();
  }

  Future<void> initControllers() async {
    if (_isInitialized) return;
    try {
      await localeController.loadLocale();
      await buildingController.loadBuildings();
      await unitController.loadUnits();
      await tenantController.loadTenants();
      await contractController.loadContracts();
      await paymentController.loadPayments();
      await maintenanceController.loadMaintenances();
      await currencyController.loadCurrencies();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing controllers: $e');
    }
  }

  // Convenient Delegate Getters for UI views
  List<Building> get buildings => buildingController.buildings;
  List<Unit> get units => unitController.units;
  List<Tenant> get tenants => tenantController.tenants;
  List<Contract> get contracts => contractController.contracts;
  List<Payment> get payments => paymentController.payments;
  List<MaintenanceExpense> get maintenances => maintenanceController.maintenances;
  List<CurrencyModel> get currencies => currencyController.currencies;
  UserProfile? get profile => profileController.profile;

  /// يحمّل الملف الشخصي من Supabase (يتجاهل التكرار إلا مع [force]).
  Future<void> loadProfile({bool force = false}) =>
      profileController.loadProfile(force: force);

  // Summary helpers for Dashboard
  int get totalBuildingsCount => buildingController.totalBuildingsCount;
  int get totalUnitsCount => unitController.totalUnitsCount;
  int get rentedUnitsCount => unitController.rentedUnitsCount;
  int get vacantUnitsCount => unitController.vacantUnitsCount;
  double get totalIncomeCollected => paymentController.totalIncomeCollected;

  double get collectedRatio {
    if (payments.isEmpty) return 0.0;
    final collected = payments.where((p) => p.status == 'مدفوع').length;
    return collected / payments.length;
  }

  double get delayedRatio {
    if (payments.isEmpty) return 0.0;
    final delayed = payments.where((p) => p.status == 'متأخر').length;
    return delayed / payments.length;
  }

  double get pendingRatio {
    if (payments.isEmpty) return 0.0;
    final pending = payments.where((p) => p.status == 'جزئي').length;
    return pending / payments.length;
  }

  List<Unit> getUnitsForBuilding(String buildingName) =>
      unitController.getUnitsForBuilding(buildingName);

  List<Payment> getPaymentsForContract(String contractId) =>
      paymentController.getPaymentsForContract(contractId);

  List<Contract> getContractsForTenant(String tenantName) =>
      contractController.getContractsForTenant(tenantName);

  // Convenient Delegate Mutators with Validation
  Future<String?> addBuilding({
    required String name,
    required String location,
    required int totalUnits,
  }) async {
    return await buildingController.addBuilding(
      name: name,
      location: location,
      totalUnits: totalUnits,
      unitController: unitController,
    );
  }

  Future<String?> addUnit({
    required String buildingName,
    required String number,
    required String status,
    double monthlyRent = 0.0,
    String? currentTenant,
  }) async {
    final building = buildings.firstWhere(
      (b) => b.name == buildingName,
      orElse: () => buildings.isNotEmpty
          ? buildings.first
          : Building(id: 'b_custom', name: buildingName, location: '', totalUnits: 1),
    );

    return await unitController.addUnit(
      buildingId: building.id,
      buildingName: buildingName,
      number: number,
      status: status,
      monthlyRent: monthlyRent,
      currentTenant: currentTenant,
    );
  }

  Future<void> updateUnitStatus(String unitNumber, String newStatus) async {
    await unitController.updateUnitStatus(unitNumber, newStatus);
  }

  Future<String?> addTenant({
    required String name,
    required String phone,
    String nationalId = '',
  }) async {
    return await tenantController.addTenant(
      name: name,
      phone: phone,
      nationalId: nationalId,
    );
  }

  Future<String?> addContract({
    required String tenantName,
    required String unitName,
    required String buildingName,
    required double monthlyRent,
    String currency = 'USD',
    required String startDate,
    required String endDate,
    String? notes,
    String? unitId,
  }) async {
    return await contractController.addContract(
      tenantName: tenantName,
      unitName: unitName,
      buildingName: buildingName,
      monthlyRent: monthlyRent,
      currency: currency,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
      unitId: unitId,
      unitController: unitController,
      tenantController: tenantController,
    );
  }

  Future<String?> addPayment({
    String? contractId,
    required String tenantName,
    required String contractInfo,
    required double amount,
    String currency = '\$',
    required String paymentDate,
    required String status,
    required String method,
    String? notes,
  }) async {
    return await paymentController.addPayment(
      contractId: contractId,
      tenantName: tenantName,
      contractInfo: contractInfo,
      amount: amount,
      currency: currency,
      paymentDate: paymentDate,
      status: status,
      method: method,
      notes: notes,
    );
  }

  Future<String?> addMaintenance({
    required String description,
    required double amount,
    String currency = '\$',
    required String unitName,
    required String date,
    String? notes,
  }) async {
    return await maintenanceController.addMaintenance(
      description: description,
      amount: amount,
      currency: currency,
      unitName: unitName,
      date: date,
      notes: notes,
      unitController: unitController,
    );
  }

  Future<String?> addCurrency({
    required String code,
    required String name,
    required String symbol,
    required double rate,
  }) async {
    return await currencyController.addCurrency(
      code: code,
      name: name,
      symbol: symbol,
      rate: rate,
    );
  }

  Future<void> setBaseCurrency(String code) async {
    await currencyController.setBaseCurrency(code);
  }

  Future<void> updateCurrencyRate(String code, double newRate) async {
    await currencyController.updateCurrencyRate(code, newRate);
  }
}
