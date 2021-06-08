import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaaliya/screens/addPost/addPost.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/galiLib/galiLibView.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:gaaliya/screens/search/searchView.dart';
import 'package:provider/provider.dart';

/// This is the stateful widget that the main application instantiates.
class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

/// This is the private State class that goes with HomeNavigator.
class _HomeNavigatorState extends State<HomeNavigator> {



  int _currentIdex = 0;
  String uid = "";
  Widget callPage(int currentIdex) {
    switch (currentIdex) {
      case 0:
        return App();
      case 1:
        return SearchView(status : "1");
      case 2:return AddPostView();
      case 3:return GaliLibView();
      case 4:return ProfileView(currentUser: uid,);
        break;
      default:
        return App();
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
    Provider.of<DashBoardProvider>(context,listen: false).getUserDetails();
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
        backgroundColor: Color(0xFF232027),
        extendBody: true,

      body: Center(
        child: callPage(_currentIdex),
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
                 _currentIdex =0;
               });
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width/6,
                child: SvgPicture.asset("assets/images/home.svg"),
              ),
            ),
            Spacer(),
           GestureDetector(
             onTap: (){
               setState(() {
                 _currentIdex =1;
               });
             },
             child:  Container(
               height:30,
               width: MediaQuery.of(context).size.width/6,
               child: SvgPicture.asset("assets/images/search.svg"),
             ),
           ),
            Spacer(),
            GestureDetector(
              onTap: (){
                _currentIdex =2;
                Provider.of<GaliImageProvider>(context,listen: false).imageLink =null;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddPostView()),
                );
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width/6,
                child: SvgPicture.asset("assets/images/add.svg"),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                setState(() {
                  _currentIdex =3;

                });
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width/6,
                child: SvgPicture.asset("assets/images/galiLib.svg",),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                setState(() {
                  _currentIdex =4;

                });
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width/6,
                child: SvgPicture.asset("assets/images/profile.svg",),
              ),
            ),



          ],
        ),
      )
    );
  }
}
