import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewelry_land/Models/design.dart';
import 'package:jewelry_land/Screens/checker_simi_screen.dart';
import 'package:jewelry_land/Screens/SingleScreen/show_image_screen.dart';

class CreateDesignScreen extends StatefulWidget {
  static const routeName = "CREATE_DESIGN_SCREEN";
  const CreateDesignScreen({Key? key}) : super(key: key);

  @override
  State<CreateDesignScreen> createState() => _CreateDesignScreenState();
}

class _CreateDesignScreenState extends State<CreateDesignScreen> {
  String url = "https://www.lifewire.com/thmb/TRGYpWa4KzxUt1Fkgr3FqjOd6VQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/cloud-upload-a30f385a928e44e199a62210d578375a.jpg";
  bool onLoad = false;
  var outputs;
  var outputs2;
  File? image;
  final picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> getImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery );
    if(img==null) return;
      setState(() {
        onLoad = true;
      this.image =  File(img.path);
      });
      classifyImage(image!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onLoad = true;
    loadModel().then((value){
      setState(() {
        onLoad = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt",
    );
  }


  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      onLoad = false;
      outputs = output;
    });
  }



  //create key to control validate
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // variables to saved result after type in form
  String title = "";
  String desc = "";
  String price = "";
  //controls realtime for fields to get text on user typing any thing
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
        centerTitle: true,
        title: Text("Create New Design",style: TextStyle(fontSize: 18,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                onLoad?Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ):
                image == null ?Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                  ),
                  child: InkWell(
                    radius: 50,
                    onTap: (){
                      Navigator.of(context).pushNamed(ShowImageScreen.routeName,arguments: {'urlImage':url,'typeImage':'network'});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(url,
                        fit: BoxFit.cover,),
                    )
                  ),
                ): Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1,color: Theme.of(context).primaryColor),
                  ),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed(ShowImageScreen.routeName,arguments: {'urlImage':image,'typeImage':'local'});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(image!,
                          fit: BoxFit.contain,),
                      )
                    ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                 children: [
                   ElevatedButton.icon(
                     onPressed: (){
                        getImage();
                     },
                     label: Text('Select Image'),
                     icon: Icon(Icons.image),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Theme.of(context).primaryColor,
                     ),
                   ),
                   SizedBox(
                     height: 5,
                   ),
                   ElevatedButton.icon(
                     onPressed: (){
                      checkerSimilarities(context);
                     },
                     icon: Icon(Icons.check,size: 20),
                     label: Text('Check Similarities'),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Theme.of(context).primaryColor,
                     ),
                   ),

                   SizedBox(
                     height: 5,
                   ),
                   outputs!=null?
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text("${outputs[0]["label"]}".replaceAll(RegExp(r'[0-9]'), ''),style: TextStyle(fontSize: 18,color: Colors.blue)),
                       //Text("${outputs2[0]["label"].replaceAll(RegExp(r'[0-9]'),'').i}",style: TextStyle(fontSize: 18,color: Colors.blue)),

                     ],
                   ):
                       Text(""),

                 ],
               )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: formKey,
              //column has all fields in form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //title field
                  TextFormField(
                      controller: titleController,
                      cursorHeight: 15,
                      maxLength: 30,
                      decoration: InputDecoration(
                        prefixIconColor: Theme.of(context).primaryColor,
                        suffixIconColor: Theme.of(context).primaryColor,
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: "Title",
                        prefixIcon: const Icon(Icons.title),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a title";
                        } else if (value.length < 5) {
                          return "Title must be at least 5 characters";
                        }
                      }),
                  //space vertical
                  const SizedBox(
                    height: 20,
                  ),
                  //description field
                  TextFormField(
                    controller: descController,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      prefixIconColor: Theme.of(context).primaryColor,
                      suffixIconColor: Theme.of(context).primaryColor,
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "Description design .....",
                    ),
                    keyboardType: TextInputType.multiline,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Description is required";
                      }
                    },
                  ),
                  //space vertical
                  const SizedBox(
                    height: 20,
                  ),
                  //price field
                  TextFormField(
                    controller: priceController,
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixIconColor: Theme.of(context).primaryColor,
                      suffixIconColor: Theme.of(context).primaryColor,
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 2,color: Theme.of(context).primaryColor)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "Price",
                      prefixIcon: const Icon(Icons.price_change),
                    ),
                    keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                    validator: (value){
                      if(value!.isEmpty){
                        return "price is required";
                      }
                    },
                  ),
                  //space vertical
                  const SizedBox(
                    height: 20,
                  ),
                  //button sign up
                  MaterialButton(
                    height: 60,
                    minWidth: widthScreen-100,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    //action on click button
                    onPressed: (){
                      //function check validation
                      check(context);
                      //Navigator.of(context).pushReplacementNamed('/');
                    },
                    child:  Text("Create",style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                  //button go to page login


                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  check(BuildContext context){
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      setState(() {
        title = titleController.text;
        desc = descController.text;
        price = priceController.text;

      });
        final designerId = user!.uid;
        if(image!=null){
          var nameImage = image.toString().split("/");
          final designModel =DesignModel(
            title: title,
            desc: desc,
            price: price,
            confidence: outputs[0]['confidence'].toString(),
            designerId: designerId,
            classification: outputs[0]['label'].replaceAll(RegExp(r'[0-9]'), ''),
          );
          designModel.newDesign(context,nameImage[nameImage.length-1], image as File );

        }else{
          Fluttertoast.showToast(msg: "No Image is Selected");
        }
    }
  }


  checkerSimilarities(BuildContext context) async {
    if(image!=null){
      final designModel = DesignModel(confidence: outputs[0]['confidence'].toString(),classification: outputs[0]['label'].replaceAll(RegExp(r'[0-9]'), ''));
      final imageSimilarities= await designModel.getSimilaritiesImage(context);
      final similarities = await designModel.getSimilarities(context);
      Navigator.of(context).pushNamed(CheckerSimiScreen.routeName,arguments: {
        'designModel' : designModel,
        'imageSimilarities' : imageSimilarities,
        'similarities' : similarities,
        'fileImage' : image,
      });

    }else{
      Fluttertoast.showToast(msg: "No Image is Selected");
    }

  }
}
