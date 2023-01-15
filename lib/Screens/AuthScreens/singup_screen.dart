import 'package:flutter/material.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Screens/AuthScreens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName =  "SIGNUP_SCREEN";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //create key to control validate
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // variables to saved result after type in form
  String userName = "";
  String userID = "";
  String phoneNumber = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  //controls realtime for fields to get text on user typing any thing
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

//this variables to check if user need to see what is typed in password
  bool hidePassword = true;
  IconData iconVisiblePassword = Icons.visibility_off_outlined;
  String showPassword = "show password";

  @override
  Widget build(BuildContext context) {
    //------------- get size screen of mobile ------------------------
    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    //get custom size ------------
    final backgroundHeight = (MediaQuery.of(context).size.height)*(1.20)/2;

    //receive data type user from another page
    final typeUser = ModalRoute.of(context)!.settings.arguments as Map;

    //BAR
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(typeUser['typeUser']=='designer'?"Sign Up as Designer":"Create a new Account"),
        centerTitle: true,
        toolbarHeight: 70,
      ),

      //-------- set background by stack widget which has all thing -----------
      body: Container(
        alignment: Alignment.center,
        //to scroll screen when user type
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),

          //container form
          child: Form(
            key: formKey,
            //column has all fields in form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //user name field
                TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      prefixIconColor: Theme.of(context).primaryColor,
                      suffixIconColor: Theme.of(context).primaryColor,
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "Enter username",
                      prefixIcon: const Icon(Icons.drive_file_rename_outline),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a username";
                      } else if (value.length < 5) {
                        return "username must be at least 5 characters";
                      }
                    }),
                //space vertical
                const SizedBox(
                  height: 20,
                ),
                //phone number field
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    prefixIconColor: Theme.of(context).primaryColor,
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value){
                    if(value!.isEmpty){
                      return "phone is required";
                    }
                  },
                ),
                //space vertical
                const SizedBox(
                  height: 20,
                ),
                //email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIconColor: Theme.of(context).primaryColor,
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value!.isEmpty){
                      return "email is required";
                    }else if(!value.contains("@gmail.com")) {
                      return "A valid email is with gmail";
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
                    suffixIcon: Icon(iconVisiblePassword),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: hidePassword,
                  validator: (value){
                    if(value!.isEmpty){
                      return "password is required";
                    }else if(value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                  },
                ),
                //space vertical
                const SizedBox(
                  height: 20,
                ),
                //confirm password field
                TextFormField(
                  controller: passwordConfirmController,
                  decoration: InputDecoration(
                    prefixIconColor: Theme.of(context).primaryColor,
                    suffixIconColor: Theme.of(context).primaryColor,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.vpn_key),

                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: hidePassword,
                  validator: (value){
                    if(value!.isEmpty){
                      return "password is required";
                    }
                    else if(value!=passwordController.text.trim()){
                      return "Password doesn't match";
                    }
                  },
                ),
                //button show password
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    //action on click show password
                    onPressed: (){
                      setState(() {
                        if(hidePassword){
                          showPassword = "hide password";
                          iconVisiblePassword = Icons.visibility;
                          hidePassword = false;
                        }else {
                          showPassword = "show password";
                          iconVisiblePassword = Icons.visibility_off;
                          hidePassword = true;
                        }
                      });
                    },
                    child: Text(showPassword,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Theme.of(context).primaryColor),),
                  ),
                ),
                //space vertical
                const SizedBox(
                  height: 10,
                ),
                //button sign up
                MaterialButton(
                  height: 60,
                  minWidth: widthScreen-100,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  //action on click button
                  onPressed: (){
                    //function check validation
                    check(context,typeUser['typeUser']);
                    //Navigator.of(context).pushReplacementNamed('/');
                  },
                  child:  Text(typeUser['typeUser']=='designer'?"Sign Up":"Create",style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                ),
                //button go to page login
                TextButton(
                  //action on click button
                  onPressed: (){
                    //go to login page
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  },
                  child:  Text("I already have an account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Theme.of(context).primaryColor),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
//function check validation
  check(BuildContext context,typeUser){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      setState(() {
        userName = userNameController.text;
        phoneNumber = phoneNumberController.text;
        email = emailController.text;
        password = passwordController.text.hashCode.toString();
      });
      final userModel = UserModel(userName: userName, typeUser: typeUser, phoneNumber: phoneNumber, email: email, password: password);
      userModel.signUp(context);
    }
  }

}
