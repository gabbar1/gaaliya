import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:gaaliya/model/userModel.dart';
import 'package:gaaliya/screens/comments/commentProvider.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:gaaliya/screens/search/searchProvider.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

TextEditingController searchController = TextEditingController();

class _SearchViewState extends State<SearchView> {
  int startIndex = 10;
  ScrollController scrollController = new ScrollController();
  bool isLoading = false;
  static const _adUnitID = "ca-app-pub-3940256099942544/8135179316";
  final _nativeAdController = NativeAdmobController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).getGaliLib();
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
  List<UserModel> userList = <UserModel>[];
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
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
                        if (element.galiUserID.contains(searchTerms) || element.galiUserID.toLowerCase().contains(searchTerms) || element.galiUserID.toUpperCase().contains(searchTerms)||element.userName.contains(searchTerms) || element.userName.toLowerCase().contains(searchTerms) || element.userName.toUpperCase().contains(searchTerms)) {
                          userList.add(element);
                        }
                      });
                    });
                  },
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 12),
                    height: MediaQuery.of(context).size.height,
                    child: Container(

                      height: MediaQuery.of(context).size.height,
                      child:search.userTagList.length !=0 || userList.length != 0? ListView.builder(
                          itemCount: userList.length == 0 ? search.userTagList.length<10 ? search.userTagList.length :  startIndex +1 : userList.length ,
                          itemBuilder: (context, index) {
                            if(index == startIndex){
                              return   nextIndex(index,search);
                            } else{
                              return InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileView(currentUser: userList.length == 0
                                            ? search.userTagList[index].userID
                                            : userList[index].userID,currentUsername: userList.length == 0 ? search.userTagList[index].userName : userList[index].userName,)),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF37343B),
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
                                              ? search.userTagList[index].profile
                                              : userList[index].profile)
                                      ),
                                      SizedBox(width: 15,),
                                      Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,children: [Text(userList.length == 0
                                          ? search.userTagList[index].userName
                                          : userList[index].userName,style: TextStyle(color: Colors.white),),Text(userList.length == 0
                                          ? search.userTagList[index].galiUserID==null ? "noId":search.userTagList[index].galiUserID
                                          : userList[index].galiUserID==null ? "noId":userList[index].galiUserID ,style: TextStyle(color: Colors.grey,fontSize: 12),),],)

                                    ],
                                  ),
                                ),
                              );
                            }

                          })
                          : Center(child: Container(child: CircularProgressIndicator(strokeWidth: 20,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
                    )),

              ],
            ),
          ),
        );
      },


    );
  }

  nextIndex(int index, SearchProvider search) {
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
