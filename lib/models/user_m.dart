class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role; // npr. 'koordinator', 'vođa smene', 'redar'
  final String? day; // dan smene
  final String? shiftTime; // vreme smene (08:00-12:00)
  final String? locationDescription; // npr. "Ispred zgrade FON-a"
  final double? latitude;
  final double? longitude;
  final String? status; // 'safe', 'unsafe', 'red'

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.day,
    this.shiftTime,
    this.locationDescription,
    this.latitude,
    this.longitude,
    this.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      role: data['role'] ?? '',
      day: data['day'],
      shiftTime: data['shift_time'],
      locationDescription: data['location_description'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      status: data['status'],
    );
  }
  //pravim mapu sa dinamičkim vrednostima (lat i longitude su double npr pa se supabase drkao na mene)
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
    };

    if (day != null) map['day'] = day;
    if (shiftTime != null) map['shift_time'] = shiftTime;
    if (locationDescription != null)
      map['location_description'] = locationDescription;
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (status != null) map['status'] = status;

    return map;
  }

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? role,
    String? day,
    String? shiftTime,
    String? locationDescription,
    double? latitude,
    double? longitude,
    String? status,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      day: day ?? this.day,
      shiftTime: shiftTime ?? this.shiftTime,
      locationDescription: locationDescription ?? this.locationDescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
    );
  }

  String get name => '$firstName $lastName';
}
