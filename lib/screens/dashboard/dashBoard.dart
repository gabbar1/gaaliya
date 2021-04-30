import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/helper/googleCLientAPI.dart';
import 'package:gaaliya/screens/comments/commentView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashBoardProvider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  RefreshController refreshController;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  final ImagePicker _picker = ImagePicker();
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DashBoardProvider>(context, listen: false).getPostList();
    refreshController = RefreshController(initialRefresh: false);
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;

  }

  _uploadFileToGoogleDrive() async {
    final SharedPreferences prefs = await _prefs;
    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    print("User account $account");

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    File croppedFile = File(pickedFile.path);
    drive.File fileUpload = drive.File();
    drive.Permission per = drive.Permission();
    per.type = "anyone";
    per.role = "reader";
    fileUpload.name = "ayush";
    fileUpload.parents = [prefs.getString("folderID")];
    print(prefs.getString("folderID"));
    final result = await driveApi.files.create(fileUpload, uploadMedia: drive.Media(croppedFile.openRead(),croppedFile.lengthSync()),);
    try
    {
      driveApi.permissions.create(per, result.id);
      print("00000000000000000000000000000000000");
      print(result.id);
      print("https://drive.google.com/uc?export=download&id="+result.id);
      //Creating Permission after folder creation.
    }
    catch (Exception)
    {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text("Gaaliya",style: TextStyle(color: Colors.black),),
      ),
      body: Consumer<DashBoardProvider>(builder: (context, post, child) {
        return SmartRefresher(
          controller: refreshController,
          onRefresh: () {
            post.getPostList();
            refreshController.refreshCompleted();
          },
          child: ListView.builder(
              itemCount: post.postList.length,
              itemBuilder: (context, posts) {
                return Container(

                  margin: EdgeInsets.all(10),
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
                        Color(0xFF3897F0),
                        Color(0xFF0ED2F7),
                        Color(0xB2FEFA),



                      ],
                    ),

                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 20),
                            child: ClipOval(
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq7BgpG1CwOveQ_gEFgOJASWjgzHAgVfyozkIXk67LzN1jnj9I&s",
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              child: Text("Abhishek Mishra")),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50, top: 30,right: 50),
                        height: MediaQuery.of(context).size.height / 5,
                        child: Text(post.postList[posts].key),
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 25,left: 15,right: 15),
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E3311).withOpacity(0.1),

                            borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Row(

                          children: [

                            Center(
                              child: GestureDetector(
                                child: post.likes(postID: post.postList[posts].postID,uid: uid ),
                                onTap: () {
                                  _uploadFileToGoogleDrive();
                                  print("likeList"+post.postList[posts].likes.toString());
                                  post.setLikesList(
                                          postID: post.postList[posts].postID,uid: uid,node:post.postList[posts].key,like: post.postList[posts].likes ).then((value) => post.getPostList());
                                },
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommentView(postID: post.postList[posts].postID,userID: uid,)),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 15,top: 15),
                                height: 40,
                                width: 40,
                                child:
                                    Image.asset("assets/images/comments.png"),
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(bottom: 15,top: 15, right: 40),
                              height: 20,
                              width: 20,
                              child: Image.asset("assets/images/send.png"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }
}
