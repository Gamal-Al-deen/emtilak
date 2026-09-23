import 'package:flutter/foundation.dart';
import '../models/maintenance_model.dart';
import '../database/database_helper.dart';
import 'unit_controller.dart';

class MaintenanceController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<MaintenanceExpense> _maintenances = [];

  List<MaintenanceExpense> get maintenances => List.unmodifiable(_maintenances);

  Future<void> loadMaintenances() async {
    final list = await _dbHelper.getAllMaintenanceExpenses();
    _maintenances.clear();
    _maintenances.addAll(list);
    notifyListeners();
  }

  /// Adds a maintenance expense with validation
  Future<String?> addMaintenance({
    required String description,
    required double amount,
    String currency = '\$',
    required String unitName,
    required String date,
    String? notes,
    UnitController? unitController,
  }) async {
    // Validation
    if (description.trim().isEmpty) {
      return 'وصف مصروف الصيانة مطلوب.';
    }
    if (amount <= 0) {
      return 'المبلغ يجب أن يكون أكبر من 0.';
    }
    if (date.trim().isEmpty) {
      return 'تاريخ الصيانة مطلوب.';
    }

    final expense = MaintenanceExpense(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      description: description.trim(),
      amount: amount,
      currency: currency,
      unitName: unitName.trim(),
      date: date.trim(),
      notes: notes?.trim(),
    );

    _maintenances.insert(0, expense);
    await _dbHelper.insertMaintenanceExpense(expense);

    notifyListeners();
    return null;
  }
}
