import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/Order.dart';
import 'package:jewelry_land/Models/cart.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = "CHECKOUT_SCREEN";
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CollectionReference carts = FirebaseFirestore.instance.collection("Carts");
  CollectionReference designs = FirebaseFirestore.instance.collection("Designs");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<CartModel> allItems= [];
  double order = 0;
  double delivery = 50;
  double totalPrice = 0;


  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // variables to saved result after type in form
  String phoneNumber = "";
  String address = "";
  //controls realtime for fields to get text on user typing any thing
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final list = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    allItems = list['allItems'];
    order = list['totalPrice'] ;
    totalPrice = order+delivery;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Checkout",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: allItems.isNotEmpty&&allItems!=null?Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("All items",style: TextStyle(fontSize: 25),),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: allItems.length,
              itemBuilder: (_,index){
                return Container(
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 140,
                          child: Image.network(allItems[index].urlImage!,fit: BoxFit.fill,),

                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            Text(
                              allItems[index].title.toString(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              allItems[index].price.toString()+" L.E",
                              style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 140,
                              color: Colors.grey.shade100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Count: ", style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),

                                  SizedBox(width: 10,),
                                  Text(allItems[index].count.toString(), style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),

                                ],
                              ),
                            )

                          ],
                        )
                      ],
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 15,
              );
            },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  //column has all fields in form
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Order:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
                                SizedBox(height: 5,),
                                Text("Delivery:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
                                SizedBox(height: 5,),
                                Text("Total Price:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$order L.E",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
                                SizedBox(height: 5,),
                                Text("$delivery L.E",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
                                SizedBox(height: 5,),
                                Text("$totalPrice L.E",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      //address field
                      TextFormField(
                        controller: addressController,
                        maxLines: null,
                        minLines: 5,
                        decoration: InputDecoration(
                          prefixIconColor: Theme.of(context).primaryColor,
                          suffixIconColor: Theme.of(context).primaryColor,
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                          hintText: "address",
                        ),
                        keyboardType: TextInputType.multiline,
                        validator: (value){
                          if(value!.isEmpty){
                            return "address is required";
                          }
                        },
                      ),
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
                      const SizedBox(
                        height: 20,
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
                          check(context);
                          //Navigator.of(context).pushReplacementNamed('/');
                        },
                        child:  Text("Submit Order",style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                      ),
                      //button go to page login


                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ):Container(alignment: Alignment.center,child: CircularProgressIndicator(),),
    );
  }
  check(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        address = addressController.text;
        phoneNumber = phoneNumberController.text;
      });
    for (var element in allItems)  {
      final orderModel = OrderModel(
        designId: element.designId,
        price: element.price,
        count: element.count,
        urlImage: element.urlImage,
        title: element.title,
        userId: element.id,
        address: address,
        numberPhone: phoneNumber,
      );
      await orderModel.addOrder(context, element.designerId);

    }
     await CartModel().removeAllItems(userId);

    Fluttertoast.showToast(msg: "Ordered");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }


}
