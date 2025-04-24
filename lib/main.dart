import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:redarko/screens/home_scr.dart';
import 'package:redarko/screens/login_scr.dart';
import 'package:redarko/screens/register_scr.dart';

import 'package:redarko/screens/splash_scr.dart';
import 'package:redarko/screens/shiftsel_scr.dart'; // Pretpostavljam da je ovo home

import 'package:redarko/utils/provider/shift_provider.dart';
import 'package:redarko/services/firebase_serv.dart';
import 'firebase_options.dart'; // generiše se automatski

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShiftProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseService()),
      ],
      child: const MyApp(),
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
        '/home': (context) => HomeScreen(), // Pretpostavljeno kao home
      },
    );
  }
}
