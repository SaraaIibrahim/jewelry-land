import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
CollectionReference carts = FirebaseFirestore.instance.collection("Carts");
class CartFields {
  static final String id = 'id';
  static final String designId = 'designeId';
  static final String count = 'count';
  static final String price = 'price';
  static final String urlImage = 'urlImage';
  static final String title = 'title';
  static final String desc = 'desc';
  static final String designerId = 'designerId';
}

class CartModel{

  String? id;
  String? designId;
  int? count;
  String? price;
  String? urlImage;
  String? title;
  String? desc;
  String? designerId;

  CartModel({this.id,
    this.designId,
    this.count,
    this.price,
    this.urlImage,
    this.title,
    this.desc,
    this.designerId,
  });

  CartModel copy({
    String? id,
    String? designId,
    int? count,
    String? price,
    String? urlImage,
    String? title,
    String? desc,
    String? designerId,
  }) =>
      CartModel(
        id: id ?? this.id,
        designId: designId ?? this.designId,
        count: count ?? this.count,
        price: price ?? this.price,
        urlImage: urlImage ?? this.urlImage,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        designerId: designerId ?? this.designerId,

      );
  static CartModel fromJson(Map<String,dynamic?> json)=>CartModel(
    designId: json[CartFields.designId] as String,
    count: json[CartFields.count] as int,
    price: json[CartFields.price] as String,
    urlImage: json[CartFields.urlImage] as String,
    title: json[CartFields.title] as String,
    desc: json[CartFields.desc] as String,
    designerId: json[CartFields.designerId] as String,

  );
  Map<String, Object?> getMap() {
    return {
      designId.toString():{
        CartFields.count: count,
        CartFields.price: price,
        CartFields.urlImage: urlImage,
        CartFields.title: title,
        CartFields.desc: desc,
        CartFields.designerId: designerId,
      }

    };
  }

  addItemToCart(BuildContext context) async {
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),barrierDismissible: false);

    await carts.doc(id).get().then((value) async {
      if(value.exists){
        await carts.doc(id).update(
          this.getMap()
        );
      }else{
        await carts.doc(id).set(
           this.getMap()
        );
      }
    });
    Fluttertoast.showToast(msg: "Check your cart");
    Navigator.of(context).pop();
  }

  removeItemFromCart(BuildContext context,design) async {
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),barrierDismissible: false);

    await carts.doc(id).update({design:FieldValue.delete()});
    Fluttertoast.showToast(msg: "deleted");
    Navigator.of(context).pop();
  }

//check cart
  removeAllItems(userId){
    carts.doc(id).delete();
  }

}