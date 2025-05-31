import 'package:redarko/models/event_type_m.dart';

class EventModel {
  final int id;
  final int eventTypeId;
  final String location;
  final DateTime date;
  final DateTime time;
  final int durationMinutes;
  final List<String> sectors;
  final EventTypeModel?
  eventType; // opcionalno: puni se kada se učita iz Supabase-a sa JOIN-om

  EventModel({
    required this.id,
    required this.eventTypeId,
    required this.location,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.sectors,
    this.eventType,
  });

  /// Kad učitavamo iz Supabase-a sa JOIN-om: `select=*,event_type(*)`
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      eventTypeId: map['event_type_id'],
      location: map['location'],
      date: DateTime.parse(map['date']),
      time: DateTime.parse(map['time']),
      durationMinutes: map['duration_minutes'],
      sectors: List<String>.from(map['sectors'] ?? []),
      eventType:
          map['event_type'] != null
              ? EventTypeModel.fromMap(map['event_type'])
              : null,
    );
  }

  /// Kad šaljemo u Supabase – šaljemo samo ID!
  Map<String, dynamic> toMap() {
    return {
      'event_type_id': eventTypeId,
      'location': location,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'duration_minutes': durationMinutes,
      'sectors': sectors,
    };
  }

  EventModel copyWith({
    int? id,
    int? eventTypeId,
    String? location,
    DateTime? date,
    DateTime? time,
    int? durationMinutes,
    List<String>? sectors,
    EventTypeModel? eventType,
  }) {
    return EventModel(
      id: id ?? this.id,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sectors: sectors ?? this.sectors,
      eventType: eventType ?? this.eventType,
    );
  }
}
