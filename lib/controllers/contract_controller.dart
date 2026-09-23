import 'package:flutter/foundation.dart';
import '../models/contract_model.dart';
import '../database/database_helper.dart';
import 'unit_controller.dart';
import 'tenant_controller.dart';

class ContractController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<Contract> _contracts = [];

  List<Contract> get contracts => List.unmodifiable(_contracts);

  Future<void> loadContracts() async {
    final list = await _dbHelper.getAllContracts();
    _contracts.clear();
    _contracts.addAll(list);
    notifyListeners();
  }

  List<Contract> getContractsForTenant(String tenantName) {
    return _contracts.where((c) => c.tenantName == tenantName).toList();
  }

  /// Adds a contract with validation
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
    UnitController? unitController,
    TenantController? tenantController,
  }) async {
    // Validation
    if (tenantName.trim().isEmpty) {
      return 'يرجى اختيار أو إدخال اسم المستأجر.';
    }
    if (unitName.trim().isEmpty) {
      return 'يرجى اختيار الوحدة الإيجارية.';
    }
    if (buildingName.trim().isEmpty) {
      return 'يرجى اختيار المبنى.';
    }
    if (monthlyRent <= 0) {
      return 'مبلغ الإيجار الشهري يجب أن يكون أكبر من 0.';
    }
    if (startDate.trim().isEmpty || endDate.trim().isEmpty) {
      return 'تاريخ بداية ونهاية العقد مطلوبان.';
    }

    final id = 'c_${DateTime.now().millisecondsSinceEpoch}';
    final contract = Contract(
      id: id,
      tenantName: tenantName.trim(),
      unitName: unitName.trim(),
      buildingName: buildingName.trim(),
      monthlyRent: monthlyRent,
      currency: currency,
      startDate: startDate.trim(),
      endDate: endDate.trim(),
      status: 'نشط',
      notes: notes?.trim(),
    );

    _contracts.insert(0, contract);
    await _dbHelper.insertContract(contract);

    // Update Unit status if unitController is provided
    if (unitController != null) {
      final unitNumber = unitName.contains(' - ') ? unitName.split(' - ').first.trim() : unitName.trim();
      final uIndex = unitController.units.indexWhere(
        (u) => (unitId != null && u.id == unitId) || u.number == unitNumber || unitName.contains(u.number),
      );
      if (uIndex != -1) {
        final matchedUnit = unitController.units[uIndex];
        final updatedUnit = matchedUnit.copyWith(
          status: 'مؤجرة',
          currentTenant: tenantName.trim(),
          monthlyRent: monthlyRent,
        );
        await unitController.updateUnit(updatedUnit);
      }
    }

    notifyListeners();
    return null;
  }
}
