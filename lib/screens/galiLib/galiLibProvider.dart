import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaaliya/model/galiLibModel.dart';
import 'package:gaaliya/model/userModel.dart';

class GaliLibProvider extends ChangeNotifier{
  FirebaseDatabase ref = FirebaseDatabase();
  List result = [];
  List<String> type = <String>[];
  List<GaliLibModel> userTagList = <GaliLibModel>[];

  Future<void> getGaliLib() async{
    ref.reference().child("galiTextLib").once().then((DataSnapshot snapshot){
      userTagList.clear();
      if(snapshot.value !=null){
        Map<dynamic, dynamic> listTag = snapshot.value;

        listTag.forEach((key,value){


          GaliLibModel userModel = GaliLibModel.fromJson({
          'content' : value['content'],
          'type' : value['type'],
            'key': key
          });
          userTagList.add(userModel);
          userTagList.forEach((element) {
            type.add(element.type);
            result = type.toSet().toList();


          });
        });
        notifyListeners();
      }
    });

  }
}