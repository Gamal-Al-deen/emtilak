import 'package:flutter/foundation.dart';
import '../models/payment_model.dart';
import '../database/database_helper.dart';

class PaymentController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final List<Payment> _payments = [];

  List<Payment> get payments => List.unmodifiable(_payments);

  double get totalIncomeCollected => _payments
      .where((p) => p.status == 'مدفوع')
      .fold(0.0, (sum, item) => sum + item.amount);

  Future<void> loadPayments() async {
    final list = await _dbHelper.getAllPayments();
    _payments.clear();
    _payments.addAll(list);
    notifyListeners();
  }

  List<Payment> getPaymentsForContract(String contractId) {
    return _payments.where((p) => p.contractId == contractId).toList();
  }

  /// Adds a payment record with validation
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
    // Validation
    if (tenantName.trim().isEmpty) {
      return 'اسم المستأجر مطلوب.';
    }
    if (contractInfo.trim().isEmpty) {
      return 'معلومات العقد/الوحدة مطلوبة.';
    }
    if (amount <= 0) {
      return 'مبلغ الدفعة يجب أن يكون أكبر من 0.';
    }
    if (paymentDate.trim().isEmpty) {
      return 'تاريخ الدفعة مطلوب.';
    }

    final payment = Payment(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      contractId: contractId,
      tenantName: tenantName.trim(),
      contractInfo: contractInfo.trim(),
      amount: amount,
      currency: currency,
      paymentDate: paymentDate.trim(),
      status: status,
      method: method,
      notes: notes?.trim(),
    );

    _payments.insert(0, payment);
    await _dbHelper.insertPayment(payment);
    notifyListeners();
    return null;
  }
}
