import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';

import 'dart:async';

import 'package:provider/provider.dart';

class GaliUploading extends StatefulWidget {
  @override
  _GaliUploadingState createState() => _GaliUploadingState();
}

class _GaliUploadingState extends State<GaliUploading> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();


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
                        hintText: "gali",
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
                  onTap: (){
                   FirebaseDatabase.instance.reference().child("galiTextLib").push().set(
                       {
                         'content':nameController.text,
                         'type':emailController.text
                       }).then((value){
                         nameController.clear();
                         emailController.clear();
                         Fluttertoast.showToast(msg: "Gali Uploaded");
                   });
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
