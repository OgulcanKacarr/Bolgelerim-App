
import 'package:flutter/cupertino.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../constants/AppStrings.dart';
import 'HomePage.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(AppStrings.logo),
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.black,
      duration: 2000,
    );
  }
}