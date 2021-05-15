import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/profile/profileProvider.dart';
import 'package:gaaliya/service/authService.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:flutter/src/painting/text_style.dart' as style;
import 'package:flutter/material.dart' as containerColor;
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  String currentUser;
  ProfileView({this.currentUser});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String uid;

  void afterBuildFunction(BuildContext context) {
    var user = Provider.of<DashBoardProvider>(context, listen: false);
    user.getUserDetails(uid: uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
    Provider.of<ProfileProvider>(context, listen: false).storyList(uid: uid);
    Provider.of<DashBoardProvider>(context, listen: false)
        .getUserPostList(uid: widget.currentUser);
    Provider.of<DashBoardProvider>(context, listen: false)
        .getUserDetails(uid: uid);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  @override
  Widget build(BuildContext context) {
    print("---------------checkCurrentUser----------------");
    print(widget.currentUser);
    print(uid);
    print(DateTime.now());
    return Scaffold(
        extendBody: true,
        body:
            Consumer<DashBoardProvider>(builder: (context, userDetail, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.fill),
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
                                Text(
                                    userDetail.userDetails
                                        .where((element) =>
                                            element.userID ==
                                            widget.currentUser)
                                        .first
                                        .followers,
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
                                Text(
                                    userDetail.userDetails
                                        .where((element) =>
                                            element.userID ==
                                            widget.currentUser)
                                        .first
                                        .following,
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
                            userDetail.userDetails
                                .where((element) =>
                                    element.userID == widget.currentUser)
                                .first
                                .userName,
                            style: style.TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            userDetail.userDetails
                                .where((element) =>
                                    element.userID == widget.currentUser)
                                .first
                                .userEmail,
                            style: style.TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          uid == widget.currentUser
                              ? editProfile(uid: widget.currentUser,profile:Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.profile,email: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.userEmail,name: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.userName,folder: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.folderID )
                              : null;
                        },
                        child: Center(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 15,
                          child: Center(
                              child: Text(
                            uid == widget.currentUser ? "Edit" : "Follow",
                            style: style.TextStyle(color: Colors.white),
                          )),
                        )),
                      ),
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
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Consumer<DashBoardProvider>(
                              builder: (context, post, child) {
                            return GridView.builder(
                                itemCount: post.userPostList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, postList) {
                                  return CachedNetworkImage(
                                      imageUrl:
                                          post.userPostList[postList].imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: imageProvider),
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ));
                                });
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 70,
                right: MediaQuery.of(context).size.width / 2.7,
                left: MediaQuery.of(context).size.width / 2.7,
                child: Consumer<DashBoardProvider>(builder: (context,profile,child){
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(fit: BoxFit.cover ,image: NetworkImage(profile.userDetails
                            .where((element) =>
                        element.userID == widget.currentUser)
                            .isEmpty
                            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s"
                            : profile.userDetails.where((element) => element.userID == widget.currentUser).first.profile)),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),

                  );
                },),
              )
            ],
          );
        }));
  }

  editProfile({String uid,profile,name,email,folder}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    nameController.text = name;
    emailController.text = email;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: material.Color(0xFF262626),
          content: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        child: Image.asset("assets/icons/ico_pop.png"),
                      ))),
              Positioned(
                  top: 25,
                  child: Consumer<GaliImageProvider>(builder: (context,image,child){
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.cover,image: image.imageLink ==null? NetworkImage(image.imageLink ==null?profile:image.imageLink): FileImage(File(image.imageLink))),
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    );
                  },)),
              Positioned(top: 100,right: 85,child: GestureDetector(onTap: (){
                Provider.of<ImageFile>(context, listen: false)
                    .showImagePicker(context: context);
              },child: Container(height: 30,width: 30,child: Image.asset("assets/icons/ico_camera.png"),))),
              Container(
                height: 300,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
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
                            hintStyle: material.TextStyle(
                                color: material.Color(0xFFD8D6D9)),
                            hintText: "User Name",
                            fillColor: material.Color(0xFF312E34)),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
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
                            hintStyle: material.TextStyle(
                                color: material.Color(0xFFD8D6D9)),
                            hintText: "Email",

                            fillColor: material.Color(0xFF312E34)),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),

                    GestureDetector(
                      onTap: (){
                        print("------------FolderName-----------");
                        print(folder);
                        var upload = Provider.of<GaliImageProvider>(context, listen: false);
                        Provider.of<GaliImageProvider>(context, listen: false).imageLink!=null ? upload.uploadProfileToGoogleDrive(name : nameController.text,email : emailController.text,folder: folder,uid: uid,context: context,image: File(upload.imageLink),filename: upload.imageLink.split("/").last): Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(email:email,name:name,context: context,userID: uid );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        height: 70,
                        width: MediaQuery.of(context).size.width/2,
                        child: Center(child: Text("Save")),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
