class Region {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final String icon;
  final String color;
  final bool isActive;
  final int sortOrder;

  Region({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.sortOrder,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? '',
      name: Map<String, String>.from(json['name'] ?? {}),
      description: Map<String, String>.from(json['description'] ?? {}),
      icon: json['icon'] ?? 'place',
      color: json['color'] ?? '#2196F3',
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'isActive': isActive,
      'sortOrder': sortOrder,
    };
  }
}