import 'package:flutter/foundation.dart';
import '../models/currency_model.dart';
import '../database/database_helper.dart';

class CurrencyController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<CurrencyModel> _currencies = [];

  List<CurrencyModel> get currencies => List.unmodifiable(_currencies);

  Future<void> loadCurrencies() async {
    final list = await _dbHelper.getAllCurrencies();
    _currencies.clear();
    _currencies.addAll(list);
    notifyListeners();
  }

  /// Adds a currency with validation
  Future<String?> addCurrency({
    required String code,
    required String name,
    required String symbol,
    required double rate,
  }) async {
    // Validation
    if (code.trim().isEmpty) {
      return 'رمز العملة مطلوب (مثل USD, YER).';
    }
    if (name.trim().isEmpty) {
      return 'اسم العملة مطلوب.';
    }
    if (symbol.trim().isEmpty) {
      return 'رمز/علامة العملة مطلوبة.';
    }
    if (rate <= 0) {
      return 'سعر الصرف يجب أن يكون أكبر من 0.';
    }

    final currency = CurrencyModel(
      code: code.trim().toUpperCase(),
      name: name.trim(),
      symbol: symbol.trim(),
      isBase: false,
      rate: rate,
    );

    _currencies.add(currency);
    await _dbHelper.insertCurrency(currency);
    notifyListeners();
    return null;
  }

  Future<void> setBaseCurrency(String code) async {
    for (int i = 0; i < _currencies.length; i++) {
      final isCurrent = _currencies[i].code == code;
      _currencies[i] = _currencies[i].copyWith(isBase: isCurrent);
      await _dbHelper.updateCurrency(_currencies[i]);
    }
    notifyListeners();
  }

  Future<void> updateCurrencyRate(String code, double newRate) async {
    final index = _currencies.indexWhere((c) => c.code == code);
    if (index != -1) {
      _currencies[index] = _currencies[index].copyWith(rate: newRate);
      await _dbHelper.updateCurrency(_currencies[index]);
      notifyListeners();
    }
  }
}
