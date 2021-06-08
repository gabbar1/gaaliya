import 'package:flutter/material.dart';
import 'package:gaaliya/model/userModel.dart';
import 'package:gaaliya/screens/follow/followProvider.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:provider/provider.dart';
class FollowView extends StatefulWidget {
  String uid;
  int follow ;
      FollowView({this.uid,this.follow});
  @override
  _FollowViewState createState() => _FollowViewState();
}

class _FollowViewState extends State<FollowView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.follow == 1 ?
    Provider.of<FollowProvider>(context,listen:false).following(uid: widget.uid) :
    Provider.of<FollowProvider>(context,listen:false).follower(uid: widget.uid);
  }
  String searchTerms = "";
  List<UserModel> userList = <UserModel>[];
  @override
  Widget build(BuildContext context) {
    return Consumer<FollowProvider>(
      builder: (context, search, child) {
        return SafeArea(child: Scaffold(
          backgroundColor: Color(0xFF232027),
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Stack(
              children: [
              Theme(data: ThemeData(primaryColor:Color(0xFF312E34) ), child:   TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(

                    border: new OutlineInputBorder(

                      borderRadius: const BorderRadius.all(
                        const Radius.circular(45.0),
                      ),
                    ),
                    prefixIcon: Padding(padding: EdgeInsets.only(left: 10,right: 0),child: Image.asset("assets/images/search.png"),),
                    hintText: "Search User",
                    hintStyle: TextStyle(color: Colors.white)),
                onChanged: (val) {
                  setState(() {
                    userList.clear();
                    searchTerms = val;
                    search.followList.forEach((element) {
                      if (element.userName.contains(searchTerms) ||
                          element.userName
                              .toLowerCase()
                              .contains(searchTerms) ||
                          element.userName
                              .toUpperCase()
                              .contains(searchTerms)) {
                        userList.add(element);
                      }
                    });
                  });
                },
              ),),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 10),
                    height: MediaQuery.of(context).size.height,
                    child: Container(

                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: userList.length == 0
                              ? search.followList.length
                              : userList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileView(currentUser: userList.length == 0
                                          ? search.followList[index].userID
                                          : userList[index].userID,currentUsername: userList.length == 0 ? search.followList[index].userName : userList[index].userName,)),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF312E34),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                margin: EdgeInsets.only(bottom: 5),
                                height: MediaQuery.of(context).size.height / 11,

                                child: Row(
                                  children: [
                                    SizedBox(width: 15,),
                                    CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(userList.length == 0
                                            ? search.followList[index].profile
                                            : userList[index].profile)
                                    ),
                                    SizedBox(width: 15,),
                                    Text(userList.length == 0
                                        ? search.followList[index].userName
                                        : userList[index].userName,style: TextStyle(color: Colors.white),),

                                  ],
                                ),
                              ),
                            );
                          }),
                    )),

              ],
            ),
          ),
        ));
      },
    );
  }
}
