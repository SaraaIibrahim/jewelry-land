import 'dart:io';

import 'package:flutter/material.dart';

class ShowImageScreen extends StatefulWidget {
  static const routeName = "SHOW_IMAGE_SCREEN";
  const ShowImageScreen({Key? key}) : super(key: key);

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  @override
  Widget build(BuildContext context) {
    final qur = MediaQuery.of(context).size.height/3;
    final urlImage = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("image",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
      ),
      body: InteractiveViewer(
          clipBehavior: Clip.none,
          panEnabled: false,
          maxScale: 4,
          minScale: 1,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: qur*2,
              width: double.infinity,
              child: urlImage["typeImage"]=='local'?Image.file(urlImage["urlImage"] as File,fit: BoxFit.fill,):Image.network(urlImage["urlImage"].toString(),fit: BoxFit.fill,),
            ),
          )
      ),
    );
  }
}
