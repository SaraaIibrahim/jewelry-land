import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/user.dart';

import '../../Screens/StartScreens/welcome_screen.dart';

class DrawerList extends StatelessWidget {
  final UserModel? userModel;
  const DrawerList({super.key,this.userModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              showDialog(context: context,builder: (contex)=>alertDialog(context));
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.logout,size: 20,color: Colors.black,),
                  ),
                  Expanded(child: Text('Logout',style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  alertDialog(context){
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 1,
      title: const Text("Do you want logout?"),
      icon: Icon(Icons.logout,size: 20,color: Colors.black,),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      actions: [
        TextButton(onPressed: () async {
          Navigator.of(context).pop();
          FirebaseAuth.instance.signOut().then((value){
            Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
          });

          Fluttertoast.showToast(msg: "Logout");
        },
          child: Text("Yes",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
          child: Text("No",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor)),

        ),
      ],
    );
  }

}
