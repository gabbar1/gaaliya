import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:gaaliya/model/postModel.dart';
import 'package:gaaliya/model/userModel.dart';


class DashBoardProvider extends ChangeNotifier {
  List<PostModel> postList = <PostModel>[];
  List<PostModel> userPostList = <PostModel>[];
  List<UserModel> userDetails = <UserModel>[];
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  List<String> likeList = <String>[];
  int i;

  var userName,userProfile;

  Future<void> getPostList() async {
    transRef.child("content").once().then((DataSnapshot snapshot) {
      postList.clear();
      print("-----------------------------------");

      if (snapshot != null) {
        Map<dynamic, dynamic> listPost = snapshot.value;

        listPost.forEach((key, value) {
          print(value);
          PostModel postModel = PostModel.fromJson({
            'gali': value['gali'],
            'postID': value['postID'],
            'time': value['time'],
            'userID': value['userID'],
            'likes': value['likes'],
            'comments': value['comments'],
            'imageUrl': value['imageUrl'],
            'key': key
          });
          postList.add(postModel);
          postList.sort((a, b) =>
              DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
        });
        notifyListeners();
      }
    });
  }

  Future<void> setLikesList({String postID, int like, String uid, String node}) async {
    print("----------------------------------------likesssssssssssssssssss" +
        like.toString());

    transRef
        .child("likes")
        .child(uid)
        .child(postID)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        transRef.child("likes").child(uid).child(postID).set({'likes': null});
        transRef.child("content").child(node).update({'likes': like - 1});
        getPostList();

        notifyListeners();
      } else {
        transRef.child("likes").child(uid).child(postID).set({'likes': 1});
        transRef.child("content").child(node).update({'likes': like + 1});
        getPostList();
        notifyListeners();
      }
    });
  }

  Future<void> sendPost({String name, type, contentURL,BuildContext context}) async {
    String postID;

    transRef.child("galilib").once().then((value) {
      postID = "GL_" +  (value.value.length + 1 ?? 1).toString().padLeft(10, '0');
      print(postID);
      print(value.value.length);
      Navigator.pop(context);
      transRef.child("galilib").push().set({
        'name':name,
        'type':type,
        "image":contentURL
      }).then((value) {
        Fluttertoast.showToast(msg: "Image Uploaded");

      });
    });
  }

  Future<void> updatePost({BuildContext context}) async {
    String postID;

    transRef.child("galilib").once().then((DataSnapshot snapshot) {
      postID = "GL_" +  (snapshot.value.length + 1 ?? 1).toString().padLeft(10, '0');
      print(postID);
      print(snapshot.value.length);
      Map<dynamic, dynamic> lists = snapshot.value;
      lists.forEach((keys, value) {
        print("------------KeyValue----------------");
        print(keys);
        print(value["number"]);

        transRef.child("galilib").child(keys).update({
          'number':int.parse(value["number"].toString())
        });
        
      });
     // Navigator.pop(context);
     // transRef.child("galilib").child(path)
    });
  }



  Future<void> sendProfilePost({int total,current,String name,email,postContent, userID, contentURL,BuildContext context}) async {
    int postID;
    // onLoading(context: context, strMessage: total.toString() + "/"+ current.toString());
    transRef.child("content").once().then((value) {
      postID = (value.value==null ?1:value.value.length + 1 );
      print(postID);
     // print(value.value.length);
      transRef.child("content").push().set({
        'comments':0,
        'gali':"email",
        "imageUrl":contentURL,
        'likes':0,
        'number':postID,
        'postID':postID,
        'time':DateTime.now().toString(),
        'userID':"v7cX7HPGUubWIMu7ZLH9sHMksuJ3"
      }).then((value) {
        Fluttertoast.showToast(msg: "Image Uploaded   "+total.toString() + "/"+ (current+1).toString());

        Navigator.pop(context);



      });
     /* transRef.child("galilib").push().set({
        'name':name,
        'type':email,
        "image":contentURL,
        'time':DateTime.now().toString(),
        'number':postID
      }).then((value) {
        Fluttertoast.showToast(msg: "Image Uploaded   "+total.toString() + "/"+ (current+1).toString());

          Navigator.pop(context);
        


      });*/
    });
  }

  Widget likes({String postID, uid}) {
    return Container(
      margin: EdgeInsets.only(left: 40, bottom: 15, top: 15),
      height: 50,
      width: 20,
      child: FutureBuilder<Event>(
        future: FirebaseDatabase.instance
            .reference()
            .child("likes")
            .child(uid)
            .child(postID)
            .child("likes")
            .onValue
            .first,
        builder: (BuildContext context, snap) {
          if (snap.connectionState != ConnectionState.done) {
//print('project snapshot data is: ${snap.data}');
            return SvgPicture.asset("assets/icons/beforeLike.svg");
          } else {
            if (snap.hasError) {
              return SvgPicture.asset("assets/icons/beforeLike.svg");
            } else {
              if (snap.data.snapshot.value != null) {
                return SvgPicture.asset("assets/icons/afterLike.svg");
              } else {
                return SvgPicture.asset("assets/icons/beforeLike.svg");
              }
            }
          }
        },
      ),
    );
  }

  Future<void> getUserDetails({String uid}) async {
    transRef.child("user").once().then((DataSnapshot snapshot) {
      userDetails.clear();
      print("-----------------------------------");

      if (snapshot != null) {
        Map<dynamic, dynamic> listPost = snapshot.value;

        listPost.forEach((key, value) async{
          print(value);
          UserModel postModel = UserModel.fromJson({
            'profile' : value['profile'],
            'userEmail' : value['userEmail'],
            'userID' : value['userID'],
            'userName' : value['userName'],
            'following' :value['following'],
            'followers' :value['followers'],
            'folderID' :value['folderID'],
            'key': key
          });
          userDetails.add(postModel);
          await userDetails.where((element) => element.userID == uid);
        });
        notifyListeners();
      }
    });
  }

  Future<void> getUserPostList({String uid}) async {
    transRef.child("content").once().then((DataSnapshot snapshot) {
      userPostList.clear();
      print("-------------------haga----------------");

      if (snapshot != null) {
        Map<dynamic, dynamic> listPost = snapshot.value;

        listPost.forEach((key, value) {
          // print(value);
          PostModel postModel = PostModel.fromJson({
            'gali': value['gali'],
            'postID': value['postID'],
            'time': value['time'],
            'userID': value['userID'],
            'likes': value['likes'],
            'comments': value['comments'],
            'imageUrl': value['imageUrl'],
            'key': key
          });

          userPostList.add(postModel);
          userPostList.removeWhere((element) => element.userID != uid);
          userPostList.sort((a, b) =>
              DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
          print(userPostList);
        });
        notifyListeners();
      }
    });
  }



}
