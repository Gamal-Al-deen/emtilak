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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenant_name': tenantName,
      'unit_name': unitName,
      'building_name': buildingName,
      'monthly_rent': monthlyRent,
      'currency': currency,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': status == 'نشط' ? 1 : 0,
      'status': status,
      'notes': notes,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      id: map['id']?.toString() ?? '',
      tenantName: map['tenant_name'] ?? '',
      unitName: map['unit_name'] ?? '',
      buildingName: map['building_name'] ?? '',
      monthlyRent: (map['monthly_rent'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? 'USD',
      startDate: map['start_date'] ?? '',
      endDate: map['end_date'] ?? '',
      status: map['status'] ?? (map['is_active'] == 1 ? 'نشط' : 'منتهي'),
      notes: map['notes'],
    );
  }
}
