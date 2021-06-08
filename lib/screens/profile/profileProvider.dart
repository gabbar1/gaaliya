import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/helper/appUtils.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/followModel.dart';
import 'package:gaaliya/model/storyModel.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
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
      print("----------followerLisr-----------");
      print(followList.length);
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

  Future<void> follow({String uid,String followerID,followerName,email}) async{
    await FirebaseMessaging.instance.subscribeToTopic(followerID);
    transRef.child('subscription').child(uid).child(followerID).update({
      'subriberID':followerID
    });
    Provider.of<ImageFile>(AppUtils().routeObserver.navigator.context,listen:false).sendNotification(subject: "Congratulations you got new follower",topic: email.replaceAll("@", "").replaceAll(".", ""),title: "New follower");

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


  Future<void>  unFollow({String uid,unFollowUser,BuildContext context}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Are You Sure",style: TextStyle(color: Colors.white,fontSize: 20),),
          backgroundColor: Color(0xFF262626),
          content: Container(height: MediaQuery.of(context).size.height/5,child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
            InkWell(
              onTap: () async{

                await FirebaseMessaging.instance.unsubscribeFromTopic(unFollowUser);
                FirebaseDatabase.instance.reference().child('subscription').child(uid).child(unFollowUser).update({
                  'subriberID':null
                });
                FirebaseDatabase.instance.reference().child('followlist').child(uid).once().then((DataSnapshot snapshot){
                  if(snapshot.value!=null){
                    Map<dynamic, dynamic> listTag = snapshot.value;
                    listTag.forEach((key, value) {
                      if(value["userID"] == unFollowUser){
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

                FirebaseDatabase.instance.reference()..child("user").child(unFollowUser).once().then((DataSnapshot snapshot) {
                  if(snapshot.value!=null){
                    FirebaseDatabase.instance.reference()..child('user').child(unFollowUser).update({
                      'followers':snapshot.value['followers']-1
                    });
                  }
                }).then((value) =>   Navigator.pop(context));

                Provider.of<DashBoardProvider>(context,listen: false).getUserDetails();
                following(uid: uid);
                notifyListeners();
              },
              child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF5458F7),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25))),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 15,
                      child: Center(
                          child: Text("Unfollow",style: TextStyle(color: Colors.white))
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
                          color: Color(0xFF5458F7),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25))),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 15,
                      child: Center(
                          child: Text("Cancel",style: TextStyle(color: Colors.white))
                      ))),
            ),
          ],),),
        );
      },
    );
  }
}