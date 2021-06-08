import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/follow/followView.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/profile/profileProvider.dart';
import 'package:flutter/src/painting/text_style.dart' as style;
import 'package:flutter/material.dart' as containerColor;
import 'package:gaaliya/service/authService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  String currentUser, currentUsername, currentUserEmail;
  ProfileView({this.currentUser, this.currentUsername, this.currentUserEmail});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String uid;
  String email;

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
    this.email = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
    this.email = user.email;
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
    return Scaffold(
        backgroundColor: Color(0xFF232027),
        body:
        Consumer<DashBoardProvider>(builder: (context, userDetail, child) {
      return userDetail.userDetails.isNotEmpty
          ? Stack(
              children: [
                Container(

                  decoration: BoxDecoration(

                    image: DecorationImage(
                        image: AssetImage("assets/icons/background.png"),
                        fit: BoxFit.fill),

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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FollowView(
                                              uid: widget.currentUser,
                                              follow: 2,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 40, top: 20),
                                child: Column(
                                  children: [
                                    Text(
                                        userDetail.userDetails.where(
                                                    (element) =>
                                                        element.userID ==
                                                        widget.currentUser) !=
                                                null
                                            ? userDetail.userDetails
                                                .where((element) =>
                                                    element.userID ==
                                                    widget.currentUser)
                                                .first
                                                .followers
                                            : "0",
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FollowView(
                                              uid: widget.currentUser,
                                              follow: 1,
                                            )));
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
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
                        Consumer2<ProfileProvider, DashBoardProvider>(
                            builder: (context, profile, user, child) {
                          return GestureDetector(
                            onTap: () {
                              profile.followList
                                      .where((element) =>
                                          element.userID == widget.currentUser)
                                      .isEmpty
                                  ? profile
                                      .follow(
                                          uid: uid,
                                          followerID: widget.currentUser,
                                          followerName: widget.currentUsername,
                                          email: widget.currentUserEmail)
                                      .then((value) {
                                      profile.following(uid: uid);
                                      user.getUserDetails();
                                    })
                                  : uid != widget.currentUser
                                      ? profile.unFollow(
                                          uid: uid,
                                          unFollowUser: widget.currentUser,
                                          context: context)
                                      : null;
                              uid == widget.currentUser
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                              galiUserID:
                                                  Provider.of<DashBoardProvider>(context, listen: false)
                                                      .userDetails
                                                      .where((element) =>
                                                          element.userID ==
                                                          widget.currentUser)
                                                      .first
                                                      .galiUserID,
                                              uid: widget.currentUser,
                                              profile:
                                                  Provider.of<DashBoardProvider>(context, listen: false)
                                                      .userDetails
                                                      .where((element) =>
                                                          element.userID ==
                                                          widget.currentUser)
                                                      .first
                                                      .profile,
                                              email: Provider.of<DashBoardProvider>(
                                                      context,
                                                      listen: false)
                                                  .userDetails
                                                  .where((element) => element.userID == widget.currentUser)
                                                  .first
                                                  .userEmail,
                                              name: Provider.of<DashBoardProvider>(context, listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.userName,
                                              folder: Provider.of<DashBoardProvider>(context, listen: false).userDetails.where((element) => element.userID == widget.currentUser).first.folderID)))
                                  : null;
                            },
                            child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFF5458F7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    child: Center(
                                        child: Text(
                                      uid == widget.currentUser
                                          ? "Edit"
                                          : profile.followList
                                                  .where((element) =>
                                                      element.userID ==
                                                      widget.currentUser)
                                                  .isNotEmpty
                                              ? "Following"
                                              : "Follow",
                                      style: style.TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )))),
                          );
                        }),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Post",
                            style: style.TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                                      onLongPress: () {
                                        largeImage(
                                            profile: post.userPostList[postList]
                                                .imageUrl);
                                      },
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return App(
                                            userPofile: post
                                                .userPostList[postList].userID,
                                          );
                                        }));
                                      },
                                      child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              material.Container(
                                                child: Center(
                                                    child: material.Container(
                                                  height: 50.0,
                                                  width: 50.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 5,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.blue),
                                                  ),
                                                )),
                                                height: 50.0,
                                                width: 50.0,
                                              ),
                                          imageUrl: post
                                              .userPostList[postList].imageUrl,
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: imageProvider),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
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
                Positioned(right: 40,top: 40,child: InkWell(onTap: (){
                  FirebaseAuth.instance.signOut().then((value) {
                    GoogleSignIn _googleSignIn = GoogleSignIn();
                    _googleSignIn.disconnect();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AuthService().handleAuth()),
                            (route) => false);
                  });
                },child: Container(child: SvgPicture.asset("assets/icons/logout.svg",height: 40,width: 40,),))),
                Positioned(
                  top: 70,
                  right: MediaQuery.of(context).size.width / 2.7,
                  left: MediaQuery.of(context).size.width / 2.7,
                  child: Consumer<DashBoardProvider>(
                    builder: (context, profile, child) {
                      return InkWell(
                        onTap: () {
                          largeImage(
                              profile: profile.userDetails
                                          .where((element) =>
                                              element.userID ==
                                              widget.currentUser)
                                          .first
                                          .profile ==
                                      null
                                  ? "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg"
                                  : profile.userDetails
                                      .where((element) =>
                                          element.userID == widget.currentUser)
                                      .first
                                      .profile);
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(profile.userDetails
                                              .where((element) =>
                                                  element.userID ==
                                                  widget.currentUser)
                                              .first
                                              .profile ==
                                          null
                                      ? "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg"
                                      : profile.userDetails
                                          .where((element) =>
                                              element.userID ==
                                              widget.currentUser)
                                          .first
                                          .profile)),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          : Center(
              child: Container(
              child: CircularProgressIndicator(
                strokeWidth: 20,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ));
    }));
  }

  largeImage({String profile}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: CachedNetworkImage(
              imageUrl: profile,
            ),
          );
        });
  }
}

