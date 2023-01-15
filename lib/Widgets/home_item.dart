import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_land/Models/cart.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Models/user.dart';
import 'package:jewelry_land/Screens/SingleScreen/single_design_user_screen.dart';


class HomeItem extends StatelessWidget {
  CollectionReference designers = FirebaseFirestore.instance.collection("Designers");
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? id;
  final String? title;
  final String? desc;
  final String? price;
  final String? confidence;
  String? urlImage;
  String? pathImage;
  final String? designerId;
  final String? classification;
  VoidCallback onDelete;

  HomeItem({
    super.key,
    this.id,
    this.title,
    this.desc,
    this.price,
    this.urlImage,
    this.pathImage,
    this.confidence,
    this.designerId,
    this.classification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final designModel = DesignModel(
          id: id,
          designerId: designerId,
          title: title,
          urlImage: urlImage,
          pathImage: pathImage,
          price: price,
          desc: desc,
          classification: classification,
          confidence: confidence,
        );
        var similarities = await designModel.getSimilarities(context);
        await designers.doc(designerId).get().then((value){
          final userModel = UserModel.fromJson(value.data()! as Map<String,dynamic>);
          Navigator.of(context).pushNamed(SingleDesignUserScreen.routeName,arguments: {
            'userModel':userModel,
          'designModel':designModel,
            'similarities':similarities});
        });

      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
              child:
              Image.network(urlImage!,height: 170,fit: BoxFit.cover,width: double.infinity,),
            ),
            Padding(padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text("${title}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
                SizedBox(height: 8,),
                Text("${price} L.E",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                SizedBox(height: 8,),
                IconButton(
                    onPressed: (){
                      final cartModel = CartModel(
                          id: userId,
                          designId: id,
                          designerId: designerId,
                          price: price,
                          count: 1,
                          urlImage: urlImage,
                          desc: desc,
                          title: title
                      );
                      cartModel.addItemToCart(context);
                    },
                    icon: Icon(Icons.add_shopping_cart)
                ),
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
