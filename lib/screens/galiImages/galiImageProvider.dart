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
import 'package:image/image.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:gaaliya/helper/googleCLientAPI.dart';


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
    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();


    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);


    File croppedFile = File(image.path);
    drive.File fileUpload = drive.File();
    drive.Permission per = drive.Permission();
 // "AIzaSyCkG0nakHWX67p4iBmVKTRtemkh41btSB8"
    per.type = "anyone";
    per.role = "reader";
    fileUpload.name = filename;
  /*  fileUpload.parents = [prefs.getString("folderID")];
    */
    final result = await driveApi.files.create(fileUpload, uploadMedia: drive.Media(croppedFile.openRead(),croppedFile.lengthSync()),);
    try
    {
      driveApi.permissions.create(per, result.id);
      var googleURL = "https://www.googleapis.com/drive/v3/files/";
      var exportURL = "?alt=media&key=";
      var api = "AIzaSyCkG0nakHWX67p4iBmVKTRtemkh41btSB8";
      var finalURL = googleURL+result.id+exportURL+api;
      Provider.of<DashBoardProvider>(context,listen: false).sendPost(context: context,userID: uid,postContent:content,contentURL:finalURL );
      //Creating Permission after folder creation.
    }
    catch (Exception)
    {
      print("Error");
    }
  }

  Future<void> uploadProfileToGoogleDrive({String galiUserID,name,email,File image,String filename,content,BuildContext context, String uid,String folder}) async {
    onLoading(context: context, strMessage: "Loading");
    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();


    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    File croppedFile = File(image.path);
    drive.File fileUpload = drive.File();
    drive.Permission per = drive.Permission();
    per.type = "anyone";
    per.role = "reader";
    fileUpload.name = filename;

    final result = await driveApi.files.create(fileUpload, uploadMedia: drive.Media(croppedFile.openRead(),croppedFile.lengthSync()),);

    try
    {
      driveApi.permissions.create(per, result.id);

      var googleURL = "https://www.googleapis.com/drive/v3/files/";
      var exportURL = "?alt=media&key=";
      var api = "AIzaSyCkG0nakHWX67p4iBmVKTRtemkh41btSB8";
      var finalURL = googleURL+result.id+exportURL+api;

      //"https://www.googleapis.com/drive/v3/files/1IvtWn9HktActV-IiV2gUMTiNH0mM6RxF?alt=media&key=AIzaSyCkG0nakHWX67p4iBmVKTRtemkh41btSB8"

      Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(galiUserID: galiUserID,email:email,name:name,context: context,userID: uid,postContent:content,contentURL:finalURL  );
      //Creating Permission after folder creation.
    }
    catch (Exception)
    {
      print("Error");
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