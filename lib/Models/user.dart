import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Screens/navigation_screen.dart';
// call collection firestore user
CollectionReference users = FirebaseFirestore.instance.collection("Users");
// call collection firestore designer
CollectionReference designers = FirebaseFirestore.instance.collection("Designers");
// name of key
class UserFields {
  static final String id = 'id';
  static final String userName = 'userName';
  static final String typeUser = 'typeUser';
  static final String phoneNumber = 'phoneNumber';
  static final String email = 'email';
  static final String password = 'password';
}


class UserModel {
  String? id;
  final String? userName;
  final String? phoneNumber;
  final String? typeUser;
  final String email;
  final String password;

  UserModel({this.id,
    this.userName,
    this.typeUser,
    this.phoneNumber,
   required this.email,
   required this.password,
  });

  UserModel copy({
    String? id,
    String? userName,
    String? typeUser,
    String? phoneNumber,
    String? email,
    String? password,
  }) =>
      UserModel(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        typeUser: typeUser ?? this.typeUser,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        password: password ?? this.password,
      );
  static UserModel fromJson(Map<String,dynamic?> json)=>UserModel(
    id: json[UserFields.id] as String,
    userName: json[UserFields.userName] as String,
    typeUser: json[UserFields.typeUser] as String,
    phoneNumber: json[UserFields.phoneNumber] as String,
    email: json[UserFields.email] as String,
    password: json[UserFields.password] as String,

  );
  Map<String, Object?> getMap() {
    return {
      UserFields.id: id,
      UserFields.userName: userName,
      UserFields.typeUser: typeUser,
      UserFields.phoneNumber: phoneNumber,
      UserFields.email: email,
      UserFields.password: password,
    };
  }

 Future login(BuildContext context ) async {
   showDialog(context: context, builder: (context) => const Center(
     child: CircularProgressIndicator(
       color: Colors.blue,
     ),
   ),barrierDismissible: false);
     try{
       // login
       await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: this.email,
         password: this.password,
       ).then((UserCredential value) {
         // when login get value of user
         final userId = value.user!.uid;
         //call collection to get data from firestore user
         users.doc(userId).get().then((DocumentSnapshot documentSnapshot){
           //check data is exists user
            if(documentSnapshot.exists){
              final userModel = UserModel.fromJson(documentSnapshot.data()! as Map<String,dynamic>);
              Navigator.of(context).pushNamedAndRemoveUntil(NavigationScreen.routeName,(route) => false,arguments: {'userModel': userModel});
            }else{
              //call collection to get data from firestore designer
              designers.doc(userId).get().then((DocumentSnapshot documentSnapshot){
                //check data is exists
                if(documentSnapshot.exists){
                  final userModel = UserModel.fromJson(documentSnapshot.data()! as Map<String,dynamic>);
                  Navigator.of(context).pushNamedAndRemoveUntil(NavigationScreen.routeName,(route) => false,arguments: {'userModel': userModel});
                }
              });
            }
         });

       });
     }on FirebaseAuthException catch(e){
       //cancel load
       Navigator.of(context).pop();
       Fluttertoast.showToast(msg: "invalid email or password");
     }
 }


  Future signUp(BuildContext context ) async{
    // load page when click signup
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),barrierDismissible: false);
    try {
      //create email with password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.email,
        password: this.password,
      ).then((value) async {
        //when complete create get value of user
        Fluttertoast.showToast(msg: "Successful Created");
        this.id = value.user!.uid;
        if(typeUser=='designer'){
          // set data into firestore collection designer
          designers.doc(this.id).set(this.getMap());
        }else{
          // set data into firestore collection user
          users.doc(this.id).set(this.getMap());
        }
        //go to homer screen
        Navigator.of(context).pushNamedAndRemoveUntil(NavigationScreen.routeName,(route) => false,arguments: {'userModel': this });

      });
    }on FirebaseAuthException catch(e){
      // if any error cancel show dialog
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Failed");
    }
  }

  updateDataUser() async {
    await users.doc(id).update({'userName':userName,"phoneNumber":phoneNumber});
  }
  updateDataDesigner() async {
    await designers.doc(id).update({'userName':userName,"phoneNumber":phoneNumber});
  }

}