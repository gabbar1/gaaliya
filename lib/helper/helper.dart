import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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