import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Screens/create_design_screen.dart';
import 'package:jewelry_land/Widgets/design_item.dart';

class MyDesignsScreen extends StatefulWidget {
  static const routeName = "MY_DESIGNS_SCREEN";
  const MyDesignsScreen({Key? key}) : super(key: key);

  @override
  State<MyDesignsScreen> createState() => _MyDesignsScreenState();
}

class _MyDesignsScreenState extends State<MyDesignsScreen> {

  CollectionReference designs = FirebaseFirestore.instance.collection("Designs");

  List<DesignModel> allDesign= [];
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.orange.shade50,
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: designs.snapshots(),
          builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
            if(snapShot.hasData && snapShot.data!=null){
              final data = snapShot.data!.docs;
              allDesign.clear();
              if(data.isNotEmpty){
                for (var element in data) {

                  final designModel = DesignModel.fromJson(element.data() as Map<String,dynamic>);
                  if(userId == designModel.designerId){
                    designModel.id = element.id;
                      allDesign.add(designModel);
                  }
                }
              }

            }
            return allDesign.isEmpty&&allDesign==null?Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ):Container(
              padding: EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: allDesign.length,
                itemBuilder: (_,index){
                  return DesignItem(
                      id: allDesign[index].id,
                    designerId: allDesign[index].designerId,
                    title: allDesign[index].title,
                    urlImage: allDesign[index].urlImage,
                    pathImage: allDesign[index].pathImage,
                    price: allDesign[index].price,
                    desc: allDesign[index].desc,
                    classification: allDesign[index].classification,
                    confidence: allDesign[index].confidence,
                  onDelete: ()  {
                      allDesign[index].deleteDesign(context);
                    setState(() {
                        allDesign.remove(allDesign[index]);
                        allDesign.clear();
                      });
                  },);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.of(context).pushNamed(CreateDesignScreen.routeName);
        },
        label: Text("New Design",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
        icon:Icon(Icons.design_services_outlined,size: 20,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
