class ShiftModel {
  final String id;
  final String shiftTime; // npr. "08:00-12:00"
  final String coordinatorId; // referenca na UserModel.uid
  final String locationDescription;
  final double? latitude;
  final double? longitude;
  final String day; // datum ili dan npr. "2025-05-29"

  ShiftModel({
    required this.id,
    required this.shiftTime,
    required this.coordinatorId,
    required this.locationDescription,
    this.latitude,
    this.longitude,
    required this.day,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> data, String id) {
    return ShiftModel(
      id: id,
      shiftTime: data['shift_time'],
      coordinatorId: data['coordinator_id'],
      locationDescription: data['location_description'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      day: data['day'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shift_time': shiftTime,
      'coordinator_id': coordinatorId,
      'location_description': locationDescription,
      'latitude': latitude,
      'longitude': longitude,
      'day': day,
    };
  }
}
