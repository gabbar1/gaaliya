import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaaliya/helper/appUtils.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/followModel.dart';
import 'package:gaaliya/model/storyModel.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  List<StoryModel> storyLists = <StoryModel>[];
  List<FollowModel> followList = <FollowModel>[];
  Future<void> storyList({String uid}) async{
    transRef.child("story").child(uid).once().then((DataSnapshot snapshot) {
      storyLists.clear();


      if (snapshot != null) {
        Map<dynamic, dynamic> listComment = snapshot.value;

        if( listComment !=null){
          listComment.forEach((key, value) {
            StoryModel storyModel = StoryModel.fromJson({
              'key': key,
              'time': value['time'],
              'story':value['story']
            });
            storyLists.add(storyModel);
            notifyListeners();
          });
        }


      }
    });
}

 Future<void> following({String uid,String followerId}) async{
    
    transRef.child("followlist").child(uid).once().then((DataSnapshot snapshot){
      followList.clear();
      Map<dynamic, dynamic> listFollowers = snapshot.value;

      if(snapshot.value!=null){
        listFollowers.forEach((key, value) {
          FollowModel followModel = FollowModel.fromJson({
            'key':snapshot.key,
            'userID' : value['userID'],
            'userName' : value['userName']
          });
          followList.add(followModel);
          notifyListeners();
        });
        followList.forEach((element) {
          var count =0;
          count = count +1;

        });
      }
    });
 }

  Future<void> follow({String uid,String followerID,followerName}) async{
    await FirebaseMessaging.instance.subscribeToTopic(followerID);
    transRef.child('subscription').child(uid).child(followerID).update({
      'subriberID':followerID
    });
    Provider.of<ImageFile>(AppUtils().routeObserver.navigator.context,listen:false).sendNotification(subject: "Congratulations you got new follower",topic: followerID,title: "New follower");

    transRef.child("followlist").child(uid).push().set({
      'userID':followerID,
      'userName':followerName
    });

    transRef.child("user").child(uid).once().then((DataSnapshot snapshot) {
      if(snapshot.value!=null){
        transRef.child('user').child(uid).update({
          'following':snapshot.value['following']+1
        });
      }
    });

    transRef.child("user").child(followerID).once().then((DataSnapshot snapshot) {
      if(snapshot.value!=null){
        transRef.child('user').child(followerID).update({
          'followers':snapshot.value['followers']+1
        });
      }
    });
    notifyListeners();
  }
}