import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/galiLibModel.dart';
import 'package:provider/provider.dart';
import 'galiLibProvider.dart';

class GaliLibView extends StatefulWidget {
  @override
  _GaliLibViewState createState() => _GaliLibViewState();
}

TextEditingController searchController = TextEditingController();

class _GaliLibViewState extends State<GaliLibView> {
  int startIndex = 10;
  ScrollController scrollController = new ScrollController();
  bool isLoading = false;

  final _nativeAdController = NativeAdmobController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GaliLibProvider>(context, listen: false).getGaliLib();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
      }
    });
  }

  String searchTerms = "";
  List<GaliLibModel> userList = <GaliLibModel>[];
  @override
  Widget build(BuildContext context) {
    return Consumer<GaliLibProvider>(
      builder: (context, search, child) {
        return Scaffold(
          backgroundColor: Color(0xFF232027),
          body: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Stack(
              children: [
                Theme(
                  data: ThemeData(primaryColor:Color(0xFF312E34) ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(

                        border: new OutlineInputBorder(

                          borderRadius: const BorderRadius.all(
                            const Radius.circular(45.0),
                          ),
                        ),
                        prefixIcon: Padding(padding: EdgeInsets.only(left: 10,right: 0),child: Image.asset("assets/images/search.png"),),
                        hintText: "Search Gaali",
                        hintStyle: TextStyle(color: Colors.white)),
                    onChanged: (val) {
                      setState(() {
                        userList.clear();
                        searchTerms = val;
                        search.userTagList.forEach((element) {
                          if (element.content.contains(searchTerms) ||
                              element.content
                                  .toLowerCase()
                                  .contains(searchTerms) ||
                              element.content
                                  .toUpperCase()
                                  .contains(searchTerms)) {
                            userList.add(element);
                          }
                        });
                      });
                    },
                  ),
                ),

                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 6),
                    height: MediaQuery.of(context).size.height,
                    child: Container(

                      height: MediaQuery.of(context).size.height,
                      child: userList.length != 0 || search.userTagList.length!=0 ? ListView.separated(
                          itemCount: userList.length == 0 ? search.userTagList.length<10 ? search.userTagList.length : startIndex+1 : userList.length,
                          separatorBuilder: (context,index){
                            if(index%10 == 0&&index !=0){
                              return Container(
                                height: 330,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: NativeAdmob(
                                  // Your ad unit id
                                  adUnitID: addUnit,
                                  numberAds: 3,
                                  controller: _nativeAdController,
                                  type: NativeAdmobType.full,
                                ),
                              );
                            } else{
                              return Container();
                            }
                          },
                          itemBuilder: (context, index) {
                            if(index == startIndex){
                              return nextIndex(index, search);
                            } else{
                              return Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF37343B),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                                margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              //  height: MediaQuery.of(context).size.height / 11,

                                child: Row(
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10,bottom: 10),
                                        child: Text(userList.length == 0
                                            ? search.userTagList[index].content
                                            : userList[index].content,style: TextStyle(color: Colors.white),),
                                      ),
                                    ),

                                    InkWell(onTap: (){
                                      Clipboard.setData(ClipboardData(text:userList.length == 0
                                          ? search.userTagList[index].content
                                          : userList[index].content )).then((value) {
                                        Fluttertoast.showToast(msg: "gaali copied");
                                      });
                                    },child: Image.asset("assets/icons/ico_copy.png")),
                                    SizedBox(width: 15,)
                                  ],
                                ),
                              );
                            }


                          }): Center(child: Container(child: CircularProgressIndicator(strokeWidth: 20,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
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

                            setState(() {
                              userList= search.userTagList.where((element) => element.type.contains(search.result[index])).toList();
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

  nextIndex(int index, GaliLibProvider search) {
    if (startIndex < search.userTagList.length) {
      if (startIndex + 10 >=  search.userTagList.length) {
        var lastIndex =
            search.userTagList.length - index;
        startIndex = index + lastIndex;
        Future.delayed(Duration(seconds: 5));

      } else {
        startIndex = index + 10;
      }
    }
  }
}
