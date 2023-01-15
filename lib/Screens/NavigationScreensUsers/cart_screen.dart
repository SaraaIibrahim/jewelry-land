import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/cart.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/checkout_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/single_design_user_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "CART_SCREEN";
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CollectionReference carts = FirebaseFirestore.instance.collection("Carts");
  CollectionReference designs = FirebaseFirestore.instance.collection("Designs");
  CollectionReference designers = FirebaseFirestore.instance.collection("Designers");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<CartModel> allItems= [];
  double totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("My Cart",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: StreamBuilder(
        stream: carts.doc(userId).snapshots(),
        builder: (ctx,AsyncSnapshot<DocumentSnapshot> snapShot){

          if(snapShot.hasData && snapShot.data!.data()!=null) {
            allItems.clear();
            totalPrice = 0;
            final data = snapShot.data!.data() as Map<String, dynamic>;


            data.forEach((key, value) async {
              final cartModel = CartModel(
                id: userId,
                designId: key,
                designerId: value['designerId'],
                title: value['title'],
                desc: value['desc'],
                urlImage: value['urlImage'],
                count: value['count'],
                price: value['price']
              );
              allItems.add(cartModel);
              totalPrice += int.parse(value['price'].toString())*value['count'];
            });

          }

          return allItems.isNotEmpty&&allItems!=null?Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: allItems.length,
                  itemBuilder: (_,index){
                    return Container(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 140,
                              child: InkWell( onTap: () async {
                                await designs.doc(allItems[index].designId).get().then((value) async {
                                  final designModel = DesignModel.fromJson(value.data()! as Map<String,dynamic>);
                                  designModel.id = allItems[index].designId;
                                  await designers.doc(allItems[index].designerId).get().then((value){
                                    final userModel = UserModel.fromJson(value.data()! as Map<String,dynamic>);
                                    Navigator.of(context).pushNamed(SingleDesignUserScreen.routeName,arguments: {
                                      'userModel':userModel,
                                      'designModel':designModel
                                    });
                                  });
                                });

                              },child: Image.network(allItems[index].urlImage!,fit: BoxFit.fill,)),

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
                                      IconButton(
                                      onPressed: () async {
                                        int count = int.parse(allItems[index].count.toString());
                                          if(count>0&&count<10){
                                            setState(() {
                                              count++;
                                            });
                                            await carts.doc(userId).update(
                                              {
                                                allItems[index].designId.toString():
                                                {
                                                  "count":count,
                                                  "desc":allItems[index].desc,
                                                  "designerId":allItems[index].designerId,
                                                  "price":allItems[index].price,
                                                  "title":allItems[index].title,
                                                  "urlImage":allItems[index].urlImage
                                                }
                                              }
                                            );

                                          }
                                      },
                                      icon: Icon(Icons.add_circle_outline)),
                                      SizedBox(width: 10,),
                                      Text(allItems[index].count.toString(), style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                                      SizedBox(width: 10,),
                                      IconButton(
                                          onPressed: () async {
                                            int count = int.parse(allItems[index].count.toString());
                                            if(count>1){
                                              setState(() {
                                                count--;
                                              });
                                              await carts.doc(userId).update(
                                                  {
                                                    allItems[index].designId.toString():
                                                    {
                                                      "count":count,
                                                      "desc":allItems[index].desc,
                                                      "designerId":allItems[index].designerId,
                                                      "price":allItems[index].price,
                                                      "title":allItems[index].title,
                                                      "urlImage":allItems[index].urlImage
                                                    }
                                                  }
                                              );

                                            }
                                          },
                                          icon: Icon(Icons.remove_circle_outline)),
                                    ],
                                  ),
                                )

                              ],
                            ),
                            SizedBox(width: 5,),
                            IconButton(
                            onPressed: (){
                                allItems[index].removeItemFromCart(context, allItems[index].designId);
                            }
                            , icon: Icon(Icons.delete))
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Total Price",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
                        SizedBox(height: 15,),
                        Text("$totalPrice L.E",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushNamed(CheckoutScreen.routeName,arguments: {'allItems': allItems,'totalPrice':totalPrice});
                      },
                      child: Text("Checkout",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(15)
                      ),
                    ),
                  ],
                ),
              )
            ],
          ):Container(alignment: Alignment.center,child: Center(child: Text("no items",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),),);
        },
      ),
    );
  }
}
