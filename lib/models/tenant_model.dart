class Tenant {
  final String id;
  final String name;
  final String phone;
  final String nationalId;
  final String unitName;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    this.nationalId = '',
    this.unitName = 'بدون وحدة سكنية حالياً',
  });

  Tenant copyWith({
    String? id,
    String? name,
    String? phone,
    String? nationalId,
    String? unitName,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      unitName: unitName ?? this.unitName,
    );
  }
}
