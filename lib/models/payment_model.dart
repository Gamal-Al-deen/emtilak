class Payment {
  final String id;
  final String? contractId;
  final String tenantName;
  final String contractInfo;
  final double amount;
  final String currency;
  final String paymentDate;
  final String status; // مدفوع, متأخر, جزئي
  final String method; // نقداً (Cash), تحويل بنكي, شيك
  final String? notes;

  Payment({
    required this.id,
    this.contractId,
    required this.tenantName,
    required this.contractInfo,
    required this.amount,
    this.currency = '\$',
    required this.paymentDate,
    required this.status,
    required this.method,
    this.notes,
  });

  Payment copyWith({
    String? id,
    String? contractId,
    String? tenantName,
    String? contractInfo,
    double? amount,
    String? currency,
    String? paymentDate,
    String? status,
    String? method,
    String? notes,
  }) {
    return Payment(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      tenantName: tenantName ?? this.tenantName,
      contractInfo: contractInfo ?? this.contractInfo,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentDate: paymentDate ?? this.paymentDate,
      status: status ?? this.status,
      method: method ?? this.method,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contract_id': contractId,
      'tenant_name': tenantName,
      'contract_info': contractInfo,
      'amount_paid': amount,
      'currency': currency,
      'payment_date': paymentDate,
      'status': status,
      'payment_method': method,
      'notes': notes,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id']?.toString() ?? '',
      contractId: map['contract_id']?.toString(),
      tenantName: map['tenant_name'] ?? '',
      contractInfo: map['contract_info'] ?? '',
      amount: (map['amount_paid'] ?? map['amount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? '\$',
      paymentDate: map['payment_date'] ?? '',
      status: map['status'] ?? 'مدفوع',
      method: map['payment_method'] ?? map['method'] ?? 'نقداً',
      notes: map['notes'],
    );
  }
}
