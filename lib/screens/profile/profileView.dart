import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/profile/profileProvider.dart';
import 'package:gaaliya/service/authService.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:flutter/src/painting/text_style.dart' as style;
import 'package:flutter/material.dart' as containerColor;
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
    Provider.of<ProfileProvider>(context, listen: false).storyList(uid: uid);
    Provider.of<DashBoardProvider>(context, listen: false).getPostList();
    Provider.of<DashBoardProvider>(context, listen: false).getUserDetails(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now());
    return Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
        color: Colors.white,
            image: DecorationImage(image: AssetImage("assets/images/background.png"),fit: BoxFit.fill),
            border: Border.all(
              color: Colors.grey,
            ),
           ),

              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 40, top: 20),
                          child: Column(
                            children: [
                              Text("350 K",
                                  style: style.TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Text("Followers",
                                  style: style.TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 40, top: 20),
                          child: Column(
                            children: [
                              Text("150 K",
                                  style: style.TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Text("Following",
                                  style: style.TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Column(
                      children: [
                        Text(
                          'Abhishek Mishra',
                          style: style.TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          "msachin213@gmail.com",
                          style:
                              style.TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [
                              0.1,
                              1.0,
                              1.0,
                            ],
                            colors: [
                              containerColor.Color(0xFF3897F0),
                              containerColor.Color(0xFF0ED2F7),
                              containerColor.Color(0xB2FEFA),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 15,
                      child: Center(
                          child: Text(
                        "Follow",
                        style: style.TextStyle(color: Colors.white),
                      )),
                    )),
                    Consumer<ProfileProvider>(
                        builder: (context, storyList, child) {
                      return Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                plusButton(),
                                ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: storyList.storyLists.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        margin: EdgeInsets.only(bottom: 18),
                                        child: storyButton(
                                            context: context,
                                            stories: storyList
                                                .storyLists[index].story));
                                  },
                                ),
                              ],
                            ),
                          ));
                    }),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Post",
                        style: style.TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                   Expanded(
                     child: Container(height: MediaQuery.of(context).size.height,child:  Consumer<DashBoardProvider>(
                         builder: (context, post, child) {
                           return GridView.builder(
                               itemCount: post.postList
                                   .where((element) => element.userID == uid)
                                   .length,
                               gridDelegate:
                               SliverGridDelegateWithFixedCrossAxisCount(
                                 crossAxisCount: 3,
                               ),
                               itemBuilder: (context, postList) {
                                 return Container(margin: EdgeInsets.all(5),decoration: BoxDecoration(border:Border.all(color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10))),child: Center(child: Text(post.postList[postList].gali)),);
                               });
                         }),),
                   )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 70,
              right: MediaQuery.of(context).size.width / 2.7,
              left: MediaQuery.of(context).size.width / 2.7,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Consumer<DashBoardProvider>(builder: (context,profile,child){

                  return ClipOval(
                      child: Image.network(profile.userDetails.isEmpty ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s": profile.userDetails[0].profile ));
                },),
              ),
            )
          ],
        ));
  }
}
