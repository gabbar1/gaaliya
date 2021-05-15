import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/helper/helper.dart';

import 'package:gaaliya/screens/comments/commentView.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashBoardProvider.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  RefreshController refreshController;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Gaaliya",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<DashBoardProvider>(builder: (context, post, child) {
        return SmartRefresher(
          controller: refreshController,
          onRefresh: () {
            post.getPostList();
            refreshController.refreshCompleted();
          },
          child:  post.postList.isNotEmpty ? ListView.builder(
              itemCount: post.postList.length,
              itemBuilder: (context, posts) {
                print("-------------listImage------------------");
                print(post.postList[posts].imageUrl);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<Event>(stream: FirebaseDatabase.instance.reference().child("user").child(post.postList[posts].userID).onValue,builder: (context,AsyncSnapshot<Event> event){
                      if(event.hasData){
                        return Row(children: [

                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileView(currentUser:event.data.snapshot.value['userID'] ,)),
                              );
                            }
                            ,
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              child: ClipOval(
                                child: CachedNetworkImage(imageUrl:event.data.snapshot == null ? "":event.data.snapshot.value['profile'],
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              child: Text(event.data.snapshot==null ? "loading..":event.data.snapshot.value['userName'])),
                        ],);
                      } else{
                        return Text("loading.........");
                      }
                    }),
                    Container(
                      height: 10,

                    ),
                    CachedNetworkImage(fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/2,imageUrl: post.postList[posts].imageUrl,progressIndicatorBuilder: (context, url,
                        downloadProgress) =>
                        LinearProgressIndicator(
                          value:
                          downloadProgress.progress,backgroundColor: Colors.transparent,),),
                    Container(
                      height: 20,

                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 25, left: 15, right: 15),
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color(0xFF0E3311).withOpacity(0.5),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25))),
                      child: Row(
                        children: [
                          Center(
                            child: GestureDetector(
                              child: post.likes(
                                  postID: post.postList[posts].postID,
                                  uid: uid),
                              onTap: () {
                                print("likeList" +
                                    post.postList[posts].likes
                                        .toString());
                                post
                                    .setLikesList(
                                    postID:
                                    post.postList[posts].postID,
                                    uid: uid,
                                    node: post.postList[posts].key,
                                    like: post.postList[posts].likes)
                                    .then((value) => post.getPostList());
                              },
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentView(
                                      postID:
                                      post.postList[posts].postID,
                                      userID: uid,
                                    )),
                              );
                            },
                            child: Container(
                              margin:
                              EdgeInsets.only(bottom: 15, top: 15),
                              height: 40,
                              width: 40,
                              child: Image.asset(
                                  "assets/images/comments.png"),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 15, top: 15, right: 40),
                            height: 20,
                            width: 20,
                            child: Image.asset("assets/images/send.png"),
                          ),
                        ],
                      ),
                    )
                  ],
                );
                /*Stack(
                  children: [
                    Container(child:post.postList[posts].imageUrl!= null ?CachedNetworkImage(fit: BoxFit.fill,imageUrl: post.postList[posts].imageUrl,):Container(
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),

                    )),


                  ],
                );*/
              }) : Center(child: Container(child: Text("Loading......."),)),
        );
      }),
    );
  }
}
