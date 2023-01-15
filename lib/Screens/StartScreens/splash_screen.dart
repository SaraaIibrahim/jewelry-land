import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_land/Screens/StartScreens/get_data_screen.dart';
import 'package:jewelry_land/Screens/StartScreens/welcome_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Lottie.asset('assets/lotties/Jewelry.json'),
        nextScreen: FirebaseAuth.instance.currentUser !=null? GetDataScreen(): const WelcomeScreen(),
        backgroundColor: Theme.of(context).primaryColor,
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.fadeTransition,
        duration: 3500,


      ),
    );
  }
}
