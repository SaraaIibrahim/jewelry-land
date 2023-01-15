import 'package:flutter/material.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Screens/AuthScreens/singup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName =  "LOGIN_SCREEN";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //create key to control validate
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // variables to saved result after type in form
  String email = "";
  String password = "";
  //controls realtime for fields to get text on user typing any thing
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //this variables to check if user need to see what is typed in password
  bool hidePassword = true;
  IconData iconVisiblePassword = Icons.visibility_off_outlined;

  @override
  Widget build(BuildContext context) {
    //------------- get size screen of mobile ------------------------
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    //get custom size ------------
    final backgroundHeight = (MediaQuery.of(context).size.height)*(1.20)/2;

    return Scaffold(
      //BAR
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Login',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
        toolbarHeight: 70,
        centerTitle: true,
      ),

        //-------- set background by stack widget which has all thing -----------
      body: Container(
        alignment: Alignment.center,
        //to scroll screen when user type
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),

          //container form
          child: Form(
            key: formKey,
            // column has all fields in form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //email field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIconColor: Theme.of(context).primaryColor,
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Your Email";
                    }else if (!value.toString().contains("@")) {
                      return "Invalid Email";
                    }
                  },
                ),
                //space vertical
                const SizedBox(
                  height: 20,
                ),
                //password field
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIconColor: Theme.of(context).primaryColor,
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                      icon: Icon(iconVisiblePassword),
                      onPressed: () {
                        setState(() {
                          if(hidePassword){
                            iconVisiblePassword = Icons.visibility;
                            hidePassword = false;
                          }else {
                            iconVisiblePassword = Icons.visibility_off;
                            hidePassword = true;
                          }
                        });
                      },
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: hidePassword,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Your Password";
                    }else if (value.length < 4) {
                      return "Invalid password";
                    }

                  },

                ),
                //space vertical
                const SizedBox(
                  height: 30,
                ),
                //button login
                MaterialButton(
                  height: 60,
                  minWidth: widthScreen-100,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  //action on click
                  onPressed: (){
                    //function
                    check(context);

                  },
                  child: const Text("Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                ),
                //row for two buttons to sign up as designer and user
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      //action on click button
                      onPressed: (){
                        //go to sign up page as user
                        Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName,arguments: {'typeUser':'user'});

                      },
                      //text in button
                      child: Text("Don't have an account?",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
                    ),
                    TextButton(
                      //action on click
                      onPressed: (){
                        //go to sign up page as designer
                        Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName,arguments: {'typeUser':'designer'});

                      },
                      //text in button
                      child:  Text("Be come a Designer.",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black)),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      )
    );
  }

  check(BuildContext context){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      setState(() {
        email = emailController.text;
        password = passwordController.text.hashCode.toString();
      });
      final userModel = UserModel(email: email, password: password);
      userModel.login(context);
    }
  }

}
