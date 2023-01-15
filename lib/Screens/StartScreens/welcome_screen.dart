
import 'package:flutter/material.dart';
import 'package:jewelry_land/Screens/AuthScreens/login_screen.dart';
import 'package:jewelry_land/Screens/AuthScreens/singup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName =  "WELCOME_SCREEN";
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {


  @override
  Widget build(BuildContext context) {
    //------------- get size screen of mobile ------------------------
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    //get custom size ------------
    final backgroundHeight = (MediaQuery.of(context).size.height)*(1.20)/2;


    return Scaffold(
      //-------- set background by stack widget which has all thing -----------
      body: Stack(
        children: [
          //set image
          SizedBox(
            height: heightScreen,
            width: double.infinity,
            child:  Image.asset('assets/images/4.jpg',fit: BoxFit.cover,alignment: Alignment.center,),
          ),

          //set blur on image background
          Container(
            height: heightScreen,
            width: double.infinity,
           color: Colors.amber.shade50.withOpacity(0.4),
          ),

          // column for set widgets
          SingleChildScrollView(
            child: Column(
              children: [
                // name of app
                Container(
                  height: backgroundHeight,
                  alignment: Alignment.center,
                    child: Text('Jewelry Land',style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.6),fontSize: 40,fontWeight: FontWeight.w700),),
                ),

                // shadow for a container which has buttons
                Container(
                  height: heightScreen-backgroundHeight,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 20,
                        spreadRadius: 20,
                        offset: Offset(0,30)
                      )
                    ]
                  ),

                  // has buttons
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      //some text
                     Text("Your Appearance",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 30,fontWeight: FontWeight.w500),),
                     Text("Shows Your Quality",style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: 30,fontWeight: FontWeight.w500)),
                     //space
                     const SizedBox(
                       height: 30,
                     ),

                     //button sign Up
                     ElevatedButton(
                       //action on click
                       onPressed: (){
                         //go to sign up page as user
                         Navigator.of(context).pushNamed(SignUpScreen.routeName,arguments: {'typeUser':'user'});
                       },
                       child:  Text("Sign Up With Email",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Theme.of(context).primaryColor,
                           fixedSize: Size(widthScreen-100, 50),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                       ),
                     ),


                     // has buttons under sign Up
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [

                         //button for login
                         TextButton(
                           //action on click
                           onPressed: (){
                             //go to login page
                             Navigator.of(context).pushNamed(LoginScreen.routeName);
                           },
                           child: Text("Have an account already?",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14,fontWeight: FontWeight.w400),),

                         ),

                         //button for sign up as designer
                         TextButton(
                             onPressed: (){
                               //go to sign up page as designer
                               Navigator.of(context).pushNamed(SignUpScreen.routeName,arguments: {'typeUser':'designer'});
                             },
                             child: Text("Be come a Designer.",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w400),),

                         ),

                       ],
                     ),

                    ],
                  )
                )

              ],
            ),
          )

        ],
      )
    );
  }


}
