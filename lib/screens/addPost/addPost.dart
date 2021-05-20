import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as container;
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/galiImages/galiImagesView.dart';
import 'package:gaaliya/screens/galiLib/galiLibView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/appengine/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AddPostView extends StatefulWidget {
  @override
  _AddPostViewState createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> addPostFormKey = new GlobalKey<FormState>();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  final ImagePicker _picker = ImagePicker();

  String uid;
  bool text = true;
  bool textHide = false;
  bool image = false;
  bool imageHide = false;
  bool video = false;
  bool gif = false;
  Color back = Color(0xFF313131);
  Offset offset = Offset.zero;
  bool isVisible = true;
  int font = 1;
  double fontSize = 20;
  String hint = "type gaali";
  bool isTextColorChange = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
  }

  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey imagekey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var postP = Provider.of<DashBoardProvider>(context, listen: false);
    return Consumer<GaliImageProvider>(builder: (context, imageLink, child) {
      return Scaffold(
          backgroundColor: back,
          body: InkWell(
            onTap: () {
              setState(() {
                imageHide = false;
                textHide = false;
                isVisible = true;
                isTextColorChange = false;
              });
            },
            child: RepaintBoundary(
              child: Screenshot(
                key: imagekey,
                controller: screenshotController,
                child: Stack(
                  children: [
                    container.Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: imageLink.imageLink != null
                            ?imageLink.imageLink.contains("https") ? BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageLink.imageLink),
                            fit: BoxFit.fitWidth,
                          ),
                        ) : BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(imageLink.imageLink)),
                            fit: BoxFit.fitWidth,
                          ),
                        )
                            : null
                    ),
                    Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            offset = Offset(offset.dx + details.delta.dx,
                                offset.dy + details.delta.dy);
                          });
                        },
                        child: container.Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3,
                              left: 50,
                              right: 50),
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            //  focusNode: _focusNode,
                            maxLines: 50,
                            onChanged: (val) {
                              setState(() {
                                isVisible = false;
                                isTextColorChange = true;
                              });
                            },
                            controller: controller,
                            style: font == 1
                                ? GoogleFonts.rokkitt(

                                color: Colors.white,
                                fontSize: fontSize)
                                : font == 2
                                ? GoogleFonts.specialElite(
                                fontStyle: FontStyle.italic,
                                fontSize: fontSize)
                                : font == 3
                                ? GoogleFonts.sofia(
                                fontStyle: FontStyle.italic,
                                fontSize: fontSize)
                                : font == 4
                                ? GoogleFonts.sofadiOne(
                                fontStyle: FontStyle.italic,
                                fontSize: fontSize)
                                : font == 5
                                ? GoogleFonts.signika(
                                fontStyle: FontStyle.italic,
                                fontSize: fontSize)
                                : font == 6
                                ? GoogleFonts.sevillana(
                                fontStyle:
                                FontStyle.italic,
                                fontSize: fontSize)
                                : GoogleFonts.rye(
                                fontStyle:
                                FontStyle.italic,
                                fontSize: fontSize),
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: hint),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "tr('field_required')";
                                //"Please enter valid floor number";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    isVisible
                        ? Positioned(
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisible = false;
                              hint = "";
                            });
                            FocusScope.of(context).unfocus();
                            Future.delayed(Duration(seconds: 1), () {
                              Provider.of<GaliImageProvider>(context,
                                  listen: false)
                                  .shareScreenshot(imagekey)
                                  .then((val) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditImage(
                                        text: controller.text,
                                      )),
                                );
                              });
                            });
                          },
                          child: Center(
                            child: container.Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    bottom: 25,
                                    left: 130,
                                    right: 130,
                                    top:
                                    MediaQuery.of(context).size.height -
                                        100),
                                height: 55,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF0ED2F7),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25))),
                                child: Container(
                                  child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                )),
                          ),
                        ))
                        : Container(),
                    isVisible
                        ? container.Container(
                        margin: EdgeInsets.only(
                            bottom: 25,
                            left:
                            MediaQuery.of(context).size.width / 2 + 150,
                            right: 20,
                            top: 45),
                        height: MediaQuery.of(context).size.height / 3,
                        child: container.Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height / 20,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  text = true;
                                  textHide = true;
                                  video = false;
                                  image = false;
                                  gif = false;
                                });
                              },
                              child: textHide == false
                                  ? SvgPicture.asset(
                                  "assets/icons/text.svg")
                                  : SvgPicture.asset(
                                "assets/icons/text.svg",
                                color: Colors.transparent,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  text = false;
                                  video = false;
                                  image = true;
                                  imageHide = true;
                                  gif = false;
                                });
                              },
                              child: imageHide == false
                                  ? SvgPicture.asset(
                                  "assets/icons/color.svg")
                                  : SvgPicture.asset(
                                "assets/icons/color.svg",
                                color: Colors.transparent,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GaliImagesView()),
                                );
                                setState(() {
                                  text = false;
                                  video = true;
                                  image = false;
                                  gif = false;
                                });
                              },
                              child: Image.asset("assets/icons/images.png"),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  text = false;
                                  video = false;
                                  image = false;
                                  gif = true;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GaliLibView()),
                                );
                              },
                              child: SvgPicture.asset(
                                  "assets/icons/gaaliya.svg"),
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.width / 20,
                            )
                          ],
                        ))
                        : Container(),
