class Building {
  final String id;
  final String name;
  final String location;
  final int totalUnits;

  Building({
    required this.id,
    required this.name,
    required this.location,
    required this.totalUnits,
  });

  Building copyWith({
    String? id,
    String? name,
    String? location,
    int? totalUnits,
  }) {
    return Building(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      totalUnits: totalUnits ?? this.totalUnits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': location,
      'total_units': totalUnits,
      'notes': totalUnits.toString(),
    };
  }

  factory Building.fromMap(Map<String, dynamic> map) {
    return Building(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      location: map['address'] ?? map['location'] ?? '',
      totalUnits: map['total_units'] is int
          ? map['total_units'] as int
          : int.tryParse(map['total_units']?.toString() ?? map['notes']?.toString() ?? '') ?? 0,
    );
  }
}
