class Tenant {
  final String id;
  final String name;
  final String phone;
  final String nationalId;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    this.nationalId = '',
  });

  Tenant copyWith({
    String? id,
    String? name,
    String? phone,
    String? nationalId,
  }) {
    return Tenant(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': name,
      'phone': phone,
      'id_document': nationalId,
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      id: map['id']?.toString() ?? '',
      name: map['full_name'] ?? map['name'] ?? '',
      phone: map['phone'] ?? '',
      nationalId: map['id_document'] ?? map['national_id'] ?? '',
    );
  }
}
