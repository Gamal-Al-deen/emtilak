class Payment {
  final String id;
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
}
