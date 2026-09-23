import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';
import '../database/database_helper.dart';

class UnitController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<Unit> _units = [];

  List<Unit> get units => List.unmodifiable(_units);
  int get totalUnitsCount => _units.length;
  int get rentedUnitsCount => _units.where((u) => u.status == 'مؤجرة').length;
  int get vacantUnitsCount => _units.where((u) => u.status == 'فارغة').length;

  Future<void> loadUnits() async {
    final list = await _dbHelper.getAllUnits();
    _units.clear();
    _units.addAll(list);
    notifyListeners();
  }

  List<Unit> getUnitsForBuilding(String buildingName) {
    return _units.where((u) => u.buildingName == buildingName).toList();
  }

  /// Auto generate initial units for a new building
  Future<void> generateUnitsForBuilding({
    required String buildingId,
    required String buildingName,
    required int totalUnits,
  }) async {
    for (int i = 1; i <= totalUnits; i++) {
      final unit = Unit(
        id: 'u_${buildingId}_$i',
        buildingId: buildingId,
        number: 'U${i.toString().padLeft(2, '0')}',
        buildingName: buildingName,
        status: 'فارغة',
        monthlyRent: 0.0,
      );
      _units.add(unit);
      await _dbHelper.insertUnit(unit);
    }
    notifyListeners();
  }

  /// Adds a unit with validation
  Future<String?> addUnit({
    required String buildingId,
    required String buildingName,
    required String number,
    required String status,
    double monthlyRent = 0.0,
    String? currentTenant,
  }) async {
    // Validation
    if (number.trim().isEmpty) {
      return 'رقم/اسم الوحدة مطلوب.';
    }
    if (buildingName.trim().isEmpty) {
      return 'اسم المبنى مرتبط مطلوب.';
    }
    if (monthlyRent < 0) {
      return 'قيمة الإيجار لا يمكن أن تكون بالسالب.';
    }

    final unit = Unit(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      buildingId: buildingId,
      number: number.trim(),
      buildingName: buildingName.trim(),
      status: status,
      monthlyRent: monthlyRent,
      currentTenant: currentTenant,
    );

    _units.add(unit);
    await _dbHelper.insertUnit(unit);
    notifyListeners();
    return null;
  }

  Future<void> updateUnitStatus(String unitNumber, String newStatus) async {
    final index = _units.indexWhere((u) => u.number == unitNumber);
    if (index != -1) {
      _units[index] = _units[index].copyWith(status: newStatus);
      await _dbHelper.updateUnit(_units[index]);
      notifyListeners();
    }
  }

  Future<void> updateUnit(Unit unit) async {
    final index = _units.indexWhere((u) => u.id == unit.id);
    if (index != -1) {
      _units[index] = unit;
      await _dbHelper.updateUnit(unit);
      notifyListeners();
    }
  }
}
