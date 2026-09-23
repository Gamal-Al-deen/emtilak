class MaintenanceExpense {
  final String id;
  final String description;
  final double amount;
  final String currency;
  final String unitName;
  final String date;
  final String? notes;

  MaintenanceExpense({
    required this.id,
    required this.description,
    required this.amount,
    this.currency = '\$',
    required this.unitName,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'currency': currency,
      'unit_name': unitName,
      'expense_date': date,
      'notes': notes,
    };
  }

  factory MaintenanceExpense.fromMap(Map<String, dynamic> map) {
    return MaintenanceExpense(
      id: map['id']?.toString() ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? '\$',
      unitName: map['unit_name'] ?? '',
      date: map['expense_date'] ?? map['date'] ?? '',
      notes: map['notes'],
    );
  }
}
