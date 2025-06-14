class GroupModel {
  final String id;
  final String name;
  final String description;
  final String coordinatorId; // Single coordinator per group
  final List<String> memberIds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinatorId,
    required this.memberIds,
    required this.createdAt,
    this.updatedAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> data, String id) {
    return GroupModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      coordinatorId: data['coordinator_id'] ?? '',
      memberIds: List<String>.from(data['member_ids'] ?? []),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt:
          data['updated_at'] != null
              ? DateTime.parse(data['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'coordinator_id': coordinatorId,
      'member_ids': memberIds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? coordinatorId,
    List<String>? memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coordinatorId: coordinatorId ?? this.coordinatorId,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
