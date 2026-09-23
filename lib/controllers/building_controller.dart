import 'package:flutter/foundation.dart';
import '../models/building_model.dart';
import '../database/database_helper.dart';
import 'unit_controller.dart';

class BuildingController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<Building> _buildings = [];

  List<Building> get buildings => List.unmodifiable(_buildings);
  int get totalBuildingsCount => _buildings.length;

  Future<void> loadBuildings() async {
    final list = await _dbHelper.getAllBuildings();
    _buildings.clear();
    _buildings.addAll(list);
    notifyListeners();
  }

  /// Adds a new building with input validation
  Future<String?> addBuilding({
    required String name,
    required String location,
    required int totalUnits,
    UnitController? unitController,
  }) async {
    // Input Validation
    if (name.trim().isEmpty) {
      return 'اسم المبنى مطلوب ولا يمكن أن يكون فارغاً.';
    }
    if (location.trim().isEmpty) {
      return 'عنوان/موقع المبنى مطلوب.';
    }
    if (totalUnits <= 0) {
      return 'عدد الوحدات يجب أن يكون أكبر من 0.';
    }

    final newId = 'b_${DateTime.now().millisecondsSinceEpoch}';
    final building = Building(
      id: newId,
      name: name.trim(),
      location: location.trim(),
      totalUnits: totalUnits,
    );

    _buildings.add(building);
    await _dbHelper.insertBuilding(building);

    // Automatically generate units if unitController is provided
    if (unitController != null) {
      await unitController.generateUnitsForBuilding(
        buildingId: newId,
        buildingName: name.trim(),
        totalUnits: totalUnits,
      );
    }

    notifyListeners();
    return null; // Return null on success
  }

  Future<void> updateBuilding(Building building) async {
    final index = _buildings.indexWhere((b) => b.id == building.id);
    if (index != -1) {
      _buildings[index] = building;
      await _dbHelper.updateBuilding(building);
      notifyListeners();
    }
  }

  Future<void> deleteBuilding(String id) async {
    _buildings.removeWhere((b) => b.id == id);
    await _dbHelper.deleteBuilding(id);
    notifyListeners();
  }
}
