import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Screens/navigation_screen.dart';
import 'package:jewelry_land/Screens/StartScreens/welcome_screen.dart';
import 'package:lottie/lottie.dart';

class GetDataScreen extends StatefulWidget {
  const GetDataScreen({Key? key}) : super(key: key);

  @override
  State<GetDataScreen> createState() => _GetDataScreenState();
}

class _GetDataScreenState extends State<GetDataScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  CollectionReference designers = FirebaseFirestore.instance.collection("Designers");
  bool hasConnection =false;




  @override
  Widget build(BuildContext context) {
    InternetConnectionChecker().onStatusChange.listen((event) {
      final connection = event == InternetConnectionStatus.connected;
      setState(() {
        hasConnection = connection;

      });
    });
    if(hasConnection && FirebaseAuth.instance.currentUser !=null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      users.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          final userModel = UserModel.fromJson(
              documentSnapshot.data()! as Map<String, dynamic>);
          Navigator.of(context).pushReplacementNamed(
              NavigationScreen.routeName, arguments: {'userModel': userModel});
        } else {
          designers.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              final userModel = UserModel.fromJson(
                  documentSnapshot.data()! as Map<String, dynamic>);
              Navigator.of(context).pushReplacementNamed(
                  NavigationScreen.routeName, arguments: {'userModel': userModel});
            }
          });
        }
      });
    }else if(hasConnection){
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Center(
          child: Lottie.asset('assets/lotties/Jewelry.json'),
        ),
      ),
    );
  }
}

