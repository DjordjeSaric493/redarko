import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/google_form_service.dart';
import '../services/supabase_serv.dart';

class ShiftDetailsScreen extends StatelessWidget {
  final String shiftId;

  const ShiftDetailsScreen({Key? key, required this.shiftId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shift Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final googleFormService = context.read<GoogleFormService>();
                final supabaseService = context.read<SupabaseService>();
                final userData = await supabaseService.getCurrentUserData();
                if (userData != null) {
                  googleFormService.testDeepLink(shiftId, userData.phoneNumber);
                }
              },
              child: const Text('Test Deep Link'),
            ),
          ],
        ),
      ),
    );
  }
}
