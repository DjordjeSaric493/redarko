import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_scr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _image1Controller;
  late AnimationController _image2Controller;
  late Animation<double> _image1Animation;
  late Animation<double> _image2Animation;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    _initAnimations();
    _checkAuthStatus();
  }

  void _initAnimations() {
    _image1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _image2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _image1Animation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(_image1Controller);
    _image2Animation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(_image2Controller);

    _image1Controller.forward();
    _image2Controller.forward();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Proverite da li postoji sesija
      final session = _supabase.auth.currentSession;

      // Dodajte malu pauzu za animaciju
      await Future.delayed(const Duration(seconds: 3));

      if (session != null && !session.isExpired) {
        // ✅ Korisnik je prijavljen i sesija nije istekla
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // ❌ Nema validne sesije
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      // U slučaju greške, prebaci na login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _image1Controller.dispose();
    _image2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'REDARKO',
                  textStyle: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: false,
              stopPauseOnTap: false,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _image1Animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _image1Animation.value,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'assets/itb.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                AnimatedBuilder(
                  animation: _image2Animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _image2Animation.value,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'assets/its.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
