import 'package:flutter/foundation.dart';
import '../models/tenant_model.dart';
import '../database/database_helper.dart';

class TenantController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<Tenant> _tenants = [];

  List<Tenant> get tenants => List.unmodifiable(_tenants);

  Future<void> loadTenants() async {
    final list = await _dbHelper.getAllTenants();
    _tenants.clear();
    _tenants.addAll(list);
    notifyListeners();
  }

  /// Adds a tenant with validation
  Future<String?> addTenant({
    required String name,
    required String phone,
    String nationalId = '',
  }) async {
    // Validation
    if (name.trim().isEmpty) {
      return 'اسم المستأجر الكامل مطلوب.';
    }
    if (phone.trim().isEmpty) {
      return 'رقم الهاتف مطلوب للاتصال والتواصل.';
    }

    final tenant = Tenant(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      phone: phone.trim(),
      nationalId: nationalId.trim(),
    );

    _tenants.add(tenant);
    await _dbHelper.insertTenant(tenant);
    notifyListeners();
    return null;
  }

  Future<void> updateTenant(Tenant tenant) async {
    final index = _tenants.indexWhere((t) => t.id == tenant.id);
    if (index != -1) {
      _tenants[index] = tenant;
      await _dbHelper.updateTenant(tenant);
      notifyListeners();
    }
  }
}
