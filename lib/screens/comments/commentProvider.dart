import 'dart:core';
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaaliya/model/commentModel.dart';
import 'package:gaaliya/model/userModel.dart';

class CommentProvider extends ChangeNotifier {
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  List<CommentModel> commentList = <CommentModel>[];
  List<UserModel> userTagList = <UserModel>[];
  int i;

  Future<void> getCommentList({String postID}) async {

    transRef.child("comments").child(postID).once().then((DataSnapshot snapshot) {
      commentList.clear();

      if (snapshot != null) {
        Map<dynamic, dynamic> listComment = snapshot.value;

        if( listComment !=null){
          listComment.forEach((key, value) {
            CommentModel postModel = CommentModel.fromJson({
              'key': key,
              'comment': value['comment'],
              'likes': value['likes'],
              'name': value['name'],
              'postID': value['postID'],
              'time': value['time'],
              'userID':value['userID']
            });
            commentList.add(postModel);
            notifyListeners();
          });
        }


      }
    });
  }

  Future<void> UserTag() async{
    userTagList.clear();
    transRef.child("user").once().then((DataSnapshot snapshot){

      if(snapshot.value !=null){
        Map<dynamic, dynamic> listTag = snapshot.value;

        listTag.forEach((key,value){


          UserModel userModel = UserModel.fromJson({
            'profile' : value['profile'],
            'userEmail' : value['userEmail'],
            'userID' : value['userID'],
            'userName' : value['userName'],
            'following' :value['following'],
            'followers' :value['followers'],
            'folderID' :value['folderID'],
            'key': key
          });
          userTagList.add(userModel);
        });
        notifyListeners();
      }
    });
  }



  Future<void> setCommentLikes({String postID,int like,String uid,String node}) async{


    transRef.child("likes").child(uid).child(postID).child(node).once().then((DataSnapshot snapshot) {


      if(snapshot.value!=null){

        transRef.child("likes").child(uid).child(postID).child(node).set({
          'likes':null
        });
        transRef.child("comments").child(postID).child(node).update({
          'likes':like-1
        });
        getCommentList(postID: postID);

        notifyListeners();
      }else {
        transRef.child("likes").child(uid).child(postID).child(node).set({
          'likes':1
        });
        transRef.child("comments").child(postID).child(node).update({
          'likes':like+1
        });
        getCommentList(postID: postID);
        notifyListeners();
      }
    });

  }

  void omSendComment({String comment,postID,userID}) {

    FirebaseDatabase.instance.reference().child("comments").child(postID).push().set(
        {
          'comment':comment,
          'likes':0,
          'postID':postID,
          'time':DateTime.now().toString(),
          'userID':userID
        });

    getCommentList(postID: postID);
  }

}
