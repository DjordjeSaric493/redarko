class EventTypeModel {
  final int id;
  final String name;
  final String? description;
  final String? color; // Hex kod ili ime boje (opciono)
  final String? icon; // Možeš kasnije dodati podršku za ikonicu

  EventTypeModel({
    required this.id,
    required this.name,
    this.description,
    this.color,
    this.icon,
  });

  factory EventTypeModel.fromMap(Map<String, dynamic> map) {
    return EventTypeModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      color: map['color'],
      icon: map['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
    };
  }
}
