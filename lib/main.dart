import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'services/supabase_serv.dart';
import 'services/google_form_service.dart';

import 'package:redarko/screens/login_scr.dart';
import 'package:redarko/screens/main_screen.dart';
import 'package:redarko/screens/register_scr.dart';
import 'package:redarko/screens/splash_scr.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redarko/blocs/auth_bl/auth_bl.dart';
import 'package:redarko/blocs/auth_bl/auth_event.dart';
import 'package:redarko/blocs/auth_bl/auth_state.dart';
import 'package:redarko/blocs/shift_bl/shift_bloc.dart';
import 'package:redarko/blocs/group_bl/group_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final supabaseClient = Supabase.instance.client;
  final googleFormService = GoogleFormService(supabaseClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SupabaseService()),
        Provider.value(value: googleFormService),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final googleFormService = context.read<GoogleFormService>();
    googleFormService.initDeepLinkListener((String link) {
      googleFormService.handleDeepLink(link);
    });
  }

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
