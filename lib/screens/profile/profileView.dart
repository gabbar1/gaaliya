import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/follow/followView.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/profile/profileProvider.dart';
import 'package:flutter/src/painting/text_style.dart' as style;
import 'package:flutter/material.dart' as containerColor;
import 'package:gaaliya/screens/search/searchView.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  String currentUser,currentUsername;
  ProfileView({this.currentUser,this.currentUsername});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String uid;

  void afterBuildFunction(BuildContext context) {
    var user = Provider.of<DashBoardProvider>(context, listen: false);
    user.getUserDetails(uid: uid);
    Provider.of<ProfileProvider>(context, listen: false).following(uid: uid);
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
    print(Provider.of<ProfileProvider>(context, listen: false).followList.where((element) => element.userID == uid));
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

                      color: Color(0xFF232027),
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
                          InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> FollowView(uid: widget.currentUser,follow: 2,)));

              },
                            child: Container(
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
                                        color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  Text("Followers",
                                      style: style.TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> FollowView(uid: widget.currentUser,follow: 1,)));

                            },
                            child: Container(
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
                                          fontWeight: FontWeight.bold,color: Colors.white)),
                                  Text("Following",
                                      style: style.TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                ],
                              ),
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
                                fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),
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
                      Consumer2<ProfileProvider,DashBoardProvider>(
                        builder: (context,profile,user,child) {

                          return GestureDetector(
                            onTap: () {
                              print(uid);
                              print(widget.currentUser);
                              profile.followList.where((element) => element.userID == widget.currentUser).isEmpty ? profile.follow(uid: uid,followerID: widget.currentUser,followerName: widget.currentUsername).then((value) {
                                profile.following(uid: uid);
                                user.getUserDetails();
                              }): uid != widget.currentUser ?unfollow(uid: uid,unfollowUser : widget.currentUser):null;
                              uid == widget.currentUser
                                  ? editProfile(galiUserID: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.galiUserID,uid: widget.currentUser,profile:Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.profile,email: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.userEmail,name: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.userName,folder: Provider.of<DashBoardProvider>(context,listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.folderID )
                                  :null;
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
                                      containerColor.Color(0xFFFC00FF),
                                      containerColor.Color(0xB2FEFA),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.height / 15,
                              child: Center(
                                  child: Text(uid == widget.currentUser ? "Edit" : profile.followList.where((element) => element.userID == widget.currentUser).isNotEmpty ? "Following":"Follow", style: style.TextStyle(color: Colors.white,fontSize: 14),))
                            )),
                          );
                        }
                      ),
                  /*    Consumer<ProfileProvider>(
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
                      }),*/
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Post",
                          style: style.TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
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
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                        return App(userPofile:  post.userPostList[postList].userID,);
                                      }));
                                    },
                                    child: CachedNetworkImage(
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
                                            )),
                                  );
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
                  return InkWell(
                    onTap: (){
                      largeImage(profile:profile.userDetails
                          .where((element) =>
                      element.userID == widget.currentUser).first.profile == null
                          ? "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg"
                          : profile.userDetails.where((element) => element.userID == widget.currentUser).first.profile );
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.cover ,image: NetworkImage(profile.userDetails
                              .where((element) =>
                          element.userID == widget.currentUser).first.profile == null
                              ? "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg"
                              : profile.userDetails.where((element) => element.userID == widget.currentUser).first.profile)),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),

                    ),
                  );
                },),
              )
            ],
          );
        }));
  }

  editProfile({String uid,profile,name,email,folder,galiUserID}) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController userIDController = TextEditingController();

    nameController.text = name;
    emailController.text = email;
    userIDController.text = galiUserID;
    GlobalKey<FormState> addPostFormKey = new GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: material.Color(0xFF262626),
          content: Form(key: addPostFormKey,child: Stack(
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
                    .showImagePicker(context: context,type: 1);
              },child: Container(height: 30,width: 30,child: Image.asset("assets/icons/ico_camera.png"),))),
              Container(
                height: 400,
                child: Column(
                  children: [
                    Container(
                      height: 120,
                    ),
                    Container(
                      height:50,
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
                      height: 5,
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
                      height: 5,
                    ),
                    Consumer<GaliImageProvider>(builder: (context,profile,child){
                      return   Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: TextField(

                          style: material.TextStyle(color: material.Color(0xFFD8D6D9)),
                          controller: userIDController,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(25.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: material.TextStyle(
                                  color: material.Color(0xFFD8D6D9)),
                              hintText: "User ID",

                              fillColor: material.Color(0xFF312E34)),
                        ),
                      );
                    },),
                    Container(
                      height: 5,
                    ),

                    Container(
                      height: 10,
                    ),

                    GestureDetector(
                      onTap: (){
                        bool isUpdate =true;
                        print("------------FolderName-----------");
                        print(folder);
                        var upload = Provider.of<GaliImageProvider>(context, listen: false);
                        if(galiUserID !=userIDController.text){
                          FirebaseDatabase.instance.reference().child('user').once().then((DataSnapshot snapshot){
                            if(snapshot.value!=null){
                              Map<dynamic, dynamic> listPost = snapshot.value;
                              listPost.forEach((key, value) {
                                print("------------GaliUserID----------");
                                print(galiUserID);
                                print(value['galiUserID']);
                                if(value['galiUserID'] == userIDController.text){
                                  setState(() {
                                    isUpdate = false;
                                  });
                                  showDialog(context: context, builder: (BuildContext context){
                                    return AlertDialog(title: Text("User Already Taken"),);
                                  });
                                } else{
                                  setState(() {
                                    isUpdate = true;
                                  });
                                }
                              });

                            }
                          });
                        }

                      isUpdate ?  Provider.of<GaliImageProvider>(context, listen: false).imageLink!=null ? upload.uploadProfileToGoogleDrive(galiUserID: userIDController.text,name : nameController.text,email : emailController.text,folder: folder,uid: uid,context: context,image: File(upload.imageLink),filename: upload.imageLink.split("/").last): Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(email:emailController.text,name:nameController.text,context: context,userID: uid,contentURL: profile,galiUserID: userIDController.text):null;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        height: 50,
                        width: MediaQuery.of(context).size.width/2,
                        child: Center(child: Text("Save")),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),),
        );
      },
    );
  }

  unfollow({String uid,unfollowUser}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Are You Sure",style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: material.Color(0xFF262626),
          content: Container(height: MediaQuery.of(context).size.height/5,child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
            InkWell(
              onTap: () async{
                await FirebaseMessaging.instance.unsubscribeFromTopic(unfollowUser);
                FirebaseDatabase.instance.reference().child('subscription').child(uid).child(unfollowUser).update({
                  'subriberID':null
                });
                FirebaseDatabase.instance.reference().child('followlist').child(uid).once().then((DataSnapshot snapshot){
                 if(snapshot.value!=null){
                   Map<dynamic, dynamic> listTag = snapshot.value;
                   listTag.forEach((key, value) {
                     if(value["userID"] == unfollowUser){
                       print(value);
                       FirebaseDatabase.instance.reference().child('followlist').child(uid).child(key).update(
                           {
                             'userName':null,
                             'userID':null
                           });
                     }


                   });
                 }
                });

                FirebaseDatabase.instance.reference()..child("user").child(uid).once().then((DataSnapshot snapshot) {
                  if(snapshot.value!=null){
                    FirebaseDatabase.instance.reference()..child('user').child(uid).update({
                      'following':snapshot.value['following']-1
                    });
                  }
                });

                FirebaseDatabase.instance.reference()..child("user").child(unfollowUser).once().then((DataSnapshot snapshot) {
                  if(snapshot.value!=null){
                    FirebaseDatabase.instance.reference()..child('user').child(unfollowUser).update({
                      'followers':snapshot.value['followers']-1
                    });
                  }
                }).then((value) =>   Navigator.pop(context));

                Provider.of<DashBoardProvider>(context,listen: false).getUserDetails();
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
                          child: Text("Unfollow")
                      ))),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.pop(context);
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
                          child: Text("Cancel")
                      ))),
            ),
          ],),),
        );
      },
    );
  }

  largeImage({String profile}){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(content: CachedNetworkImage(imageUrl: profile,),);
    });
  }
}
