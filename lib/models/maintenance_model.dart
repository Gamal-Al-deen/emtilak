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
}
