import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_land/Models/cart.dart';
import 'package:jewelry_land/Screens/NavigationScreensUsers/cart_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/show_image_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SingleDesignUserScreen extends StatefulWidget {
  static const routeName = "SINGLE_DESIGN_USER_SCREEN";
  const SingleDesignUserScreen({Key? key}) : super(key: key);

  @override
  State<SingleDesignUserScreen> createState() => _SingleDesignUserScreenState();
}

class _SingleDesignUserScreenState extends State<SingleDesignUserScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final designModel = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushReplacementNamed(CartScreen.routeName,arguments: {"userModel":designModel['userModel']});
          }, icon: Icon(Icons.shopping_cart))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("${designModel['designModel'].title}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(ShowImageScreen.routeName,arguments: {
                    'urlImage':designModel['designModel'].urlImage,
                    'typeImage':'Network',
                  });
                },
                child: Image.network(designModel['designModel'].urlImage,fit: BoxFit.cover,alignment: Alignment.center,),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset("assets/icons/user-profile.png",fit: BoxFit.cover,alignment: Alignment.center,),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("${designModel['userModel'].userName}")
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),
                  Container(
                      width: 250,
                      child: Text("${designModel['designModel'].desc}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blue.shade50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Price: ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),
                  const SizedBox(
                    width: 20,
                  ),
                  Text("${designModel['designModel'].price} L.E",style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade
                  ),),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 80,
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: (){
                  final cartModel = CartModel(
                    id: userId,
                    designId: designModel['designModel'].id,
                    designerId: designModel['userModel'].id,
                    price: designModel['designModel'].price,
                    count: 1,
                    urlImage: designModel['designModel'].urlImage,
                    desc: designModel['designModel'].desc,
                    title: designModel['designModel'].title
                  );
                  cartModel.addItemToCart(context);
                  // final cartModel = CartModel(count: "1",designId: designModel['designModel'].designId,totalPrice:designModel['designModel'].price);
                  // cartModel.addItemToCart(context);
                },
                icon: Icon(Icons.add_shopping_cart),
                label:  Text('Add to Cart',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
