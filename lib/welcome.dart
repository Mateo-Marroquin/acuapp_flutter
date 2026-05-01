import 'package:acuapp/navigator_app.dart';
import 'package:flutter/material.dart';
import 'package:acuapp/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/welcome_fish.png',
                  height: 250,
                  fit: BoxFit.contain,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'ACUAAPP',
                    style: GoogleFonts.montserrat(
                      fontSize: 55.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 6.0,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Descubre ',
                        style: GoogleFonts.montserrat(
                          fontSize: 26.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: DefaultTextStyle(
                          style: GoogleFonts.montserrat(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RotateAnimatedText('FAUNA', alignment: Alignment.centerLeft),
                              RotateAnimatedText('OCÉANOS', alignment: Alignment.centerLeft),
                              RotateAnimatedText('LUGARES', alignment: Alignment.centerLeft),
                            ],
                            repeatForever: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const NavigatorApp()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            backgroundColor: AppColors.color3,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Inicia Sesión',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google),
                          color: const Color(0xFFDB4437),
                          iconSize: 25,
                          onPressed: () => print("Login con Google"),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextButton(
                        onPressed: () => print("Crea una cuenta"),
                        child: const Text(
                          '¿No tienes cuenta? Crea una aquí',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}