/*isVisible ?container.Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10,left: MediaQuery.of(context).size.width/15),child:
InkWell(
  onTap: () {
    setState(() {
        text = false;
        video = false;
        image = false;
        gif = true;
    });
  },
  child: Image.asset("assets/icons/emogi.png"),
),):Container(),*/

                    isVisible
                        ? Positioned(
                        top: MediaQuery.of(context).size.height / 11,
                        width: MediaQuery.of(context).size.width,
                        child: textHide != false
                            ? container.Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          height: 55,
                          decoration: BoxDecoration(
                              color: const Color(0xFF000000)
                                  .withOpacity(.5),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    font = 1;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_one.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    text = true;
                                    video = false;
                                    image = false;
                                    gif = false;
                                    font = 1;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_two.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    text = true;
                                    video = false;
                                    image = false;
                                    gif = false;
                                    font = 2;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_three.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    text = true;
                                    video = false;
                                    image = false;
                                    gif = false;
                                    font = 3;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_four.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    text = true;
                                    video = false;
                                    image = false;
                                    gif = false;
                                    font = 4;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_five.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    text = true;
                                    video = false;
                                    image = false;
                                    gif = false;
                                    font = 5;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_six.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    text = true;
                                    video = false;
                                    image = false;
                                    gif = false;
                                    font = 6;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/text_seven.png")),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    10,
                              )
                            ],
                          ),
                        )
                            : container.Container(
                          height: 55,
                        ))
                        : Container(),
                    isVisible
                        ? Positioned(
                        top: 100,
                        right: MediaQuery.of(context).size.width / 1.5,
                        child: Transform(
                          alignment: FractionalOffset.center,
                          // Rotate sliders by 90 degrees
                          transform: new Matrix4.identity()
                            ..rotateZ(270 * 3.1415927 / 180),
                          child: Slider(
                            value: fontSize,
                            onChanged: (double size) {
                              setState(() {
                                fontSize = size;
                              });
                            },
                            divisions: 10,
                            min: 10,
                            max: 60.0,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                          ),
                        ))
                        : Container(),
                    isVisible
                        ? Positioned(
                        top: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width,
                        child: imageHide != false
                            ? container.Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          height: 55,
                          decoration: BoxDecoration(
                              color: const Color(0xFF000000)
                                  .withOpacity(.5),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25))),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    back = Colors.green;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/color_one.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    back = Colors.orange;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/color_two.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    back = Colors.lightBlueAccent;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/color_three.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    back = Colors.lightGreen;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/color_four.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    back = Colors.yellow;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/color_five.png")),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    back = Colors.pinkAccent;
                                  });
                                },
                                child: Center(
                                    child: Image.asset(
                                        "assets/icons/color_six.png")),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    10,
                              )
                            ],
                          ),
                        )
                            : container.Container(
                          height: 55,
                        ))
                        : Container(),
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

class EditImage extends StatefulWidget {
  String text;
  EditImage({this.text});
  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GaliImageProvider>(
        builder: (context, imageLink, child) {
          return Stack(
            children: [
              container.Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: imageLink.pngBytes == null
                      ? imageLink.imageLink != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageLink.imageLink),
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : null
                      : BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(imageLink.capturedNewFile),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
              Positioned(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    onTap: () {

                      Provider.of<GaliImageProvider>(context, listen: false)
                          .uploadFileToGoogleDrive(
                              filename: imageLink.filename,
                              image: imageLink.capturedNewFile,
                              context: context,
                              uid: uid,
                              content: widget.text);
                    },
                    child: Center(
                      child: container.Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              bottom: 25,
                              left: 130,
                              right: 130,
                              top: MediaQuery.of(context).size.height - 100),
                          height: 55,
                          decoration: BoxDecoration(
                              color: const Color(0xFF0ED2F7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Container(
                            child: Center(
                                child: Text(
                              "Post",
                              style: TextStyle(color: Colors.white),
                            )),
                          )),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
