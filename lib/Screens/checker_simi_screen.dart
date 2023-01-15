import 'package:flutter/material.dart';
import 'package:jewelry_land/Screens/SingleScreen/show_image_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CheckerSimiScreen extends StatefulWidget {
  static const routeName = "CHECKER_SIMI_SCREEN";
  const CheckerSimiScreen({Key? key}) : super(key: key);

  @override
  State<CheckerSimiScreen> createState() => _CheckerSimiScreenState();
}

class _CheckerSimiScreenState extends State<CheckerSimiScreen> {
  @override
  Widget build(BuildContext context) {
    final designModel = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(" Check Similarities"),
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("My Design"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                        ),
                        child: InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed(ShowImageScreen.routeName,arguments: {'urlImage':designModel['fileImage'],'typeImage':'local'});
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(designModel['fileImage'],
                                fit: BoxFit.contain,),
                            )
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text("Similar design"),
                  //     SizedBox(
                  //       height: 10,
                  //     ),
                  //     designModel['imageSimilarities']!=""&& designModel['imageSimilarities']!=null?Container(
                  //       width: 150,
                  //       height: 150,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(15),
                  //         border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                  //       ),
                  //       child: InkWell(
                  //           onTap: (){
                  //             Navigator.of(context).pushNamed(ShowImageScreen.routeName,arguments: {'urlImage':designModel['imageSimilarities'],'typeImage':'network'});
                  //           },
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(15),
                  //             child: Image.network(designModel['imageSimilarities'],
                  //               fit: BoxFit.contain,),
                  //           )
                  //       ),
                  //     ):Container(
                  //       alignment: Alignment.center,
                  //       width: 150,
                  //       height: 150,
                  //      child: ClipRRect(
                  //        child: Text('Not exists'),
                  //      )
                  //     ),
                  //   ],
                  // )

                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("${designModel['similarities']*100==0?"unique":designModel['similarities']*100<=100&&designModel['similarities']*100>95?"Already exists":""}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
              SizedBox(
                height: 20,
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),

                  onTap: (){

                  },
                  title: Text("Similarity Ratio: ",style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),),
                  subtitle:  Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
                    child: CircularPercentIndicator(
                      radius: 50,
                      percent: designModel['similarities'],
                      progressColor: Colors.deepPurple,
                      backgroundColor: Colors.deepPurple.shade100,
                      animation: true,
                      animationDuration: 3000,
                      center: Text("${designModel['similarities']*100}".split(".")[0]+"%",style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 30
                      ),),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
