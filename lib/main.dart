import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewelry_land/Screens/SingleScreen/show_image_screen.dart';
import 'package:jewelry_land/Screens/StartScreens/splash_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreens/my_designs_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreens/orders_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/checkout_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/cart_screen.dart';
import 'package:jewelry_land/Screens/checker_simi_screen.dart';
import 'package:jewelry_land/Screens/create_design_screen.dart';
import 'package:jewelry_land/Screens/navigation_screen.dart';
import 'package:jewelry_land/Screens/AuthScreens/login_screen.dart';
import 'package:jewelry_land/Screens/NavigationScreens/profile_screen.dart';
import 'package:jewelry_land/Screens/AuthScreens/singup_screen.dart';
import 'package:jewelry_land/Screens/StartScreens/welcome_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/single_design_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/single_design_user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Jewelry Land',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor:  Color(0xffbf9c48),
    primaryColorDark: Colors.black38,
    focusColor:  Color(0xffbf9c48),
      ),
      routes: {
        '/':(context)=>SplashScreen(),
        WelcomeScreen.routeName:(context)=>WelcomeScreen(),
        LoginScreen.routeName:(context)=>LoginScreen(),
        SignUpScreen.routeName:(context)=>SignUpScreen(),
        NavigationScreen.routeName:(context)=>NavigationScreen(),
        ProfileScreen.routeName:(context)=>ProfileScreen(),
        NavigationScreen.routeName:(context)=>NavigationScreen(),
        MyDesignsScreen.routeName:(context)=>MyDesignsScreen(),
        CreateDesignScreen.routeName:(context)=>CreateDesignScreen(),
        OrdersScreen.routeName:(context)=>OrdersScreen(),
        ShowImageScreen.routeName:(context)=>ShowImageScreen(),
        CartScreen.routeName:(context)=>CartScreen(),
        CheckoutScreen.routeName:(context)=>CheckoutScreen(),
        SingleDesignScreen.routeName:(context)=>SingleDesignScreen(),
        CheckerSimiScreen.routeName:(context)=>CheckerSimiScreen(),
        SingleDesignUserScreen.routeName:(context)=>SingleDesignUserScreen(),
      },
    );
  }
}
