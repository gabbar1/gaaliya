import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/galiImageModel.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';

import 'package:gaaliya/service/minio.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:gaaliya/helper/googleCLientAPI.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker2/multi_image_picker2.dart';
class GaliImageProvider extends ChangeNotifier{

  List<GaliImageModel> listGaliImages = <GaliImageModel>[];
  List<GaliImageModel>    lst = <GaliImageModel>[];
  List<String> type = <String>[];
  String imageLink,filename;
  FirebaseDatabase ref = FirebaseDatabase();
  List result = [];
  List<Asset> resultList = <Asset>[];
   Uint8List pngBytes ;
  File capturedFile;
  File capturedNewFile;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> galiImages() async{
    ref.reference().child("galilib").once().then((DataSnapshot snapshot){
      listGaliImages.clear();
      type.clear();
      if(snapshot!=null){
       // print(snapshot.value);
        snapshot.value.forEach((key,val){
         // print(val);
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
      final thumbnail = copyResize(cropImage, width: 300,height:300,interpolation: Interpolation.average);

      // Save the thumbnail as a PNG.
      final String newFullPath = '$dir/${DateTime.now().millisecond}.png';
      await File(newFullPath).writeAsBytesSync(encodePng(thumbnail));
      capturedNewFile = File(newFullPath);
      print("--------------------");
      print(capturedFile);
      print(newFullPath);
      filename=newFullPath.split("/").last;
      notifyListeners();

    /*  await Share.file("G GATE Visitor Invitation", "Invitation.png", pngBytes,
          "image/png" //,
      );*/
    } catch (e) {
      print("Share Screenshot Error :: " + e.toString());
    }
  }

 /* Future<void> uploadFileToGoogleDrive({File image,String filename,content,BuildContext context, String type,name}) async {
    onLoading(context: context, strMessage: "Loading");
    final SharedPreferences prefs = await _prefs;
    final googleSignIn =


    print(image.path);
    File croppedFile = File(image.path);


    try
    {

      Provider.of<DashBoardProvider>(context,listen: false).sendPost(context: context,type: type,name:name,contentURL:"https://drive.google.com/uc?export=download&id="+result.id  );
      //Creating Permission after folder creation.
    }
    catch (Exception)
    {
      print("Error");
    }
  }*/

  Future<void> uploadProfileToGoogleDrive({String name,email,List<Asset> image,content,BuildContext context, String uid,String folder}) async {




    print("---------filePath-------------");
    print(image.length);

 for(int i =0;i<image.length;i++){

     showDialog(context: context, builder: (context){
       return AlertDialog(title: Text("Uploading"),actions: [CircularProgressIndicator()],);
     });
      print(image[i].identifier);
      var path = await FlutterAbsolutePath.getAbsolutePath(image[i].identifier);
      print(path);
      File croppedFile = File(path);
      var date = DateTime.fromMillisecondsSinceEpoch(1586348737122 * 1000);
      print("--------crop");
print(croppedFile);
print(date.toString()+croppedFile.path.split("/").last );

     /* try
      {
        const region = "us-west-1";
        final minio = Minio(
          endPoint: 's3.$region.wasabisys.com',
          accessKey: 'VHNW6XFKQEN0737H95SA',
          secretKey: 'InDRZ7LHJjPZyeoocGkDjVzPB4nc71ZNiykZKegZ',
        );
        Stream<List<int>> stream = new File(croppedFile.path).openRead();
        await minio.putObject('gaaliya-content',date.toString().replaceAll(".", "replace").replaceAll("-", "").replaceAll(":", "")+croppedFile.path.split("/").last , stream,100);
        final url = await minio.presignedGetObject('gaaliya-content', date.toString()+croppedFile.path.split("/").last,);
        print(url);

        Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(current: i,total: image.length,email:email,name:name,context: context,userID: uid,postContent:content,contentURL: date.toString().replaceAll(".", "replace").replaceAll("-", "").replaceAll(":", "")+croppedFile.path.split("/").last  );

        //Creating Permission after folder creation.
      }
      catch (Exception)
      {

      }*/

     try
     {
       const region = "us-west-1";
       final minio = Minio(
         endPoint: 's3.$region.wasabisys.com',
         accessKey: 'VHNW6XFKQEN0737H95SA',
         secretKey: 'InDRZ7LHJjPZyeoocGkDjVzPB4nc71ZNiykZKegZ',
       );
       Stream<List<int>> stream = new File(croppedFile.path).openRead();
       await minio.putObject('gaaliya',date.toString().replaceAll(".", "replace").replaceAll("-", "").replaceAll(":", "")+croppedFile.path.split("/").last , stream,100);
       final url = await minio.presignedGetObject('gaaliya', date.toString()+croppedFile.path.split("/").last,);
       print(url);

       Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(current: i,total: image.length,email:email,name:name,context: context,userID: uid,postContent:content,contentURL: date.toString().replaceAll(".", "replace").replaceAll("-", "").replaceAll(":", "")+croppedFile.path.split("/").last  );

       //Creating Permission after folder creation.
     }
     catch (Exception)
     {

     }
    };






  }
}