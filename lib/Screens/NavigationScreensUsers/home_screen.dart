import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Widgets/home_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HOME_SCREEN";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference designs = FirebaseFirestore.instance.collection("Designs");

  var selected = "all";

  List<DesignModel> allDesign= [];
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfff7f7f7),
        alignment: Alignment.center,
        child:  Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          selected = "all";
                        });
                      },
                      child: Text('all'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          selected = "earrings";
                        });
                      },
                      child: Text('earrings'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          selected = "rings";
                        });
                      },
                      child: Text('rings'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          selected = "necklace";
                        });
                      },
                      child: Text('necklace'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: designs.snapshots(),
                builder: (ctx,AsyncSnapshot<QuerySnapshot> snapShot){
                  if(snapShot.hasData && snapShot.data!=null){
                    final data = snapShot.data!.docs;
                    allDesign.clear();
                    if(data.isNotEmpty){
                      for (var element in data) {
                        final designModel = DesignModel.fromJson(element.data() as Map<String,dynamic>);
                        designModel.id = element.id;
                        if(selected=="all"){
                          allDesign.add(designModel);
                        }else if(selected=="rings"&&designModel.classification!.trim().startsWith("ring")){
                          allDesign.add(designModel);
                        }else if(selected == "earrings"&&designModel.classification!.trim().startsWith("earring")){
                          allDesign.add(designModel);
                        }else if(selected == "necklace"&&designModel.classification!.trim().startsWith("necklace")){
                          allDesign.add(designModel);
                        }
                      }
                    }

                  }
                  return allDesign.isEmpty&&allDesign==null?Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ):GridView.builder(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3/2,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 300,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: allDesign.length,
                    itemBuilder: (_,index){
                      return HomeItem(
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

                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }

}
