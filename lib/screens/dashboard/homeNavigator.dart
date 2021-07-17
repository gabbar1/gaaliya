import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gaaliya/screens/galiLib/galiLibView.dart';
import 'package:flutter/material.dart' as textfont;
import 'package:gaaliya/upload/galiUploading.dart';
import 'package:provider/provider.dart';
import 'package:gaaliya/upload/imageUpload.dart';

/// This is the stateful widget that the main application instantiates.
class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

/// This is the private State class that goes with HomeNavigator.
class _HomeNavigatorState extends State<HomeNavigator> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  int _CurrentIdex = 0;
  String uid = "";
  Widget callPage(int currentIdex) {
    switch (currentIdex) {
      case 0:
        return ImageUpload();
      case 1:
        return GaliUploading();
      case 2:return ImageUpload();
      case 3:return GaliLibView();

        break;
      default:
        return ImageUpload();
    }
  }

  void afterBuildFunction(BuildContext context) {
    FirebaseDatabase.instance.reference().child('subscription').child(uid).once().then((DataSnapshot snapshot){
      if(snapshot.value!=null){
        Map<dynamic, dynamic> subscribeList = snapshot.value;
        subscribeList.forEach((key, value) {
          FirebaseMessaging.instance.subscribeToTopic(value['subriberID']);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,

      body: Center(
        child: callPage(_CurrentIdex),
      ),
      bottomNavigationBar: Container(

        decoration: BoxDecoration(

          color: Color(0xFF37343B),

            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        height: 90,
        child: Row(
          children: [

            GestureDetector(
              onTap: (){
               setState(() {
                 _CurrentIdex =0;
               });
              },
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width/6,
                child: Image.asset("assets/images/home.png"),
              ),
            ),
            Spacer(),
           GestureDetector(
             onTap: (){
               setState(() {
                 _CurrentIdex =1;
               });
             },
             child:  Container(
               height: 80,
               width: MediaQuery.of(context).size.width/6,
               child: Image.asset("assets/images/search.png"),
             ),
           ),
            Spacer(),
            GestureDetector(
              onTap: (){
                _CurrentIdex =2;

              },
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width/6,
                child: Image.asset("assets/images/add.png"),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                setState(() {
                  _CurrentIdex =3;

                });
              },
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width/6,
                child: Image.asset("assets/icons/ico_gali_lib.png"),
              ),
            ),
            Spacer(),



          ],
        ),
      )
    );
  }
}
