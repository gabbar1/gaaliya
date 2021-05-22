import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/comments/commentProvider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentView extends StatefulWidget {
  final String postID,userID;
  CommentView({this.postID,this.userID});
  @override
  _CommentViewState createState() => _CommentViewState();
}

DatabaseReference transRef = FirebaseDatabase.instance.reference();

class _CommentViewState extends State<CommentView> {
  List words = [];
  String str = '';
  List<String> coments=[];
  RefreshController refreshController;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  DatabaseReference transRef = FirebaseDatabase.instance.reference();
  List<String> tag = ["Ayush","Abhishek","Vivek"];
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CommentProvider>(context, listen: false).getCommentList(postID: widget.postID);
    Provider.of<CommentProvider>(context, listen: false).UserTag();
    Provider.of<CommentProvider>(context, listen: false).commentList.clear();
    refreshController = RefreshController(initialRefresh: false);
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment"),
      ),
      body: Consumer<CommentProvider>(builder: (context, commentList, child) {
        return Column(
          children: [
            Flexible(
                child: ListView.builder(
                    itemCount: commentList.commentList.length,
                    itemBuilder: (context, comment) {

                      return ListTile(
                        title: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: ClipOval(
                                child: StreamBuilder<Event>(
                                    stream: FirebaseDatabase.instance
                                        .reference()
                                        .child("user")
                                        .child(uid)
                                        .onValue,
                                    builder: (BuildContext context, snap) {
                                      if (snap.data != null) {
                                        return imageNetworkTap(
                                            ontap: () {},
                                            imagePathAPI: snap
                                                .data.snapshot.value['profile'],
                                            fit: BoxFit.fill,
                                            height: 40,
                                            width: 40);
                                      } else {
                                        return imageNetworkTap(
                                            ontap: () {},
                                            imagePathAPI:
                                                "https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg",
                                            fit: BoxFit.fill,
                                            height: 40,
                                            width: 40);
                                      }
                                    }),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  StreamBuilder<Event>(
                                      stream: FirebaseDatabase.instance
                                          .reference()
                                          .child("user")
                                          .child(uid)
                                          .onValue,
                                      builder: (BuildContext context, snap) {
                                        if (snap.data != null) {
                                          return Text(
                                              snap.data.snapshot.value['userName']);
                                        } else {
                                          return Text("user....");
                                        }
                                      }),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  Text(commentList.commentList[comment].comment,maxLines: 50, style: TextStyle(fontSize: 10.0 ,fontWeight:FontWeight.bold,color: Colors.black) , ),
                                ],
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Container(
                                height: 15,
                                width: 15,
                                child: FutureBuilder<Event>(
                                  future: FirebaseDatabase.instance
                                      .reference()
                                      .child("likes")
                                      .child(uid)
                                      .child(commentList.commentList[comment].postID.toString()).child(commentList.commentList[comment].key)
                                      .child("likes")
                                      .onValue
                                      .first,
                                  builder: (BuildContext context, snap) {
                                    if (snap.connectionState !=
                                        ConnectionState.done) {

                                      return SvgPicture.asset(
                                          "assets/icons/beforeLike.svg");
                                    } else {
                                      if (snap.hasError) {
                                        return SvgPicture.asset(
                                            "assets/icons/beforeLike.svg");
                                      } else {
                                        if (snap.data.snapshot.value != null) {
                                          return SvgPicture.asset(
                                              "assets/icons/afterLike.svg");
                                        } else {
                                          return SvgPicture.asset(
                                              "assets/icons/beforeLike.svg");
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                              onTap: () {

                                commentList
                                    .setCommentLikes(
                                        postID: commentList
                                            .commentList[comment].postID,
                                        uid: uid,
                                        node: commentList
                                            .commentList[comment].key,
                                        like: commentList
                                            .commentList[comment].likes)
                                    .then((value) => commentList.getCommentList(
                                        postID: widget.postID));
                              },
                            )
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            SizedBox(
                              width: 50,
                            ),
                            DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inSeconds <=
                                    60
                                ? Text(DateTime.now()
                                        .difference(DateTime.parse(commentList
                                            .commentList[comment].time))
                                        .inSeconds
                                        .toString() +
                                    " sec")
                                : DateTime.now()
                                            .difference(DateTime.parse(
                                                commentList
                                                    .commentList[comment].time))
                                            .inMinutes <=
                                        60
                                    ? Text(DateTime.now()
                                            .difference(
                                                DateTime.parse(commentList.commentList[comment].time))
                                            .inMinutes
                                            .toString() +
                                        " min")
                                    : DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inHours <= 24
                                        ? Text(DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inHours.toString() + " hrs")
                                        : DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inDays <= 365
                                            ? Text(DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inDays.toString() + " days")
                                            : DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inDays == 1
                                                ? Text("today")
                                                : DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inDays == 2
                                                    ? Text("Yesterday")
                                                    : Text(DateTime.now().difference(DateTime.parse(commentList.commentList[comment].time)).inDays.toString() + "day"),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Likes"),
                            SizedBox(
                              width: 5,
                            ),
                            Text(commentList.commentList[comment].likes
                                .toString())
                          ],
                        ),
                      );
                    })),
            Container(height: 50
              ,child:  str.length > 1
                ? ListView(
                shrinkWrap: true,
                children: commentList.userTagList.map((s){

                  if(('@' + s.userName).contains(str))
                    return
                      ListTile(
                          title:Text(s.userName,style: TextStyle(color: Colors.black),),
                          onTap:(){
                            String tmp = str.substring(1,str.length);
                            setState((){
                              str ='';
                              textEditingController.text += s.userName.substring(s.userName.indexOf(tmp)+tmp.length,s.userName.length).replaceAll(' ','_');
                            });
                          });
                  else return SizedBox();
                }).toList()
            ):SizedBox(),),
            Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            words = val.split(' ');
                            str = words.length > 0 &&
                                words[words.length - 1].startsWith('@')
                                ? words[words.length - 1]
                                : '';
                          });
                        },
                        onSubmitted: (value) {
                          commentList.omSendComment(postID:widget.postID,userID: widget.userID,comment: textEditingController.text, );
                          textEditingController.clear();

                        },
                        style:
                            TextStyle(color: Color(0xff9E81BE), fontSize: 15.0),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: '         Type your comment...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        focusNode: focusNode,
                      ),
                    ),
                  ),
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          commentList.omSendComment(postID:widget.postID,userID: widget.userID,comment: textEditingController.text, );
                          textEditingController.clear();

                        } ,
                        color: Color(0xff9E81BE),
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                  color: Colors.white),
            )
          ],
        );
      }),
    );
  }

}
