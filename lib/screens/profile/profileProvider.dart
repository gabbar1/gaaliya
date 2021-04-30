import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaaliya/model/storyModel.dart';

class ProfileProvider extends ChangeNotifier{
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  List<StoryModel> storyLists = <StoryModel>[];
  Future<void> storyList({String uid}) async{
    transRef.child("story").child(uid).once().then((DataSnapshot snapshot) {
      storyLists.clear();
      print("-----------------------------------");

      if (snapshot != null) {
        Map<dynamic, dynamic> listComment = snapshot.value;
        print(listComment);
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
}