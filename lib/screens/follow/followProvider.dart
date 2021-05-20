import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaaliya/model/userModel.dart';

class FollowProvider extends ChangeNotifier{

  FirebaseDatabase ref = FirebaseDatabase();
  List result = [];
  List<String> type = <String>[];
  List<UserModel> followList = <UserModel>[];
  List<String> followerList= <String>[];

  Future<void> following({uid}) async{
    followerList.clear();
    ref.reference().child('followlist').child(uid).once().then((DataSnapshot snapshot) {

      if(snapshot.value!=null){
        Map<dynamic, dynamic> followers = snapshot.value;
        followers.forEach((key, value) {
          followerList.add(value['userID']);
          print(followerList);
        });
      }
    });

    ref.reference().child("user").once().then((DataSnapshot snapshot){
      followList.clear();
      if(snapshot.value !=null){
        Map<dynamic, dynamic> listTag = snapshot.value;
        print("------------TagList-----------");
        listTag.forEach((key,value){

          print(value['userID']);
          print("--------follower--------");
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
followerList.forEach((element) {

  print(element);
  if(element.contains(value['userID'])){
    followList.add(userModel);
    followList.forEach((element) {
      type.add(element.userName);
      result = type.toSet().toList();


    });
  }
});

        });
        notifyListeners();
      }
    });

  }
  Future<void> follower({uid}) async{
    followerList.clear();
    ref.reference().child('followlist').once().then((DataSnapshot snapshot) {

      if(snapshot.value!=null){
        Map<dynamic, dynamic> followers = snapshot.value;
        print("-----------follower==================");
        print(uid);
        followers.forEach((parent, value) {
          print("----------parent---------");
          print(parent);
          if(parent !=uid){
            Map<dynamic, dynamic> followersChild = value;
            followersChild.forEach((key, value) {
              print(parent);
              if(value['userID']== uid){
                print("------------keyofparent-------------");
                print(key);
                print(parent);
                followerList.add(parent);
              }

            });
          }
        });

      }
    });

    ref.reference().child("user").once().then((DataSnapshot snapshot){
      followList.clear();
      if(snapshot.value !=null){
        Map<dynamic, dynamic> listTag = snapshot.value;

        listTag.forEach((key,value){
          print("------------TagList-----------");
          print(value);

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

          followerList.forEach((element) {

            print(element);
            if(element.contains(value['userID'])){
              followList.add(userModel);
              followList.forEach((element) {
                type.add(element.userName);
                result = type.toSet().toList();


              });
            }
          });

        });
        notifyListeners();
      }
    });

  }
}