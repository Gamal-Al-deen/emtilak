import 'package:flutter/foundation.dart';
import '../models/app_models.dart';
import 'mock_building_data.dart';
import 'mock_contract_data.dart';
import 'mock_currency_data.dart';
import 'mock_maintenance_data.dart';
import 'mock_payment_data.dart';
import 'mock_tenant_data.dart';
import 'mock_unit_data.dart';

class MockDataService extends ChangeNotifier {
  // Singleton Pattern
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  static MockDataService get instance => _instance;

  MockDataService._internal() {
    _initDemoData();
  }

  // Collections
  final List<Building> _buildings = [];
  final List<Unit> _units = [];
  final List<Tenant> _tenants = [];
  final List<Contract> _contracts = [];
  final List<Payment> _payments = [];
  final List<MaintenanceExpense> _maintenances = [];
  final List<CurrencyModel> _currencies = [];

  // Getters (Unmodifiable Views)
  List<Building> get buildings => List.unmodifiable(_buildings);
  List<Unit> get units => List.unmodifiable(_units);
  List<Tenant> get tenants => List.unmodifiable(_tenants);
  List<Contract> get contracts => List.unmodifiable(_contracts);
  List<Payment> get payments => List.unmodifiable(_payments);
  List<MaintenanceExpense> get maintenances => List.unmodifiable(_maintenances);
  List<CurrencyModel> get currencies => List.unmodifiable(_currencies);

  void _initDemoData() {
    _buildings.addAll(initialMockBuildings);
    _units.addAll(initialMockUnits);
    _tenants.addAll(initialMockTenants);
    _contracts.addAll(initialMockContracts);
    _payments.addAll(initialMockPayments);
    _maintenances.addAll(initialMockMaintenances);
    _currencies.addAll(initialMockCurrencies);
  }

  // ===================== CRUD OPERATIONS =====================

  // --- Buildings ---
  void addBuilding({
    required String name,
    required String location,
    required int totalUnits,
  }) {
    final newId = 'b${_buildings.length + 1}';
    final building = Building(
      id: newId,
      name: name,
      location: location,
      totalUnits: totalUnits,
    );
    _buildings.add(building);

    // Auto generate initial units for the new building
    for (int i = 1; i <= totalUnits; i++) {
      _units.add(
        Unit(
          id: 'u_${newId}_$i',
          buildingId: newId,
          number: 'U${i.toString().padLeft(2, '0')}',
          buildingName: name,
          status: 'فارغة',
          monthlyRent: 0.0,
        ),
      );
    }
    notifyListeners();
  }

  // --- Units ---
  List<Unit> getUnitsForBuilding(String buildingName) {
    return _units.where((u) => u.buildingName == buildingName).toList();
  }

  void addUnit({
    required String buildingName,
    required String number,
    required String status,
    double monthlyRent = 0.0,
    String? currentTenant,
  }) {
    final building = _buildings.firstWhere(
      (b) => b.name == buildingName,
      orElse: () => _buildings.isNotEmpty
          ? _buildings.first
          : Building(
              id: 'b_custom',
              name: buildingName,
              location: '',
              totalUnits: 1,
            ),
    );

    _units.add(
      Unit(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        buildingId: building.id,
        number: number,
        buildingName: buildingName,
        status: status,
        monthlyRent: monthlyRent,
        currentTenant: currentTenant,
      ),
    );
    notifyListeners();
  }