class EditProfile extends StatefulWidget {
  String uid, profile, name, email, folder, galiUserID;
  EditProfile(
      {this.galiUserID,
      this.email,
      this.profile,
      this.uid,
      this.name,
      this.folder});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userIDController = TextEditingController();

  GlobalKey<FormState> addPostFormKey = new GlobalKey<FormState>();
  bool isUpdate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name;
    emailController.text = widget.email;
    userIDController.text = widget.galiUserID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232027),
      body: Consumer<GaliImageProvider>(builder: (context,userProfile,child){
        return Form(
          key: addPostFormKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                child: Container(

                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                  top: 50,
                  right: 50,
                  child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 40,width: 40,
                        child: Image.asset("assets/icons/ico_pop.png"),
                      ))),
              Positioned(
                  top: 135,
                  child: Consumer<GaliImageProvider>(
                    builder: (context, image, child) {
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: image.imageLink == null
                                    ? NetworkImage(image.imageLink == null
                                    ? widget.profile
                                    : image.imageLink)
                                    : FileImage(File(image.imageLink))),
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      );
                    },
                  )),
              Positioned(
                  top: 215,
                  right: 145,
                  child: GestureDetector(
                      onTap: () {
                        Provider.of<ImageFile>(context, listen: false)
                            .showImagePicker(context: context, type: 1);
                        setState(() {
                          isUpdate = true;
                        });
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Image.asset("assets/icons/ico_camera.png"),
                      ))),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                height: 400,
                child: Column(
                  children: [
                    Container(
                      height: 130,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        style:
                        material.TextStyle(color: material.Color(0xFFD8D6D9)),
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
                        style:
                        material.TextStyle(color: material.Color(0xFFD8D6D9)),
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
                    Consumer<GaliImageProvider>(
                      builder: (context, profile, child) {
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            style: material.TextStyle(
                                color: material.Color(0xFFD8D6D9)),
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
                      },
                    ),
                    Container(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {



                        if (widget.galiUserID != userIDController.text.trim()) {
                          FirebaseDatabase.instance
                              .reference()
                              .child('user')
                              .once()
                              .then((DataSnapshot snapshot) {
                            if (snapshot.value != null) {
                              Map<dynamic, dynamic> listPost = snapshot.value;
                              listPost.forEach((key, value) {
                                if (value['galiUserID'] ==
                                    userIDController.text.trim()) {
                                  if(mounted)
                                    setState(() {
                                      isUpdate = false;
                                    });
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("User Already Taken"),
                                        );
                                      });
                                } else {
                                  if(mounted)
                                    setState(() {
                                      isUpdate = true;
                                    });
                                }
                              });
                            }
                          });
                        }

                        isUpdate
                            ? userProfile.imageLink !=
                            null
                            ? userProfile.uploadProfileToGoogleDrive(
                            galiUserID: userIDController.text,
                            name: nameController.text,
                            email: emailController.text,
                            folder: widget.folder,
                            uid: widget.uid,
                            context: context,
                            image: File(userProfile.imageLink),
                            filename: userProfile.imageLink.split("/").last).then((value) => Navigator.pop(context))
                            : Provider.of<DashBoardProvider>(context,
                            listen: false)
                            .sendProfilePost(
                            email: emailController.text,
                            name: nameController.text,
                            context: context,
                            userID: widget.uid,
                            contentURL: widget.profile,
                            galiUserID: userIDController.text).then((value) => Navigator.pop(context))
                            : null;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF5458F7),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(child: Text("Save")),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },),
    );
  }
}
