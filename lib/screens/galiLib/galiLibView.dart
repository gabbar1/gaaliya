import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaaliya/model/userModel.dart';

import 'package:provider/provider.dart';

import 'galiLibProvider.dart';

class GaliLibView extends StatefulWidget {
  @override
  _GaliLibViewState createState() => _GaliLibViewState();
}

TextEditingController searchController = TextEditingController();

class _GaliLibViewState extends State<GaliLibView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GaliLibProvider>(context, listen: false).getGaliLib();
  }

  String searchTerms = "";
  List<UserModel> userList = <UserModel>[];
  @override
  Widget build(BuildContext context) {
    return Consumer<GaliLibProvider>(
      builder: (context, search, child) {
        return Scaffold(
          backgroundColor: Color(0xFF767680),
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Stack(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(25.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                      hintText: "Search Gali"),
                  onChanged: (val) {
                    setState(() {
                      userList.clear();
                      searchTerms = val;
                      search.userTagList.forEach((element) {
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
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5),
                    height: MediaQuery.of(context).size.height,
                    child: Container(

                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: userList.length == 0
                              ? search.userTagList.length
                              : userList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF37343B),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                              margin: EdgeInsets.only(bottom: 5),
                              height: MediaQuery.of(context).size.height / 11,

                              child: Row(
                                children: [
                                  SizedBox(width: 15,),
                                  Text(userList.length == 0
                                      ? search.userTagList[index].userName
                                      : userList[index].userName,style: TextStyle(color: Colors.white),),
                                  Spacer(),
                                  InkWell(onTap: (){
                                    Clipboard.setData(ClipboardData(text:userList.length == 0
                                        ? search.userTagList[index].userName
                                        : userList[index].userName )).then((value) {
                                          Fluttertoast.showToast(msg: "gaali copied");
                                    });
                                  },child: Image.asset("assets/icons/ico_copy.png")),
                                  SizedBox(width: 15,)
                                ],
                              ),
                            );
                          }),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 10),
                  height: MediaQuery.of(context).size.height / 16,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: search.result.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                color: Color(0xFF000000).withOpacity(.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                            child: Center(
                              child: Text(
                                search.result[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            print("Filter-----------");
                            setState(() {
                              userList= search.userTagList
                                  .where((element) => element.userName
                                  .contains(search.result[index]))
                                  .toList();
                            });
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
