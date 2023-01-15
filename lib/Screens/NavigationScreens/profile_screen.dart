import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Widgets/Drawer/header_drawer.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "PROFILE_SCREEN";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection("Users");
  CollectionReference designers = FirebaseFirestore.instance.collection("Designers");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  GlobalKey<FormState> formKeyUserName = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyPhone = GlobalKey<FormState>();
  //UserModel? userModel;
  // variables to saved result after type in form
  String userName = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  String phoneNumber = "";
  //controls realtime for fields to get text on user typing any thing
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final userNameController = TextEditingController();

  bool hidePassword = true;
  IconData iconVisiblePassword = Icons.visibility_off_outlined;
  String showPassword = "show password";

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      body: StreamBuilder(
        stream: userModel['userModel'].typeUser=='user'?users.doc(userId).snapshots():designers.doc(userId).snapshots(),
        builder: (ctx,AsyncSnapshot<DocumentSnapshot> snapShot){

            if(snapShot.hasData){

            final data = snapShot.data!.data() as Map<String, dynamic>;
            final userModel2 = UserModel.fromJson(data);
              return Column(
                children: [
                  Container(
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
                          "${userModel2.userName}",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          "${userModel2.email}",
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Phone: ${userModel2.phoneNumber}",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onTap: (){
                        showDialog(context: context, builder: (context)=>editUserName(context,userModel2));
                      },
                      leading: Icon(Icons.settings,size: 20,color: Colors.black),
                      title: Text('Edit username',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onTap: (){
                        showDialog(context: context, builder: (context)=>editPhoneNumber(context,userModel2));
                      },
                      leading: Icon(Icons.settings,size: 20,color: Colors.black),
                      title: Text('Edit Phone Number',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                ],
              );

            }else{
              return Container(alignment: Alignment.center,child: Center(child: CircularProgressIndicator()),);
            }

      }

      ),
    );
  }
  editUserName(context,userModel) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          alignment: Alignment.center,
          elevation: 1,
          title: const Text("username"),
          icon: Icon(Icons.title, size: 20, color: Colors.black,),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          actions: [

            Form(
              key: formKeyUserName,
              child: Column(
                children: [
                  TextFormField(
                    controller: userNameController,
                    maxLength: 20,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "New username",
                      labelText: "Title",
                      prefixIcon: const Icon(Icons.title),

                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "user is required";
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await saveDataUserName(userModel);

                            Navigator.of(context).pop();
                        },
                        child: Text(
                            "save", style: TextStyle(fontSize: 20, color: Theme
                            .of(context)
                            .primaryColor)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: "cancel");
                        },
                        child: Text(
                            "Cancel", style: TextStyle(fontSize: 20, color: Theme
                            .of(context)
                            .primaryColor)),
                      ),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  editPhoneNumber(context,userModel) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          alignment: Alignment.center,
          elevation: 1,
          title: const Text("Phone Number"),
          icon: Icon(Icons.phone, size: 20, color: Colors.black,),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          actions: [

            Form(
              key: formKeyPhone,
              child: Column(
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                            await saveDataPhone(userModel);

                            Navigator.of(context).pop();

                        },
                        child: Text(
                            "save", style: TextStyle(fontSize: 20, color: Theme
                            .of(context)
                            .primaryColor)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: "cancel");
                        },
                        child: Text(
                            "Cancel", style: TextStyle(fontSize: 20, color: Theme
                            .of(context)
                            .primaryColor)),
                      ),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  saveDataUserName(userModel) async {
    if(formKeyUserName.currentState!.validate()){
      formKeyUserName.currentState!.save();
      setState(() {
        userName = userNameController.text;
      });
        await users.doc(userId).get().then((value) async {
          if(value.exists){
              await users.doc(userId).update({'userName':userName});
          }else{
              await designers.doc(userId).update({'userName':userName});
          }
          setState(() {
            userNameController.text = "";
          });

        });
      Fluttertoast.showToast(msg: "saved");
    }

  }
  saveDataPhone(userModel) async {
    if(formKeyPhone.currentState!.validate()){
      formKeyPhone.currentState!.save();
      setState(() {
        phoneNumber = phoneNumberController.text;
      });
        await users.doc(userId).get().then((value) async {
          if(value.exists){
              await users.doc(userId).update({"phoneNumber":phoneNumber});
          }else{
              await designers.doc(userId).update({"phoneNumber":phoneNumber});
          }
          setState(() {
            phoneNumberController.text = "";
          });
        });

      Fluttertoast.showToast(msg: "saved");
    }

  }

}
