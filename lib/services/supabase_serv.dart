import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_m.dart';
import '../models/event_type_m.dart';
import '../models/event_m.dart';
import '../models/shift_m.dart';
import '../models/group_m.dart';

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

  // Shift-related methods
  Future<List<ShiftModel>> getShifts() async {
    try {
      final response = await _client
          .from('shifts')
          .select()
          .order('created_at', ascending: false);

      return response
          .map((data) => ShiftModel.fromMap(data, data['id']))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createShift(ShiftModel shift) async {
    try {
      // Validate number of coordinators
      if (shift.coordinatorIds.length > 2) {
        throw Exception('Smena može imati maksimalno 2 koordinatora');
      }
      await _client.from('shifts').insert(shift.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateShift(
    String shiftId, {
    String? day,
    String? time,
    String? location,
    List<String>? coordinatorIds,
    String? groupId,
  }) async {
    try {
      // Validate number of coordinators if being updated
      if (coordinatorIds != null && coordinatorIds.length > 2) {
        throw Exception('Smena može imati maksimalno 2 koordinatora');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (day != null) updates['day'] = day;
      if (time != null) updates['time'] = time;
      if (location != null) updates['location'] = location;
      if (coordinatorIds != null) updates['coordinator_ids'] = coordinatorIds;
      if (groupId != null) updates['group_id'] = groupId;

      await _client.from('shifts').update(updates).eq('id', shiftId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteShift(String shiftId) async {
    try {
      await _client.from('shifts').delete().eq('id', shiftId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignCoordinatorToShift(
    String shiftId,
    String coordinatorId,
  ) async {
    try {
      final shift =
          await _client
              .from('shifts')
              .select('coordinator_ids')
              .eq('id', shiftId)
              .single();

      List<String> coordinatorIds = List<String>.from(
        shift['coordinator_ids'] ?? [],
      );

      // Check if already has 2 coordinators
      if (coordinatorIds.length >= 2) {
        throw Exception('Smena već ima 2 koordinatora');
      }

      if (!coordinatorIds.contains(coordinatorId)) {
        coordinatorIds.add(coordinatorId);
        await _client
            .from('shifts')
            .update({
              'coordinator_ids': coordinatorIds,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', shiftId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeCoordinatorFromShift(
    String shiftId,
    String coordinatorId,
  ) async {
    try {
      final shift =
          await _client
              .from('shifts')
              .select('coordinator_ids')
              .eq('id', shiftId)
              .single();

      List<String> coordinatorIds = List<String>.from(
        shift['coordinator_ids'] ?? [],
      );
      coordinatorIds.remove(coordinatorId);

      await _client
          .from('shifts')
          .update({
            'coordinator_ids': coordinatorIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', shiftId);
    } catch (e) {
      rethrow;
    }
  }

  // Group-related methods
  Future<List<GroupModel>> getGroups() async {
    try {
      final response = await _client
          .from('groups')
          .select()
          .order('created_at', ascending: false);

      return response
          .map((data) => GroupModel.fromMap(data, data['id']))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createGroup(GroupModel group) async {
    try {
      // Check if coordinator is already assigned to another group
      final existingGroup =
          await _client
              .from('groups')
              .select()
              .eq('coordinator_id', group.coordinatorId)
              .maybeSingle();

      if (existingGroup != null) {
        throw Exception('Ovaj koordinator je već dodeljen drugoj grupi');
      }

      await _client.from('groups').insert(group.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGroup(
    String groupId, {
    String? name,
    String? description,
    String? coordinatorId,
  }) async {
    try {
      // If changing coordinator, check if new coordinator is already assigned
      if (coordinatorId != null) {
        final existingGroup =
            await _client
                .from('groups')
                .select()
                .eq('coordinator_id', coordinatorId)
                .neq('id', groupId) // Exclude current group
                .maybeSingle();

        if (existingGroup != null) {
          throw Exception('Ovaj koordinator je već dodeljen drugoj grupi');
        }
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updates['name'] = name;
      if (description != null) updates['description'] = description;
      if (coordinatorId != null) updates['coordinator_id'] = coordinatorId;

      await _client.from('groups').update(updates).eq('id', groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _client.from('groups').delete().eq('id', groupId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMemberToGroup(String groupId, String memberId) async {
    try {
      final group =
          await _client
              .from('groups')
              .select('member_ids')
              .eq('id', groupId)
              .single();

      List<String> memberIds = List<String>.from(group['member_ids'] ?? []);
      if (!memberIds.contains(memberId)) {
        memberIds.add(memberId);
        await _client
            .from('groups')
            .update({
              'member_ids': memberIds,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', groupId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeMemberFromGroup(String groupId, String memberId) async {
    try {
      final group =
          await _client
              .from('groups')
              .select('member_ids')
              .eq('id', groupId)
              .single();

      List<String> memberIds = List<String>.from(group['member_ids'] ?? []);
      memberIds.remove(memberId);

      await _client
          .from('groups')
          .update({
            'member_ids': memberIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', groupId);
    } catch (e) {
      rethrow;
    }
  }

  // Steward-related methods
  Future<void> assignStewardToShift(String shiftId, String stewardId) async {
    try {
      final shift =
          await _client
              .from('shifts')
              .select('steward_ids')
              .eq('id', shiftId)
              .single();

      List<String> stewardIds = List<String>.from(shift['steward_ids'] ?? []);
      if (!stewardIds.contains(stewardId)) {
        stewardIds.add(stewardId);
        await _client
            .from('shifts')
            .update({
              'steward_ids': stewardIds,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', shiftId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeStewardFromShift(String shiftId, String stewardId) async {
    try {
      final shift =
          await _client
              .from('shifts')
              .select('steward_ids')
              .eq('id', shiftId)
              .single();

      List<String> stewardIds = List<String>.from(shift['steward_ids'] ?? []);
      stewardIds.remove(stewardId);

      await _client
          .from('shifts')
          .update({
            'steward_ids': stewardIds,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', shiftId);
    } catch (e) {
      rethrow;
    }
  }

  // Handle Google Form signup
  Future<void> handleFormSignup(String shiftId, String userId) async {
    try {
      // First, get the user's role
      final userData =
          await _client.from('users').select('role').eq('id', userId).single();

      final role = userData['role'] as String;

      // Add user to the shift based on their role
      if (role == 'koordinator') {
        await assignCoordinatorToShift(shiftId, userId);
      } else if (role == 'redar') {
        await assignStewardToShift(shiftId, userId);
      } else {
        throw Exception('Invalid user role');
      }

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
