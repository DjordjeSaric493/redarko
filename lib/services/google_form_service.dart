import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';

class GoogleFormService {
  final SupabaseClient _supabaseClient;
  final AppLinks _appLinks = AppLinks();

  GoogleFormService(this._supabaseClient);

  // Function to handle the deep link when app is opened
  Future<void> handleDeepLink(String link) async {
    try {
      if (link.startsWith('redarko://')) {
        final uri = Uri.parse(link);
        final shiftId = uri.queryParameters['shift_id'];
        final userId = uri.queryParameters['user_id'];
        final phoneNumber = uri.queryParameters['phone_number'];
        final email = uri.queryParameters['email'];

        if (shiftId != null && userId != null && email != null) {
          // Check if user exists
          final userResponse =
              await _supabaseClient
                  .from('users')
                  .select()
                  .eq('email', email)
                  .maybeSingle();

          if (userResponse == null) {
            // User doesn't exist, create temporary account
            final authResponse = await _supabaseClient.auth.signUp(
              email: email,
              password: userId, // Use the generated ID as temporary password
            );

            if (authResponse.user != null) {
              // Create user record
              await _supabaseClient.from('users').insert({
                'uid': authResponse.user!.id,
                'email': email,
                'phone_number': phoneNumber,
                'role': 'redar', // Default role
                'created_at': DateTime.now().toIso8601String(),
              });
            }
          }

          // Add to shift
          final shift =
              await _supabaseClient
                  .from('shifts')
                  .select('steward_ids')
                  .eq('id', shiftId)
                  .single();

          List<String> stewardIds = List<String>.from(
            shift['steward_ids'] ?? [],
          );
          stewardIds.add(userId);

          await _supabaseClient
              .from('shifts')
              .update({
                'steward_ids': stewardIds,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', shiftId);
        }
      }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
      rethrow;
    }
  }

  // Function to start listening for deep links
  void initDeepLinkListener(Function(String) onLinkReceived) {
    _appLinks.uriLinkStream.listen(
      (Uri uri) {
        onLinkReceived(uri.toString());
      },
      onError: (err) {
        debugPrint('Error receiving deep link: $err');
      },
    );
  }

  // Function to test deep linking
  Future<void> testDeepLink(String shiftId, String phoneNumber) async {
    final currentUser = _supabaseClient.auth.currentUser;
    if (currentUser != null) {
      final testLink =
          'redarko://signup?shift_id=$shiftId&user_id=${currentUser.id}&phone_number=$phoneNumber';
      if (await canLaunchUrl(Uri.parse(testLink))) {
        await launchUrl(Uri.parse(testLink));
      }
    }
  }
}
