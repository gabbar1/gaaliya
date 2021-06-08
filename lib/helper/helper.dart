import 'dart:convert';
import 'dart:io';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

String addUnit = "ca-app-pub-3719084056205826/9305008098";//LiveMode
//String addUnit = "ca-app-pub-3940256099942544/8135179316";//TestMode
String dummyProfilePic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s';
String appFont = 'HelveticaNeuea';
List<String> dummyProfilePicList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzDG366qY7vXN2yng09wb517WTWqp-oua-mMsAoCadtncPybfQ&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq7BgpG1CwOveQ_gEFgOJASWjgzHAgVfyozkIXk67LzN1jnj9I&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPxjRIYT8pG0zgzKTilbko-MOv8pSnmO63M9FkOvfHoR9FvInm&s',
  'https://cdn5.f-cdn.com/contestentries/753244/11441006/57c152cc68857_thumb900.jpg',
  'https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg',
  'https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg',
];

void onLoading(
    {
      BuildContext
      context
      ,String strMessage}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // alignment: Alignment.center,
                //height: 100,
                //padding: EdgeInsets.only(left: 20, right: 20),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                // margin: EdgeInsets.only(bottom: 20),
              ),
              (strMessage != null)
                  ? Flexible(
                child: Text(
                  "",
                  //strMessage,
                  // maxLines: 2,
                  style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                flex: 1,
              )
                  : Container(),
            ],
          ),
        ),
      );
    },
  );
}

imageNetworkTap(
    {String imagePathAPI,
      double width,
      double height,
      BoxFit fit,
      Function ontap}) {
  return GestureDetector(
    onTap: () {
      ontap();
    },
    child: CachedNetworkImage(
        imageUrl: imagePathAPI,
        progressIndicatorBuilder: (context, url,
            downloadProgress) =>
            LinearProgressIndicator(
              value:
              downloadProgress.progress,backgroundColor: Colors.transparent,),
        errorWidget: (context, url, error) =>
            Icon(Icons.error_outline),
        width: width,
        height: height,
        fit: fit),

    /*Image.network(
      imagePathAPI,
      width: width,
      height: height,
      fit: fit,
    ),*/
  );
}


Widget plusButton({Function onTap}) {
  return Container(

    child: Container(
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            child: Image.asset(
              "assets/icons/ico_plus.png",

            ),
          ),
        )),
  );
}



Widget storyButton({Function onTap,String stories,BuildContext context}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      height: 10,width: MediaQuery.of(context).size.width/7,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(image: NetworkImage(stories),fit: BoxFit.fill),
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: EdgeInsets.only(left: 20, top: 20),

    ),
  );
}


class ImageFile extends ChangeNotifier{



  int type = 0;
  BuildContext context;
  String folder;
  File selectedImage;
  String strSelectedImage;
  final imagePicker = ImagePicker();
  CropAspectRatioPreset imageRatio;

  imageFileContainer({
    BuildContext buildContext,
    File imageFile,
    String placeholder,
    String mediaFolder,
    CropAspectRatioPreset aspectRatio,
    String strImage,

  }) {
    type = 2;
    context = buildContext;
    folder = mediaFolder;
    // selectedContainerImage = imageFile;
    imageRatio = aspectRatio;
    // strSelectedContainerImage = strImage;
//imageUploadRequest = ImageUploadRequest(imageResponseCallback);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          showImagePicker();
        },
        child: imageFile != null
            ? Image.file(imageFile)
            : strImage != null && strImage.isNotEmpty
            ? Image.network(
          strImage,
          fit: BoxFit.fill,
        )
            : SvgPicture.asset(
          placeholder,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  void showImagePicker({BuildContext context,int type}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(context: context,type :type);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context: context,type :type);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera({BuildContext context,int type}) async {
    final pickedFile = await imagePicker.getImage(
        source: ImageSource.camera,
        imageQuality: 90,
        maxHeight: 1024,
        maxWidth: 1024,
        preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      File croppedFile = await  ImageCropper.cropImage(sourcePath: pickedFile.path);
      Provider.of<GaliImageProvider>(context,listen: false).getImageLink(link: croppedFile.path);
      if(type == 2){
         Navigator.pop(context);
      }

    }
    notifyListeners();

  }

  _imgFromGallery({BuildContext context,int type}) async {
    final pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxHeight: 1024,
        maxWidth: 1024);
    if (pickedFile != null) {
      File croppedFile = await  ImageCropper.cropImage(sourcePath: pickedFile.path);
      Provider.of<GaliImageProvider>(context,listen: false).getImageLink(link: croppedFile.path);
      if(type == 2){
        Navigator.pop(context);
      }
      //Navigator.pop(context);
     // Navigator.pop(context);
    } else {
      print('No image selected.');
    }
    notifyListeners();

  }

  Future<void> sendNotification({subject, title, topic,uid}) async {

    String toParams = "/topics/" + topic;

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
        "uid":uid,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": "ProfileView",
      },
      "to": toParams
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAyV7RMCc:APA91bGYYFSlKtAmZSiplg2GuojDVdBzbjZlo5p9jymCPCGD-a8oqurY7WbuNx_UndhIQ_b4V3ktlHcCU2yyKwTqKcxINXR2opf_6j7cm6aCKnYo4yqTeVA1_mE1pe1_NCTcbPWWO28m'
    };

    final response = await http.post(Uri.https("fcm.googleapis.com", "fcm/send"),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do
      print("true");
    } else {
      // on failure do
      print("false");
    }
  }


}