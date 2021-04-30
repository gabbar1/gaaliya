import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as container;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:googleapis/adsense/v1_4.dart';
import 'package:googleapis/analytics/v3.dart';
import 'package:googleapis/run/v1.dart';
import 'package:provider/provider.dart';

class AddPostView extends StatefulWidget {
  @override
  _AddPostViewState createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> addPostFormKey = new GlobalKey<FormState>();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  String uid;
  bool text = true;
  bool image = false;
  bool video = false;
  bool gif = false;
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
    var postP = Provider.of<DashBoardProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: Color(0xFF313131),
        body: Stack(
          children: [
            Text("G"),
            container.Container(
              //  margin: EdgeInsets.only(bottom: 25, left: 15, right: 15),
              width:MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height,
                child: Row(
                  children: [],
                )),
            Positioned(
                width: MediaQuery.of(context).size.width,
                child: container.Container(
                    margin: EdgeInsets.only(
                        bottom: 25,
                        left: 15,
                        right: 15,
                        top: MediaQuery.of(context).size.height - 100),
                    height: 55,
                    decoration: BoxDecoration(
                        color: const Color(0xFF000000).withOpacity(.5),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              text =true;
                              video = false;
                              image = false;
                              gif = false;
                            });
                          },
                          child: Center(
                              child: Text(
                            "Text",
                            style: TextStyle(color: text!= false ? Colors.white: Colors.grey),
                          )),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              text =false;
                              video = false;
                              image = true;
                              gif = false;
                            });
                          },
                          child: Center(
                              child: Text(
                            "Image",
                            style: TextStyle(color:image!= false ? Colors.white: Colors.grey),
                          )),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              text =false;
                              video = true;
                              image = false;
                              gif = false;
                            });
                          },
                          child: Center(
                              child: Text(
                            "Video",
                            style: TextStyle(color: video!= false ? Colors.white: Colors.grey),
                          )),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            setState(() {
                              text =false;
                              video = false;
                              image = false;
                              gif = true;
                            });
                          },
                          child: Center(
                              child: Text(
                            "Gif",
                            style: TextStyle(color: gif!= false ? Colors.white: Colors.grey),
                          )),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                        )
                      ],
                    ))),
            container.Container(
                margin: EdgeInsets.only(
                    bottom: 25,
                    left: MediaQuery.of(context).size.width/2+150,
                    right: 20,
                    top: 45),
                height: MediaQuery.of(context).size.height/3,


                child: container.Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          text =true;
                          video = false;
                          image = false;
                          gif = false;
                        });
                      },
                      child: text!= false ? SvgPicture.asset("assets/icons/text.svg") : container.Container(
                          margin: EdgeInsets.only(left: 40),

                          child: Row(children: [Text("Hi"),Text("Hi"),Text("Hi"),Text("Hi"),Text("Hi")],)),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        setState(() {
                          text =false;
                          video = false;
                          image = true;
                          gif = false;
                        });
                      },
                      child: SvgPicture.asset("assets/icons/color.svg"),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        setState(() {
                          text =false;
                          video = true;
                          image = false;
                          gif = false;
                        });
                      },
                      child: Image.asset("assets/icons/images.png"),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        setState(() {
                          text =false;
                          video = false;
                          image = false;
                          gif = true;
                        });
                      },
                      child: SvgPicture.asset("assets/icons/gaaliya.svg"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 20,
                    )
                  ],
                )),

          ],
        ));
  }
}
