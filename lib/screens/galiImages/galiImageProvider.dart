import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/galiImageModel.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/service/minio.dart';
import 'package:image/image.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:gaaliya/helper/googleCLientAPI.dart';
import 'package:http/http.dart' as http;


class GaliImageProvider extends ChangeNotifier{

  List<GaliImageModel> listGaliImages = <GaliImageModel>[];
  List<GaliImageModel>    lst = <GaliImageModel>[];
  List<String> type = <String>[];
  String imageLink,filename;
  FirebaseDatabase ref = FirebaseDatabase();
  List result = [];
   Uint8List pngBytes ;
  File capturedFile;
  File capturedNewFile;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> galiImages() async{
    ref.reference().child("galilib").once().then((DataSnapshot snapshot){
      listGaliImages.clear();
      type.clear();
      if(snapshot!=null){
        snapshot.value.forEach((key,val){
          GaliImageModel listGaliImage = GaliImageModel.fromJson({
            'image':val['image'],
            'name':val['name'],
            'type':val['type'],
            'key':key
          });
          listGaliImages.add(listGaliImage);
          listGaliImages.forEach((element) {
            type.add(element.type);
            result = type.toSet().toList();


          });
          notifyListeners();
        });



      }
    });
  }

  void getImageLink({String link}){
    this.imageLink = link;
    notifyListeners();
  }

  Future<void> shareScreenshot(
      GlobalKey _globalKey,
      ) async {
    try {
      //extract bytes
      final RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData.buffer.asUint8List();
       String dir = (await getApplicationDocumentsDirectory()).path;

      final String fullPath = '$dir/${DateTime.now().millisecond}.png';

       capturedFile = File(fullPath);

      await capturedFile.writeAsBytes(pngBytes);

      capturedFile = File(fullPath);

      final cropImage = decodeImage(File(fullPath).readAsBytesSync());

      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      final thumbnail = copyResize(cropImage, width: 300,interpolation: Interpolation.average);

      // Save the thumbnail as a PNG.
      final String newFullPath = '$dir/${DateTime.now().millisecond}.png';
      await File(newFullPath).writeAsBytesSync(encodePng(thumbnail));
      capturedNewFile = File(newFullPath);
      filename=newFullPath.split("/").last;
      notifyListeners();


    } catch (e) {
      print("Share Screenshot Error :: " + e.toString());
    }
  }

  Future<void> uploadFileToGoogleDrive({File image,String filename,content,BuildContext context, String uid}) async {
    onLoading(context: context, strMessage: "Loading");

    File croppedFile = File(image.path);
    var date = DateTime.fromMillisecondsSinceEpoch(1586348737122 * 1000);
    var newFileName = filename+date.toString()+"jpg";
    try {
      const region = "us-west-1";
      final minio = Minio(
        endPoint: 's3.$region.wasabisys.com',
        accessKey: 'VHNW6XFKQEN0737H95SA',
        secretKey: 'InDRZ7LHJjPZyeoocGkDjVzPB4nc71ZNiykZKegZ',
      );
      Stream<List<int>> stream = new File(croppedFile.path).openRead();
      await minio.putObject('gaaliya',filename+croppedFile.path.split("/").last , stream,100);
      final url = await minio.presignedGetObject('gaaliya', filename+croppedFile.path.split("/").last,);
      Provider.of<DashBoardProvider>(context,listen: false).sendPost(context: context,userID: uid,postContent:content,contentURL:filename+croppedFile.path.split("/").last );
      print(url);

    }

    catch(Exception){
      print(Exception);
    }

  }

  Future<void> uploadProfileToGoogleDrive({String galiUserID,name,email,File image,String filename,content,BuildContext context, String uid,String folder}) async {
    onLoading(context: context, strMessage: "Loading");

    File croppedFile = File(image.path);

    try {
      const region = "us-west-1";
      final minio = Minio(
        endPoint: 's3.$region.wasabisys.com',
        accessKey: 'VHNW6XFKQEN0737H95SA',
        secretKey: 'InDRZ7LHJjPZyeoocGkDjVzPB4nc71ZNiykZKegZ',
      );
      Stream<List<int>> stream = new File(croppedFile.path).openRead();
      await minio.putObject('gaaliya',filename+croppedFile.path.split("/").last , stream,100);
      final url = await minio.presignedGetObject('gaaliya', filename+croppedFile.path.split("/").last,);
      Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(galiUserID: galiUserID,email:email,name:name,context: context,userID: uid,postContent:content,contentURL:filename+croppedFile.path.split("/").last  );
      //Provider.of<DashBoardProvider>(context,listen: false).sendPost(context: context,userID: uid,postContent:content,contentURL:filename+croppedFile.path.split("/").last );
      print(url);

    }

    catch(Exception){
      print(Exception);
    }

  }
  bool userExist = false;
   checkUserID({BuildContext context,String galiUserID}) async{
    FirebaseDatabase.instance.reference().child('user').once().then((DataSnapshot snapshot){
      if(snapshot.value!=null){
        Map<dynamic, dynamic> listPost = snapshot.value;
        listPost.forEach((key, value) {
          if(value['galiUserID'] == galiUserID){
           showDialog(context: context, builder: (BuildContext context){
             return AlertDialog(title: Text("User Already Taken"),);
           });
          }
        });

      }
    });
    return userExist;
  }
}