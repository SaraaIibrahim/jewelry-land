import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/Order.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Screens/SingleScreen/single_design_screen.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "ORDERS_SCREEN";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  CollectionReference carts = FirebaseFirestore.instance.collection("Carts");
  CollectionReference designs = FirebaseFirestore.instance.collection("Designs");
  CollectionReference designers = FirebaseFirestore.instance.collection("Designers");
  CollectionReference orders = FirebaseFirestore.instance.collection("Orders");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<OrderModel> allOrders= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("My Orders",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: StreamBuilder(
        stream: orders.snapshots(),
        builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
          if(snapShot.hasData && snapShot.data!=null){
            final data = snapShot.data!.docs;
            allOrders.clear();
            if(data.isNotEmpty){
              for (var element in data) {

                if(element['designerId']==userId){
                  final orderModel = OrderModel(
                    id: element.id,
                    userId: element['userId'],
                    address: element['address'],
                    numberPhone: element['numberPhone'],
                    count: element['count'],
                    urlImage: element['urlImage'],
                    title: element['title'],
                    designId: element['designId'],
                    price: element['price'],
                  );
                  allOrders.add(orderModel);
                }

              }
            }

          }
          return allOrders.isNotEmpty&&allOrders!=null?Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: allOrders.length,
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
                                await designs.doc(allOrders[index].designId).get().then((value) async {
                                  final designModel = DesignModel.fromJson(value.data()! as Map<String,dynamic>);
                                  designModel.id = allOrders[index].designId;
                                  await designers.doc(userId).get().then((value) async {
                                    var similarities = await designModel.getSimilarities(context);
                                    final userModel = UserModel.fromJson(value.data()! as Map<String,dynamic>);
                                    Navigator.of(context).pushNamed(SingleDesignScreen.routeName,arguments: {
                                      'userModel':userModel,
                                      'designModel':designModel,
                                      'similarities':similarities
                                    });
                                  });
                                });

                              },child: Image.network(allOrders[index].urlImage!,fit: BoxFit.fill,)),

                            ),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                Text(
                                  allOrders[index].title.toString(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  allOrders[index].price.toString()+" L.E",
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
                                      Text(allOrders[index].count.toString(), style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),

                                    ],
                                  ),
                                )

                              ],
                            ),
                            SizedBox(width: 5,),
                            IconButton(
                                onPressed: () async {
                                 await allOrders[index].removeOrder(context);
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
            ],
          ):Container(alignment: Alignment.center,child: Center(child: Text("No Orders",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Theme.of(context).primaryColor),),),);
          },
      ),
    );
  }
}
