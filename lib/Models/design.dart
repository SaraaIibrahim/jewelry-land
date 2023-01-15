import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

CollectionReference designs = FirebaseFirestore.instance.collection("Designs");

class UserFields {
  static final String id = 'id';
  static final String title = 'title';
  static final String desc = 'desc';
  static final String price = 'price';
  static final String confidence = 'confidence';
  static final String urlImage = 'urlImage';
  static final String pathImage = 'pathImage';
  static final String designerId = 'designerId';
  static final String classification = 'classification';
}


class DesignModel {
  String? id;
  final String? title;
  final String? desc;
  final String? price;
  final String? confidence;
  String? urlImage;
  String? pathImage;
  final String? designerId;
  final String? classification;

  DesignModel({this.id,
    this.title,
    this.desc,
    this.price,
    this.urlImage,
    this.pathImage,
    this.confidence,
    this.designerId,
    this.classification,
  });

  DesignModel copy({
    String? id,
    String? title,
    String? desc,
    String? price,
    String? confidence,
    String? urlImage,
    String? pathImage,
    String? designerId,
    String? classification,
  }) =>
      DesignModel(
        id: id ?? this.id,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        price: price ?? this.price,
        confidence: confidence ?? this.confidence,
        urlImage: urlImage ?? this.urlImage,
        pathImage: pathImage ?? this.pathImage,
        designerId: designerId ?? this.designerId,
        classification: classification ?? this.classification,
      );
  static DesignModel fromJson(Map<String,dynamic?> json)=>DesignModel(
    title: json[UserFields.title] as String,
    desc: json[UserFields.desc] as String,
    price: json[UserFields.price] as String,
    confidence: json[UserFields.confidence] as String,
    urlImage: json[UserFields.urlImage] as String,
    pathImage: json[UserFields.pathImage] as String,
    designerId: json[UserFields.designerId] as String,
    classification: json[UserFields.classification] as String,

  );
  Map<String, Object?> getMap() {
    return {
      UserFields.title: title,
      UserFields.desc: desc,
      UserFields.price: price,
      UserFields.confidence: confidence,
      UserFields.urlImage: urlImage,
      UserFields.pathImage: pathImage,
      UserFields.designerId: designerId,
      UserFields.classification: classification,
    };
  }

 newDesign(BuildContext context,nameImage,File file) async {
   showDialog(context: context, builder: (context) => const Center(
     child: CircularProgressIndicator(
       color: Colors.blue,
     ),
   ),barrierDismissible: false);
   //upload image to storage and get link perview
    final path = 'Designs/${designerId}/$nameImage';
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = await ref.putFile(file).whenComplete((){});
    urlImage = await uploadTask.ref.getDownloadURL();
    pathImage = path;
    //==================================
    await designs.doc().set(this.getMap());
    Navigator.of(context).pop();
    //cancel this screen
    Navigator.of(context).pop();



 }

 deleteDesign(BuildContext context) async {
   showDialog(context: context, builder: (context) => const Center(
     child: CircularProgressIndicator(
       color: Colors.blue,
     ),
   ),barrierDismissible: false);
   final ref = FirebaseStorage.instance.ref().child(pathImage!);
   await ref.delete();
   await designs.doc(id).delete();
   Navigator.of(context).pop();
   Fluttertoast.showToast(msg: "deleted");
 }

  getSimilarities(BuildContext context) async {
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    ),barrierDismissible: false);
    double minNumber = 1.0;
    bool unique = true;
    await designs.get().then((value){
      if(value.docs.isNotEmpty){
        for(var design in value.docs){
          if(design.id!=id){
            final designModel = DesignModel.fromJson(design.data()! as Map<String,dynamic>);
            designModel.id = design.id;

            if(designModel.classification == this.classification){
              final modelConfidenceInt = double.parse( designModel.confidence!);
              final confidenceInt =double.parse(this.confidence!);
              if(modelConfidenceInt >= confidenceInt && modelConfidenceInt <= minNumber ){
                unique = false;
                minNumber = modelConfidenceInt;
              }
            }
          }
        }
      }
    });

    double confidenceInt = double.parse(confidence!);
    double similarities = confidenceInt/minNumber ;
    Navigator.of(context).pop();
    return unique? 0.0 as double: similarities;

 }
 getSimilaritiesImage(BuildContext context) async {
    double minNumber = 1.0;
    String storeImage = "";
    bool unique = true;
     await designs.get().then((value){
      if(value.docs.isNotEmpty){
        for(var design in value.docs){
          if(design.id!=id){
            final designModel = DesignModel.fromJson(design.data()! as Map<String,dynamic>);
            designModel.id = design.id;

            if(designModel.classification == classification){
              final modelConfidenceInt = double.parse( designModel.confidence!);
              final confidenceInt =double.parse(confidence!);

              if(modelConfidenceInt >= confidenceInt && modelConfidenceInt <= minNumber ){
                unique = false;
                minNumber = modelConfidenceInt;
                storeImage = designModel.urlImage!;
              }
            }
          }
        }
      }
    });
    return unique? "": storeImage;

 }
 getSimilaritiesAllImages(BuildContext context) async {
    List<String> urlImages = [];
    await designs.get().then((value){
      if(value.docs.isNotEmpty){
        for(var design in value.docs){
          if(design.id!=id){
            final designModel = DesignModel.fromJson(design.data()! as Map<String,dynamic>);
            designModel.id = design.id;
            if(designModel.classification == classification){
              urlImages.add(designModel.urlImage!);
            }
          }
        }
      }
    });

    return urlImages;

 }



}