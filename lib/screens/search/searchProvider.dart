import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaaliya/model/userModel.dart';

class SearchProvider extends ChangeNotifier{
  FirebaseDatabase ref = FirebaseDatabase();
  List result = [];
  List<String> type = <String>[];
  List<UserModel> userTagList = <UserModel>[];

  Future<void> getGaliLib() async{


    ref.reference().child("user").once().then((DataSnapshot snapshot){
    userTagList.clear();
      if(snapshot.value !=null){
        Map<dynamic, dynamic> listTag = snapshot.value;

        listTag.forEach((key,value){

          UserModel userModel = UserModel.fromJson({
            'profile' : value['profile'],
            'galiUserID' : value['galiUserID'],
            'userEmail' : value['userEmail'],
            'userID' : value['userID'],
            'userName' : value['userName'],
            'following' :value['following'],
            'followers' :value['followers'],
            'folderID' :value['folderID'],
            'key': key
          });
          userTagList.add(userModel);
          userTagList.forEach((element) {
            type.add(element.userName);
            result = type.toSet().toList();


          });
        });
        notifyListeners();
      }
    });

  }
}