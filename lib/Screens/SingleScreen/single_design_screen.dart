import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewelry_land/Screens/SingleScreen/show_image_screen.dart';
import 'package:jewelry_land/Widgets/Drawer/header_drawer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SingleDesignScreen extends StatefulWidget {
  static const routeName = "SINGLE_DESIGN_SCREEN";
  const SingleDesignScreen({Key? key}) : super(key: key);

  @override
  State<SingleDesignScreen> createState() => _SingleDesignScreenState();
}

class _SingleDesignScreenState extends State<SingleDesignScreen> {


  @override
  Widget build(BuildContext context) {
    final designModel = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(
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
            Text("${designModel['similarities']*100==0?"unique":designModel['similarities']*100==100?"Already exists":""}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
            const SizedBox(
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
                      center: Text("${designModel['similarities']*100}".split(".")[0],style: TextStyle(
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
    );
  }


}
