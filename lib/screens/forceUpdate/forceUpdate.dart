import 'package:flutter/material.dart';
import 'package:gaaliya/service/authService.dart';
import 'package:launch_review/launch_review.dart';


class ForceUpdateView extends StatefulWidget {
  String updateRequired;
  String forceUpdate;
  String maintenance;

  ForceUpdateView(this.updateRequired, this.forceUpdate, this.maintenance);

  @override
  ForceUpdateViewState createState() => ForceUpdateViewState();
}

class ForceUpdateViewState extends State<ForceUpdateView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return;
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (widget.maintenance == "0")
                      ? Image.asset("assets/images/img_force_update.png")
                      : Image.asset("assets/images/img_maintenance.png"),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    (widget.maintenance == "0")
                        ? "Time To Update !"
                        : "Under Maintenance",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    (widget.maintenance == "0")
                        ? "We have added lots of new features and improved our existing app to make your experience better and smooth as possible."
                        : "We appreciate your patience for our maintenance work. We will be back soon.\nRegards,\nGGATE Team.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0),
                  ),
                  (widget.maintenance == "0")
                      ? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {

                        LaunchReview.launch(
                          androidAppId: "com.boss.gaaliya",
                        );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                              color: Color(0xFF5458F7),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Update Now",
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      (widget.forceUpdate == "0")
                          ? GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AuthService().handleAuth()),
                                  (route) => false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                                color: Colors.amberAccent, fontSize: 15.0),
                          ),
                        ),
                      )
                          : Container()
                    ],
                  )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




}
