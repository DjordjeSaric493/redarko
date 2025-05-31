import 'package:flutter/material.dart';
import '../models/user_m.dart';

class UserInfoCard extends StatelessWidget {
  final UserModel user;

  const UserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${user.firstName} ${user.lastName}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("Telefon: ${user.phoneNumber}"),
            const SizedBox(height: 8),
            Text("Rola: ${user.role}"),
            const SizedBox(height: 8),
            Text(
              user.shiftTime != null
                  ? "Smena: ${user.shiftTime!} (${user.day ?? 'nepoznat dan'})"
                  : "Nemaš zakazanu smenu.",
            ),
          ],
        ),
      ),
    );
  }
}
