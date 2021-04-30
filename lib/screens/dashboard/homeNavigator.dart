import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaaliya/screens/addPost/addPost.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/likes/likesView.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:gaaliya/screens/search/searchView.dart';

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

  Widget callPage(int currentIdex) {
    switch (currentIdex) {
      case 0:
        return App();
      case 1:
        return SearchView();
      case 2:return AddPostView();
      case 3:return LikesView();
      case 4:return ProfileView();
        break;
      default:
        return App();
    }
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
             child: Container(
               height: 80,
               width: MediaQuery.of(context).size.width/6,
               child: Image.asset("assets/images/profile.png"),
             ),
           )

          ],
        ),
      )
    );
  }
}
