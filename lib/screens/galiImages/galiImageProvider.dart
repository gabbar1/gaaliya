import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
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
      final thumbnail = copyResize(cropImage, width: 300,height: 300,interpolation: Interpolation.average);

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

  Future<void> uploadFileToGoogleDrive({File image,String filename,content,BuildContext context, String uid}) async {
    onLoading(context: context, strMessage: "Loading");
    final SharedPreferences prefs = await _prefs;
    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    print("User account $account");

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);


    File croppedFile = File(image.path);
    drive.File fileUpload = drive.File();
    drive.Permission per = drive.Permission();
    per.type = "anyone";
    per.role = "reader";
    fileUpload.name = filename;
    fileUpload.parents = [prefs.getString("folderID")];
    print(prefs.getString("folderID"));
    final result = await driveApi.files.create(fileUpload, uploadMedia: drive.Media(croppedFile.openRead(),croppedFile.lengthSync()),);
    try
    {
      driveApi.permissions.create(per, result.id);
      print("00000000000000000000000000000000000");
      print(result.id);
      print("https://drive.google.com/uc?export=download&id="+result.id);
      Provider.of<DashBoardProvider>(context,listen: false).sendPost(context: context,userID: uid,postContent:content,contentURL:"https://drive.google.com/uc?export=download&id="+result.id  );
      //Creating Permission after folder creation.
    }
    catch (Exception)
    {
      print("Error");
    }
  }

  Future<void> uploadProfileToGoogleDrive({String name,email,File image,String filename,content,BuildContext context, String uid,String folder}) async {
    onLoading(context: context, strMessage: "Loading");
    final SharedPreferences prefs = await _prefs;
    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    print("User account $account");

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    print("---------filePath-------------");
    print(image.path);
    File croppedFile = File(image.path);
    drive.File fileUpload = drive.File();
    drive.Permission per = drive.Permission();
    per.type = "anyone";
    per.role = "reader";
    fileUpload.name = filename;
    print(folder);
    final result = await driveApi.files.create(fileUpload, uploadMedia: drive.Media(croppedFile.openRead(),croppedFile.lengthSync()),);
    try
    {
      driveApi.permissions.create(per, result.id);
      print("00000000000000000000000000000000000");
      print(result.id);
      print("https://drive.google.com/uc?export=download&id="+result.id);
      Provider.of<DashBoardProvider>(context,listen: false).sendProfilePost(email:email,name:name,context: context,userID: uid,postContent:content,contentURL:"https://drive.google.com/uc?export=download&id="+result.id  );
      //Creating Permission after folder creation.
    }
    catch (Exception)
    {
      print("Error");
    }
  }
}