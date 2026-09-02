class Contract {
  final String id;
  final String tenantName;
  final String unitName;
  final String buildingName;
  final double monthlyRent;
  final String currency;
  final String startDate;
  final String endDate;
  final String status; // نشط, منتهي
  final String? notes;

  Contract({
    required this.id,
    required this.tenantName,
    required this.unitName,
    required this.buildingName,
    required this.monthlyRent,
    this.currency = 'USD',
    required this.startDate,
    required this.endDate,
    this.status = 'نشط',
    this.notes,
  });

  Contract copyWith({
    String? id,
    String? tenantName,
    String? unitName,
    String? buildingName,
    double? monthlyRent,
    String? currency,
    String? startDate,
    String? endDate,
    String? status,
    String? notes,
  }) {
    return Contract(
      id: id ?? this.id,
      tenantName: tenantName ?? this.tenantName,
      unitName: unitName ?? this.unitName,
      buildingName: buildingName ?? this.buildingName,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
