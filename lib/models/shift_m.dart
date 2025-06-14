class ShiftModel {
  final String id;
  final String day;
  final String time;
  final String location;
  final List<String> coordinatorIds;
  final List<String> stewardIds;
  final String groupId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ShiftModel({
    required this.id,
    required this.day,
    required this.time,
    required this.location,
    required this.coordinatorIds,
    required this.stewardIds,
    required this.groupId,
    required this.createdAt,
    this.updatedAt,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> data, String id) {
    return ShiftModel(
      id: id,
      day: data['day'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      coordinatorIds: List<String>.from(data['coordinator_ids'] ?? []),
      stewardIds: List<String>.from(data['steward_ids'] ?? []),
      groupId: data['group_id'] ?? '',
      createdAt: DateTime.parse(data['created_at']),
      updatedAt:
          data['updated_at'] != null
              ? DateTime.parse(data['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
      'location': location,
      'coordinator_ids': coordinatorIds,
      'steward_ids': stewardIds,
      'group_id': groupId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ShiftModel copyWith({
    String? id,
    String? day,
    String? time,
    String? location,
    List<String>? coordinatorIds,
    List<String>? stewardIds,
    String? groupId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShiftModel(
      id: id ?? this.id,
      day: day ?? this.day,
      time: time ?? this.time,
      location: location ?? this.location,
      coordinatorIds: coordinatorIds ?? this.coordinatorIds,
      stewardIds: stewardIds ?? this.stewardIds,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
