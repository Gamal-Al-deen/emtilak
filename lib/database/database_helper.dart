import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_models.dart';
import 'initial_data_seeds.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('emtilak.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. AppSettings
    await db.execute('''
      CREATE TABLE AppSettings (
        id INTEGER PRIMARY KEY,
        owner_name TEXT NOT NULL,
        owner_signature TEXT DEFAULT NULL,
        default_currency_id INTEGER NOT NULL DEFAULT 1,
        backup_frequency TEXT DEFAULT 'monthly',
        last_backup_date TEXT DEFAULT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Currencies
    await db.execute('''
      CREATE TABLE Currencies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        symbol TEXT NOT NULL,
        is_base INTEGER NOT NULL DEFAULT 0,
        rate REAL NOT NULL DEFAULT 1.0
      )
    ''');

    // 3. ExchangeRates
    await db.execute('''
      CREATE TABLE ExchangeRates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        from_currency_id INTEGER NOT NULL,
        to_currency_id INTEGER NOT NULL,
        rate REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // 4. Buildings
    await db.execute('''
      CREATE TABLE Buildings (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT DEFAULT NULL,
        total_units INTEGER NOT NULL DEFAULT 0,
        notes TEXT DEFAULT NULL
      )
    ''');

    // 5. Floors
    await db.execute('''
      CREATE TABLE Floors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        building_id TEXT NOT NULL,
        floor_number INTEGER NOT NULL
      )
    ''');

    // 6. Units
    await db.execute('''
      CREATE TABLE Units (
        id TEXT PRIMARY KEY,
        floor_id INTEGER DEFAULT NULL,
        building_id TEXT NOT NULL,
        unit_number TEXT NOT NULL,
        building_name TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'فارغة',
        monthly_rent REAL DEFAULT 0.0,
        current_tenant TEXT DEFAULT NULL,
        notes TEXT DEFAULT NULL
      )
    ''');

    // 7. Tenants
    await db.execute('''
      CREATE TABLE Tenants (
        id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        phone TEXT DEFAULT NULL,
        id_document TEXT DEFAULT NULL,
        unit_name TEXT DEFAULT NULL,
        notes TEXT DEFAULT NULL
      )
    ''');

    // 8. Contracts
    await db.execute('''
      CREATE TABLE Contracts (
        id TEXT PRIMARY KEY,
        tenant_id INTEGER DEFAULT NULL,
        tenant_name TEXT NOT NULL,
        unit_id INTEGER DEFAULT NULL,
        unit_name TEXT NOT NULL,
        building_name TEXT NOT NULL,
        monthly_rent REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT 'USD',
        currency_id INTEGER DEFAULT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        status TEXT NOT NULL DEFAULT 'نشط',
        notes TEXT DEFAULT NULL
      )
    ''');

    // 9. RentTransactions
    await db.execute('''
      CREATE TABLE RentTransactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contract_id TEXT NOT NULL,
        month TEXT NOT NULL,
        amount_due REAL NOT NULL,
        equivalent_base_due REAL DEFAULT 0,
        is_added_automatically INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        notes TEXT DEFAULT NULL
      )
    ''');

    // 10. Payments
    await db.execute('''
      CREATE TABLE Payments (
        id TEXT PRIMARY KEY,
        contract_id TEXT DEFAULT NULL,
        tenant_name TEXT NOT NULL,
        contract_info TEXT NOT NULL,
        amount_paid REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT '\$',
        currency_id INTEGER DEFAULT NULL,
        exchange_rate_id INTEGER DEFAULT NULL,
        equivalent_base_amount REAL DEFAULT 0,
        payment_date TEXT NOT NULL,
        status TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        receipt_number TEXT DEFAULT NULL,
        notes TEXT DEFAULT NULL
      )
    ''');

    // 11. MaintenanceExpenses
    await db.execute('''
      CREATE TABLE MaintenanceExpenses (
        id TEXT PRIMARY KEY,
        unit_id TEXT DEFAULT NULL,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT '\$',
        unit_name TEXT NOT NULL,
        expense_date TEXT NOT NULL,
        notes TEXT DEFAULT NULL
      )
    ''');

    // Seed Initial Data
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    for (var b in initialSeedBuildings) {
      await db.insert('Buildings', b.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var u in initialSeedUnits) {
      await db.insert('Units', u.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var t in initialSeedTenants) {
      await db.insert('Tenants', t.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var c in initialSeedContracts) {
      await db.insert('Contracts', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var p in initialSeedPayments) {
      await db.insert('Payments', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var m in initialSeedMaintenances) {
      await db.insert('MaintenanceExpenses', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    for (var cur in initialSeedCurrencies) {
      await db.insert('Currencies', cur.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // ==================== BUILDINGS CRUD ====================
  Future<List<Building>> getAllBuildings() async {
    final db = await instance.database;
    final maps = await db.query('Buildings');
    return maps.map((map) => Building.fromMap(map)).toList();
  }

  Future<int> insertBuilding(Building building) async {
    final db = await instance.database;
    return await db.insert('Buildings', building.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateBuilding(Building building) async {
    final db = await instance.database;
    return await db.update(
      'Buildings',
      building.toMap(),
      where: 'id = ?',
      whereArgs: [building.id],
    );
  }

  Future<int> deleteBuilding(String id) async {
    final db = await instance.database;
    return await db.delete(
      'Buildings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== UNITS CRUD ====================
  Future<List<Unit>> getAllUnits() async {
    final db = await instance.database;
    final maps = await db.query('Units');
    return maps.map((map) => Unit.fromMap(map)).toList();
  }

  Future<int> insertUnit(Unit unit) async {
    final db = await instance.database;
    return await db.insert('Units', unit.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateUnit(Unit unit) async {
    final db = await instance.database;
    return await db.update(
      'Units',
      unit.toMap(),
      where: 'id = ?',
      whereArgs: [unit.id],
    );
  }

  // ==================== TENANTS CRUD ====================
  Future<List<Tenant>> getAllTenants() async {
    final db = await instance.database;
    final maps = await db.query('Tenants');
    return maps.map((map) => Tenant.fromMap(map)).toList();
  }

  Future<int> insertTenant(Tenant tenant) async {
    final db = await instance.database;
    return await db.insert('Tenants', tenant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTenant(Tenant tenant) async {
    final db = await instance.database;
    return await db.update(
      'Tenants',
      tenant.toMap(),
      where: 'id = ?',
      whereArgs: [tenant.id],
    );
  }

  // ==================== CONTRACTS CRUD ====================
  Future<List<Contract>> getAllContracts() async {
    final db = await instance.database;
    final maps = await db.query('Contracts');
    return maps.map((map) => Contract.fromMap(map)).toList();
  }

  Future<int> insertContract(Contract contract) async {
    final db = await instance.database;
    return await db.insert('Contracts', contract.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateContract(Contract contract) async {
    final db = await instance.database;
    return await db.update(
      'Contracts',
      contract.toMap(),
      where: 'id = ?',
      whereArgs: [contract.id],
    );
  }

  // ==================== PAYMENTS CRUD ====================
  Future<List<Payment>> getAllPayments() async {
    final db = await instance.database;
    final maps = await db.query('Payments');
    return maps.map((map) => Payment.fromMap(map)).toList();
  }

  Future<int> insertPayment(Payment payment) async {
    final db = await instance.database;
    return await db.insert('Payments', payment.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ==================== MAINTENANCE CRUD ====================
  Future<List<MaintenanceExpense>> getAllMaintenanceExpenses() async {
    final db = await instance.database;
    final maps = await db.query('MaintenanceExpenses');
    return maps.map((map) => MaintenanceExpense.fromMap(map)).toList();
  }

  Future<int> insertMaintenanceExpense(MaintenanceExpense expense) async {
    final db = await instance.database;
    return await db.insert('MaintenanceExpenses', expense.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ==================== CURRENCIES CRUD ====================
  Future<List<CurrencyModel>> getAllCurrencies() async {
    final db = await instance.database;
    final maps = await db.query('Currencies');
    return maps.map((map) => CurrencyModel.fromMap(map)).toList();
  }

  Future<int> insertCurrency(CurrencyModel currency) async {
    final db = await instance.database;
    return await db.insert('Currencies', currency.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateCurrency(CurrencyModel currency) async {
    final db = await instance.database;
    return await db.update(
      'Currencies',
      currency.toMap(),
      where: 'code = ?',
      whereArgs: [currency.code],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
