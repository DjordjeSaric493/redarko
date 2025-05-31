import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_m.dart';
import '../models/event_type_m.dart';
import '../models/event_m.dart';

class SupabaseService with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  User? _user;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _user = response.user;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(UserModel user, String password) async {
    try {
      final authResponse = await _client.auth.signUp(
        email: user.email,
        password: password,
        data: {'first_name': user.firstName, 'last_name': user.lastName},
        emailRedirectTo: 'app://redirect',
      );

      final uid = authResponse.user?.id;
      if (uid == null) throw Exception('User registration failed');

      await _client.from('users').insert({
        'uid': uid,
        ...user.toMap(), // Ostali podaci iz UserModel
      });

      // Automatska prijava nakon registracije
      _user = authResponse.user;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<UserModel?> getCurrentUserData() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return null;

    final response =
        await _client
            .from('users')
            .select()
            .eq('uid', uid) // Promenjeno iz 'id' u 'uid'
            .single();

    return UserModel.fromMap(response, uid);
  }

  //
}
