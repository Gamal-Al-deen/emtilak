class Unit {
  final String id;
  final String buildingId;
  final String number;
  final String buildingName;
  final String status; // مؤجرة, فارغة, صيانة, قيد التجهيز, بعد الخروج
  final double monthlyRent;
  final String? currentTenant;

  Unit({
    required this.id,
    required this.buildingId,
    required this.number,
    required this.buildingName,
    required this.status,
    this.monthlyRent = 0.0,
    this.currentTenant,
  });

  Unit copyWith({
    String? id,
    String? buildingId,
    String? number,
    String? buildingName,
    String? status,
    double? monthlyRent,
    String? currentTenant,
  }) {
    return Unit(
      id: id ?? this.id,
      buildingId: buildingId ?? this.buildingId,
      number: number ?? this.number,
      buildingName: buildingName ?? this.buildingName,
      status: status ?? this.status,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      currentTenant: currentTenant ?? this.currentTenant,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'building_id': buildingId,
      'unit_number': number,
      'building_name': buildingName,
      'status': status,
      'monthly_rent': monthlyRent,
      'current_tenant': currentTenant,
    };
  }

  factory Unit.fromMap(Map<String, dynamic> map) {
    return Unit(
      id: map['id']?.toString() ?? '',
      buildingId: map['building_id']?.toString() ?? '',
      number: map['unit_number'] ?? map['number'] ?? '',
      buildingName: map['building_name'] ?? '',
      status: map['status'] ?? 'فارغة',
      monthlyRent: (map['monthly_rent'] as num?)?.toDouble() ?? 0.0,
      currentTenant: map['current_tenant'],
    );
  }
}
