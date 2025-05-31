//drawer klASSIka
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redarko/blocs/auth_bl/auth_bl.dart';
import 'package:redarko/blocs/auth_bl/auth_event.dart';
import 'package:redarko/blocs/auth_bl/auth_state.dart';

import '../models/user_m.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            final UserModel user =
                state
                    .user; //The getter 'user' isn't defined for the type 'AuthSuccess'.

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('${user.firstName} ${user.lastName}'),
                  accountEmail: Text(user.email),
                  currentAccountPicture: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Odjava"),
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text("Učitavanje..."));
          }
        },
      ),
    );
  }
}
