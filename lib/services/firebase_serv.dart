import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_m.dart';

class FirebaseService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;

  // Prijava korisnika pomoću emaila i lozinke
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      rethrow; // Ako dođe do greške, ponovo je bacamo
    }
  }

  // Registracija novog korisnika
  Future<void> register(UserModel user, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: password,
          );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        final newUser = user.copyWith(uid: uid);
        await _firestore.collection('users').doc(uid).set(newUser.toMap());
      }

      _user = userCredential.user;
      await _auth.signOut(); // obavezno!
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //samo ime kae
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // vatanje svih korisnika koji rade u određenom danu i smeni
  Future<List<UserModel>> getUsersForShift(String day, String shift) async {
    final snapshot =
        await _firestore
            .collection('users')
            .where('day', isEqualTo: day)
            .where('shift_time', isEqualTo: shift)
            .get(); //get najobičniji

    return snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  //jurim vremena smene FirebaseException ([cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.)
  Future<List<String>> getAllShiftTimes() async {
    final snapshot = await _firestore.collection('shifts').get();

    return snapshot.docs.map((doc) => doc['shift_time'].toString()).toList();
  }

  //sve smene i vremena za korisnika
  Future<List<UserModel>> getShiftsForUser(String email) async {
    final snapshot =
        await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
