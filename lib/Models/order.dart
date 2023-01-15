import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

CollectionReference orders = FirebaseFirestore.instance.collection("Orders");

class OrderFields {
  static final String id = 'id';
  static final String designId = 'designId';
  static final String userId = 'userId';
  static final String count = 'count';
  static final String price = 'price';
  static final String title = 'title';
  static final String urlImage = 'Image';
  static final String address = 'Image';
  static final String numberPhone = 'Image';
}
class OrderModel {
  String? id;
   String? designId;
   String? userId;
   int? count;
   String? price;
   String? title;
   String? urlImage;
   String? address;
   String? numberPhone;

  OrderModel({this.id,
    this.designId,
    this.userId,
    this.count,
    this.price,
    this.title,
    this.urlImage,
    this.address,
    this.numberPhone,
  });

  OrderModel copy({
    String? id,
    String? designId,
    String? userId,
    String? price,
    int? count,
    String? title,
    String? urlImage,
    String? address,
    String? numberPhone,
  }) =>
      OrderModel(
        id: id ?? this.id,
        designId: designId ?? this.designId,
        userId: userId ?? this.userId,
        count: count ?? this.count,
        title: title ?? this.title,
        urlImage: urlImage ?? this.urlImage,
        address: address ?? this.address,
        numberPhone: numberPhone ?? this.numberPhone,
      );
  static OrderModel fromJson(Map<String,dynamic?> json)=>OrderModel(
    designId: json[OrderFields.designId] as String,
    userId: json[OrderFields.userId] as String,
    price: json[OrderFields.price] as String,
    count: json[OrderFields.count] as int,
    title: json[OrderFields.title] as String,
    urlImage: json[OrderFields.urlImage] as String,
    address: json[OrderFields.address] as String,
    numberPhone: json[OrderFields.numberPhone] as String,

  );
  Map<String, Object?> getMap() {
    return {
      OrderFields.designId: designId,
      OrderFields.userId: userId,
      OrderFields.price: price,
      OrderFields.count: count,
      OrderFields.title: title,
      OrderFields.urlImage: urlImage,
      OrderFields.address: address,
      OrderFields.numberPhone: numberPhone,
    };
  }


  addOrder(BuildContext context,designerId) async {
    await orders.doc().set(
        {
          "designId":designId,
            "count": count,
            "userId": userId,
            "price": price,
            "title": title,
            "urlImage": urlImage,
            "address": address,
            "numberPhone": numberPhone,
            "designerId":designerId,
        }
    );
  }
  removeOrder(BuildContext context) async {
    await orders.doc(id).delete();
  }

}