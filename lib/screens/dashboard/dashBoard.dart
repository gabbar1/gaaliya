import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/comments/commentView.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:gaaliya/service/minio.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
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
  int startIndex = 10;
  ScrollController scrollController = new ScrollController();
  bool isLoading = false;
  String uid;


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
    const region = "us-west-1";
    var minio = Minio(
      endPoint: 's3.$region.wasabisys.com',
      accessKey: 'VHNW6XFKQEN0737H95SA',
      secretKey: 'InDRZ7LHJjPZyeoocGkDjVzPB4nc71ZNiykZKegZ',
    );
    return Scaffold(
      backgroundColor: Color(0xFF232027),
      appBar: AppBar(
        backgroundColor: Color(0xFF232027),
        title: Text(
          "Gaaliya",
          style: TextStyle(color: Color(0xFFD8D6D7)),
        ),
  /*      actions: [SvgPicture.asset("assets/images/bell.svg"),SizedBox(width: 20,)],*/
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
              itemCount: post.postList.length <10 ? post.postList.length :  startIndex +1,
              separatorBuilder: (context,index){
                if(index%10 == 0&& index !=0){
                  return Container(
                    height: 330,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: NativeAdmob(
                      // Your ad unit id
                      adUnitID: addUnit,
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
                  return Container(margin: EdgeInsets.only(top: 10),child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<Event>(stream: FirebaseDatabase.instance.reference().child("user").child(post.postList[posts].userID).onValue,builder: (context,AsyncSnapshot<Event> event){
                        if(event.hasData){
                          return Row(  children: [


                            InkWell(
                              child: FutureBuilder(future: minio.presignedGetObject('gaaliya', event.data.snapshot.value['profile'],),builder: (context,index){
                                if(index.hasData){
                                  return Container(margin: EdgeInsets.only(left: 10),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Color(0xffD8D6D9),
                                      child: CircleAvatar(
                                          radius: 24,
                                          backgroundImage:NetworkImage(index.data)),
                                    ),
                                  );
                                }
                                else{
                                   return Container(margin: EdgeInsets.only(left: 10),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Color(0xffD8D6D9),
                                      child: CircleAvatar(
                                          radius: 24,
                                          backgroundImage:NetworkImage("https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg")),
                                    ),
                                  );
                                }
                              },),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileView(notificationID: event.data.snapshot.value['notificationID'],currentUser:event.data.snapshot.value['userID'] ,currentUsername: event.data.snapshot.value['userName'],currentUserEmail: event.data.snapshot.value['userEmail'] ,)),
                                );
                              },
                            ),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,children: [Container(
                                margin: EdgeInsets.only(left: 5, ),
                                child: Text(event.data.snapshot==null ? "user name":event.data.snapshot.value['userName'],  style: TextStyle(color: Colors.white))),Container(
                                margin: EdgeInsets.only(left: 5, top: 5),
                                child: Text(event.data.snapshot==null ? "no_userID":event.data.snapshot.value['galiUserID'],  style: TextStyle(color: Colors.white))),],)
                          ],);
                        } else{
                          return Row(children: [

                            Container(
                              margin: EdgeInsets.only(left: 20,),
                              child: ClipOval(
                                child: CachedNetworkImage(imageUrl: "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20, top: 5),
                                child: Text( "user name")),
                          ],);
                        }
                      }),
                      Container(
                        height: 10,

                      ),
                      Container(margin: EdgeInsets.only(right: 20,bottom: 10),
                        child: Row(children: [ Container(margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),width: MediaQuery.of(context).size.width-120,child: Text( post.postList[posts].gali,style: TextStyle(color: Colors.pink,fontSize: 18,fontWeight: FontWeight.bold),),),Spacer(),
                          InkWell(onTap: (){
                            Clipboard.setData(ClipboardData(text:post.postList[posts].gali
                            )).then((value) {
                              Fluttertoast.showToast(msg: "gaali copied");
                            });
                          },child: SvgPicture.asset("assets/images/copy.svg")),],),
                      ),
                      InkWell(onLongPress: () async{
                        largeImage(profile:await minio.presignedGetObject('gaaliya', post.postList[posts].imageUrl,));
                     //   largeImage(profile:post.postList[posts].imageUrl );
                      },child: FutureBuilder(future: minio.presignedGetObject('gaaliya', post.postList[posts].imageUrl,),builder: (context,index){
                        if(index.hasData){
                          return CachedNetworkImage(fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/2,imageUrl:  index.data ,
                            placeholder: (context, url) =>Container(
                              child: Center(child: Container( height: 100.0,
                                width: 100.0,child: CircularProgressIndicator(strokeWidth: 5,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
                              height: 100.0,
                              width: 100.0,
                            ),);
                        } else return Container(height:  MediaQuery.of(context).size.height/2);

                      },),),
                      Container(
                        height: 20,

                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 25, ),
                        height: 55,

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
                                      Provider.of<ImageFile>(context,listen:false).sendNotification(title: snapshot.value['userName']+" has liked your post",topic: post.postList[posts].userID,subject: "New Like");
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
                                child: SvgPicture.asset(
                                    "assets/images/comments.svg"),
                              ),
                            ),
                            Spacer(),
                            InkWell(child: Container(
                              margin: EdgeInsets.only(
                                  bottom: 15, top: 15, right: 40),
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset("assets/images/send.svg"),
                            ),onTap: () async{

                              if (Platform.isAndroid)  {
                                final cache = await DefaultCacheManager();
                                final file = await cache.getSingleFile(post.postList[posts].imageUrl);
                                List<String> imgPath = [file.path];
                                Share.shareFiles(imgPath,
                                  subject: "Gaaliyaa",
                                  text: post.postList[posts].gali+"\n\n"+"For more funny content download Gaaliya app now \n\n"+"https://play.google.com/store/apps/details?id=com.boss.gaaliya",
                                );
                              } else {
                                Share.share('Gaaliyaa',
                                  subject: post.postList[posts].gali,
                                );
                              }

                            },),
                          ],
                        ),
                      )
                    ],
                  ),);
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
      }}}}