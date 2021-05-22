import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/screens/addPost/addPost.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/galiLib/galiLibView.dart';
import 'package:gaaliya/screens/likes/likesView.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:gaaliya/screens/search/searchView.dart';
import 'package:flutter/material.dart' as textfont;
import 'package:provider/provider.dart';

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
        return App();
      case 1:
        return SearchView();
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
                Provider.of<GaliImageProvider>(context,listen: false).imageLink =null;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddPostView()),
                );
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
           GestureDetector(
             onTap: (){
               setState(() {
                 _CurrentIdex =4;
               });
             },
             child: Consumer<DashBoardProvider>(

               builder: (BuildContext con, snapshot,child) {


                 if(snapshot.userDetails.isEmpty){
                  return Container(
                     height: 80,
                     width: MediaQuery.of(context).size.width/6,
                     child: Image.asset("assets/images/profile.png"),
                   );
                 } else{
                   return Container(
                     height: 25,
                     width: MediaQuery.of(context).size.width/6,
                     child: CircleAvatar(
                         radius: 15,
                         backgroundImage: NetworkImage(snapshot.userDetails.where((element) => element.userID == uid).first.profile==null ? "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg":snapshot.userDetails.where((element) => element.userID == uid).first.profile)
                     ),
                   );
                  /* return Container(
                     height: 30,
                     width: MediaQuery.of(context).size.width/6,
                     child: ClipRRect(borderRadius: BorderRadius.circular(8.0),child: CachedNetworkImage(imageUrl: snapshot.userDetails.where((element) => element.userID == uid).first.profile,)),
                   );*/
                 }

               }
             ),
           ),


          ],
        ),
      )
    );
  }
}
