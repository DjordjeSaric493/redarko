import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveShift({
    required String userId,
    required DateTime date,
    required String shift,
  }) async {
    final docRef = _firestore.collection('shifts').doc();

    await docRef.set({
      'userId': userId,
      'date': date.toIso8601String(),
      'shift': shift,
      'timestamp': FieldValue.serverTimestamp(),
    });

    notifyListeners();
  }
}
