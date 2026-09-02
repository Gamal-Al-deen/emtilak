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
}
