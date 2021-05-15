import 'package:firebase_database/firebase_database.dart';

class PostModel {
  String gali;
  String postID;
  String time;
  String userID;
  String imageUrl;
  int likes;
  int comments;
  String key;

  PostModel({this.gali, this.postID, this.time, this.userID,this.comments,this.likes,this.key,this.imageUrl});

  PostModel.fromJson(Map<dynamic, dynamic> json) {
    key = json["key"];
    gali = json['gali'];
    postID = json['postID'];
    time = json['time'];
    userID = json['userID'];
    likes = json['likes'];
    imageUrl = json['imageUrl'];
    comments = json['comments'];
  }
  PostModel.fromSnapShot(DataSnapshot snapshot) {
    key = snapshot.key;
    gali = snapshot.value['gali'];
    postID = snapshot.value['postID'];
    time = snapshot.value['time'];
    userID = snapshot.value['userID'];
    likes = snapshot.value['likes'];
    comments = snapshot.value['comments'];
    imageUrl = snapshot.value['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gali'] = this.gali;
    data['postID'] = this.postID;
    data['time'] = this.time;
    data['userID'] = this.userID;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}