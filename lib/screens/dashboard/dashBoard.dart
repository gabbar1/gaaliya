import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaaliya/helper/helper.dart';

import 'package:gaaliya/screens/comments/commentView.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dashBoardProvider.dart';

class App extends StatefulWidget {
  String userPofile;
  App({this.userPofile});
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  RefreshController refreshController;
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  final ImagePicker _picker = ImagePicker();
  int startIndex = 10;
  ScrollController scrollController = new ScrollController();
  bool isLoading = false;
  String uid;
  static const _adUnitID = "ca-app-pub-3940256099942544/8135179316";

  final _nativeAdController = NativeAdmobController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DashBoardProvider>(context, listen: false).getPostList(filterID : widget.userPofile);
    refreshController = RefreshController(initialRefresh: false);
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF232027),
        title: Text(
          "Gaaliya",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<DashBoardProvider>(builder: (context, post, child) {
        return SmartRefresher(
          controller: refreshController,
          onRefresh: () {
            post.getPostList();
            refreshController.refreshCompleted();
            _nativeAdController.reloadAd(forceRefresh: true);
          },
          child:  post.postList.isNotEmpty ? ListView.separated(

              controller: scrollController,
              itemCount: post.postList.length <10 ? post.postList.length+post.postList.length/10 :  startIndex +1,
              separatorBuilder: (context,index){
                if(index%10 == 0&& index !=0){
                  return Container(
                    height: 330,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: NativeAdmob(
                      // Your ad unit id
                      adUnitID: _adUnitID,
                      numberAds: 3,
                      controller: _nativeAdController,
                      type: NativeAdmobType.full,
                    ),
                  );
                } else{
                  return Container();
                }
              },
              itemBuilder: (context, posts) {

                if(posts == startIndex){
                  return nextIndex(posts, post);
                }  else{
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
                                      builder: (context) => ProfileView(currentUser:event.data.snapshot.value['userID'] ,currentUsername: event.data.snapshot.value['userName'] ,)),
                                );
                              }
                              ,
                              child: Container(
                                margin: EdgeInsets.only(left: 20, top: 20),
                                child: ClipOval(
                                  child: CachedNetworkImage(imageUrl:event.data.snapshot.value['profile']== null ? "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg":event.data.snapshot.value['profile'],
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, top: 20),
                                child: Text(event.data.snapshot==null ? "user name":event.data.snapshot.value['userName'])),
                          ],);
                        } else{
                          return Row(children: [

                            Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              child: ClipOval(
                                child: CachedNetworkImage(imageUrl: "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, top: 20),
                                child: Text( "user name")),
                          ],);
                        }
                      }),
                      Container(
                        height: 10,

                      ),
                      // FadeInImage.memoryNetwork( placeholder: kTransparentImage,image: post.postList[posts].imageUrl,),
                      InkWell(onLongPress: (){
                        largeImage(profile:post.postList[posts].imageUrl );
                      },child: CachedNetworkImage(fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/2,imageUrl: post.postList[posts].imageUrl,
                        placeholder: (context, url) =>Container(
                          child: Center(child: Container( height: 100.0,
                            width: 100.0,child: CircularProgressIndicator(strokeWidth: 5,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
                          height: 100.0,
                          width: 100.0,
                        ),),),
                      Container(
                        height: 20,

                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 25, left: 15, right: 15),
                        height: 55,
                        decoration: BoxDecoration(
                            color: const Color(0xFF0E3311).withOpacity(0.25),
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
                                  transRef.child('user').child(uid).once().then((DataSnapshot snapshot){
                                    if(snapshot!=null){
                                      Provider.of<ImageFile>(context,listen:false).sendNotification(title: snapshot.value['userName']+" has liked your post",topic: uid,subject: "New Like");
                                    }
                                  });

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
                }



              }) :
          Center(child: Container(child: CircularProgressIndicator(strokeWidth: 20,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
        );
      }),
    );
  }

  largeImage({String profile}){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(content: CachedNetworkImage(imageUrl: profile,),);
    });
  }

  nextIndex(int index, DashBoardProvider post) {
    if (startIndex < post.postList.length) {
      if (startIndex + 10 >=  post.postList.length) {
        var lastIndex =
            post.postList.length - index;
        startIndex = index + lastIndex;
        Future.delayed(Duration(seconds: 5));

      } else {
        startIndex = index + 10;
      }
    }
  }
}
