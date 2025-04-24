//klasa korisnik
//id,ime,prezime,telefon,rola,dan,smena,lokacija,status

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email; // Dodato
  final String phoneNumber;
  final String role;
  final String? day;
  final String? shiftTime;
  final GeoPoint? location;
  final String? status;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email, // Dodato
    required this.phoneNumber,
    required this.role,
    this.day,
    this.shiftTime,
    this.status,
    this.location,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'], // Dodato
      phoneNumber: data['phone_number'],
      role: data['role'],
      day: data['day'],
      shiftTime: data['shift_time'],
      status: data['status'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email, // Dodato
      'phone_number': phoneNumber,
      'role': role,
      'day': day,
      'shift_time': shiftTime,
      'status': status,
      'location': location,
    };
  }

  // (Opcionalno) copyWith ako ti bude trebalo
  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? role,
    String? day,
    String? shiftTime,
    GeoPoint? location,
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
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }

  String get name => '$firstName $lastName';
}
