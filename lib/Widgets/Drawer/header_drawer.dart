import 'package:flutter/material.dart';

import '../../Models/user.dart';

class HeaderDrawer extends StatelessWidget {

  final UserModel? userModel;
  const HeaderDrawer({super.key,this.userModel});



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/icons/user-profile.png'),
              ),
            ),
          ),
          Text(
            "${userModel?.userName}",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          Text(
            "${userModel?.email}",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
