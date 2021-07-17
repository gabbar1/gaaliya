import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';

import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<Asset> images = <Asset>[];
  List<Asset> resultList = <Asset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Consumer<GaliImageProvider>(builder: (context,imageLink,child){
          return  Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-50,
                  child: TextField(
                    style: material.TextStyle(color: material.Color(0xFFD8D6D9)),
                    controller: nameController,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.0),
                          ),
                        ),
                        filled: true,
                        hintStyle:
                        material.TextStyle(color: material.Color(0xFFD8D6D9)),
                        hintText: "name",
                        fillColor: material.Color(0xFF312E34)),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-50,
                  child: TextField(
                    style: material.TextStyle(color: material.Color(0xFFD8D6D9)),
                    controller: emailController,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.0),
                          ),
                        ),
                        filled: true,
                        hintStyle:
                        material.TextStyle(color: material.Color(0xFFD8D6D9)),
                        hintText: "type",
                        fillColor: material.Color(0xFF312E34)),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async{
                    String error = 'No Error Detected';

                    String _error = 'No Error Dectected';

                    try {

                      // resultList.clear();
                      resultList = await MultiImagePicker.pickImages(
                        maxImages: 300,
                        enableCamera: true,
                        selectedAssets: images,
                        cupertinoOptions: CupertinoOptions(
                          takePhotoIcon: "chat",
                          doneButtonTitle: "Fatto",
                        ),
                        materialOptions: MaterialOptions(
                          actionBarColor: "#abcdef",
                          actionBarTitle: "Example App",
                          allViewTitle: "All Photos",
                          useDetailsView: false,
                          selectCircleStrokeColor: "#000000",
                        ),
                      );

                      resultList.forEach((element) {
                        print(element.name);
                        print(element.identifier);

                      });
                    } on Exception catch (e) {
                      error = e.toString();
                    }
                  },
                  child: Center(
                    child: Container(
                        color: Colors.blue,
                        height: 50,
                        width: MediaQuery.of(context).size.width-200,
                        child: Center(child: Text('Choose Images'))
                    ),
                  ),),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                  print("filepath---------------------------");
                  print(imageLink.capturedNewFile);
                    Provider.of<GaliImageProvider>(context, listen: false)
                  .uploadProfileToGoogleDrive(name : nameController.text.trim(),email : emailController.text.trim(),context: context,image: resultList);
                      //  .uploadProfileToGoogleDrive(context: context,image: imageLink.capturedFile,filename: imageLink.filename);
                  },
                  child: Center(
                    child: Container(
                        color: Colors.blue,
                        height: 50,
                        width: MediaQuery.of(context).size.width-200,
                        child: Center(child: Text('Upload'))
                    ),
                  ),),
              ],
            ),
          );
        },));
  }
}
