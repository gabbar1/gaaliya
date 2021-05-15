import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/screens/addPost/addPost.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DashBoardProvider>(context,listen: false).getUserDetails();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
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

          color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
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
                child: Image.asset("assets/images/like.png"),
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
                 print("-------------profile------------------");
                 snapshot.userDetails.isNotEmpty ? print("isEmpty"):print("isNotEmpty");
                 if(snapshot.userDetails.isEmpty){
                  return Container(
                     height: 80,
                     width: MediaQuery.of(context).size.width/6,
                     child: Image.asset("assets/images/profile.png"),
                   );
                 } else{
                   return CircleAvatar(
                       radius: 15,
                       backgroundImage: NetworkImage(snapshot.userDetails.where((element) => element.userID == uid).first.profile)
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
            Spacer()

          ],
        ),
      )
    );
  }
}
