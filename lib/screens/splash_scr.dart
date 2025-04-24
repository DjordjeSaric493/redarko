import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart'; // Dodaj ovu liniju
import 'login_scr.dart'; // Pretpostavljam da ćeš ovo dodati kasnije

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Dodaj kontrolere za animacije slika
  late AnimationController _image1Controller;
  late AnimationController _image2Controller;
  late Animation<double> _image1Animation;
  late Animation<double> _image2Animation;

  @override
  void initState() {
    super.initState();

    // Inicijalizacija kontrolera za animacije slika
    _image1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Podesi trajanje animacije
    )..repeat(reverse: true); // Ponovi animaciju unazad i napred

    _image2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Definiši animacije (npr., promena opacity-a)
    _image1Animation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(_image1Controller); // Postavi opseg
    _image2Animation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(_image2Controller);

    // Pokreni animacije
    _image1Controller.forward();
    _image2Controller.forward();

    Timer(const Duration(seconds: 5), () {
      // Povećao sam trajanje splash ekrana na 5 sekundi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Obavezno dispose kontrolere animacija
    _image1Controller.dispose();
    _image2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Postavi pozadinu na belu
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'REDARKO', // Promenio sam tekst u REDARKO
                  textStyle: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Postavi boju teksta
                  ),
                  speed: const Duration(
                    milliseconds: 200,
                  ), // Podesi brzinu pisanja
                ),
              ],
              totalRepeatCount: 1, // Samo jednom se izvršava animacija
              pause: const Duration(
                milliseconds: 1000,
              ), // Pauza nakon animacije
              displayFullTextOnTap: false,
              stopPauseOnTap: false,
            ),
            const SizedBox(
              height: 20,
            ), // Dodaj malo prostora između teksta i slika
            // Koristi Row za prikazivanje slika jedna pored druge
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centriraj slike horizontalno
              children: [
                // Prva animirana slika
                AnimatedBuilder(
                  animation: _image1Animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _image1Animation.value,
                      child: SizedBox(
                        width: 150, // Podesi širinu slike
                        height: 150, // Podesi visinu slike
                        child: Image.asset(
                          'assets/itb.jpg', // Putanja do prve slike
                          fit:
                              BoxFit
                                  .contain, // Prilagodi sliku unutar kontejnera
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20), // Dodaj razmak između slika
                // Druga animirana slika
                AnimatedBuilder(
                  animation: _image2Animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _image2Animation.value,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'assets/its.jpg', // Putanja do druge slike
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
