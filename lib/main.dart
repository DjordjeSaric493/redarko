import 'package:flutter/material.dart';

import 'package:redarko/screens/login_scr.dart';
import 'package:redarko/screens/main_screen.dart';
import 'package:redarko/screens/register_scr.dart';
import 'package:redarko/screens/splash_scr.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:redarko/services/supabase_serv.dart';

import 'package:redarko/utils/config.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redarko/blocs/auth_bl/auth_bl.dart';
import 'package:redarko/blocs/auth_bl/auth_event.dart';
import 'package:redarko/blocs/auth_bl/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iz config klase da se ne vidi jer je u gitignore drko se sa .env bez potrebe

  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseAnonKey,
  );

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc(SupabaseService()))],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redarko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