  void updateUnitStatus(String unitNumber, String newStatus) {
    final index = _units.indexWhere((u) => u.number == unitNumber);
    if (index != -1) {
      _units[index] = _units[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // --- Tenants ---
  void addTenant({
    required String name,
    required String phone,
    String nationalId = '',
    String unitName = 'بدون وحدة سكنية حالياً',
  }) {
    _tenants.add(
      Tenant(
        id: 't${_tenants.length + 1}',
        name: name,
        phone: phone,
        nationalId: nationalId,
        unitName: unitName,
      ),
    );
    notifyListeners();
  }

  // --- Contracts ---
  void addContract({
    required String tenantName,
    required String unitName,
    required String buildingName,
    required double monthlyRent,
    String currency = 'USD',
    required String startDate,
    required String endDate,
    String? notes,
  }) {
    final id = '${100 + _contracts.length + 1}';
    _contracts.insert(
      0,
      Contract(
        id: id,
        tenantName: tenantName,
        unitName: unitName,
        buildingName: buildingName,
        monthlyRent: monthlyRent,
        currency: currency,
        startDate: startDate,
        endDate: endDate,
        status: 'نشط',
        notes: notes,
      ),
    );

    // Also update Unit status to rented if matched
    final unitIndex = _units.indexWhere((u) => unitName.contains(u.number));
    if (unitIndex != -1) {
      _units[unitIndex] = _units[unitIndex].copyWith(
        status: 'مؤجرة',
        currentTenant: tenantName,
        monthlyRent: monthlyRent,
      );
    }

    // Update tenant unit
    final tenantIndex = _tenants.indexWhere((t) => t.name == tenantName);
    if (tenantIndex != -1) {
      _tenants[tenantIndex] = _tenants[tenantIndex].copyWith(
        unitName: unitName,
      );
    }

    notifyListeners();
  }

  // --- Payments ---
  void addPayment({
    required String tenantName,
    required String contractInfo,
    required double amount,
    String currency = '\$',
    required String paymentDate,
    required String status,
    required String method,
    String? notes,
  }) {
    _payments.insert(
      0,
      Payment(
        id: 'p${_payments.length + 1}',
        tenantName: tenantName,
        contractInfo: contractInfo,
        amount: amount,
        currency: currency,
        paymentDate: paymentDate,
        status: status,
        method: method,
        notes: notes,
      ),
    );
    notifyListeners();
  }

  // --- Maintenance ---
  void addMaintenance({
    required String description,
    required double amount,
    String currency = '\$',
    required String unitName,
    required String date,
    String? notes,
  }) {
    _maintenances.insert(
      0,
      MaintenanceExpense(
        id: 'm${_maintenances.length + 1}',
        description: description,
        amount: amount,
        currency: currency,
        unitName: unitName,
        date: date,
        notes: notes,
      ),
    );

    // If unit specified, update status to maintenance
    if (unitName != 'مصروف عام (بدون تحديد وحدة)') {
      final uIndex = _units.indexWhere((u) => unitName.contains(u.number));
      if (uIndex != -1) {
        _units[uIndex] = _units[uIndex].copyWith(status: 'صيانة');
      }
    }

    notifyListeners();
  }

  // --- Currencies ---
  void addCurrency({
    required String code,
    required String name,
    required String symbol,
    required double rate,
  }) {
    _currencies.add(
      CurrencyModel(
        code: code,
        name: name,
        symbol: symbol,
        isBase: false,
        rate: rate,
      ),
    );
    notifyListeners();
  }

  void setBaseCurrency(String code) {
    for (int i = 0; i < _currencies.length; i++) {
      final isCurrent = _currencies[i].code == code;
      _currencies[i] = _currencies[i].copyWith(isBase: isCurrent);
    }
    notifyListeners();
  }

  void updateCurrencyRate(String code, double newRate) {
    final index = _currencies.indexWhere((c) => c.code == code);
    if (index != -1) {
      _currencies[index] = _currencies[index].copyWith(rate: newRate);
      notifyListeners();
    }
  }

  // Summary helpers for Dashboard
  int get totalBuildingsCount => _buildings.length;
  int get totalUnitsCount => _units.length;
  int get rentedUnitsCount => _units.where((u) => u.status == 'مؤجرة').length;
  int get vacantUnitsCount => _units.where((u) => u.status == 'فارغة').length;
  double get totalIncomeCollected => _payments
      .where((p) => p.status == 'مدفوع')
      .fold(0.0, (sum, item) => sum + item.amount);
}
