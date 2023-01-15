import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Screens/StartScreens/welcome_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/show_image_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/single_design_screen.dart';

class DesignItem extends StatelessWidget {
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

  DesignItem({
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
        Navigator.of(context).pushNamed(SingleDesignScreen.routeName,arguments: {'designModel':designModel,'similarities':similarities});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),

        ),
        elevation: 7,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(urlImage.toString(),height: 250,width: double.infinity,fit: BoxFit.cover,alignment: Alignment.center,),
                ),
                Container(
                  height: 250,
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.8)
                      ],
                      //stops: [0.6,1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child: Text("$price L.E",style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade
                  ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Title: ',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),
                          Text("$title",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Description: ',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorDark),),
                          Text("${desc.toString().length>10?desc.toString().substring(0,10)+"....":desc.toString()}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(width: 30,),
                  IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context)=>alertDialog(context));
                    },
                    icon: Icon(Icons.delete),
                    )
                ],

              ),
              
            )
          ],
        ),
      ),
    );

  }

  alertDialog(context){
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 1,
      title: const Text("Do you want delete this?"),
      icon: Icon(Icons.delete,size: 20,color: Colors.black,),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      actions: [
        TextButton(onPressed: () {
          onDelete();
          Navigator.of(context).pop();
        },
          child: Text("Yes",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
          child: Text("No",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor)),

        ),
      ],
    );
  }
}
