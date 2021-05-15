import 'package:flutter/material.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).getGaliLib();
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
                        top: MediaQuery.of(context).size.height / 10),
                    height: MediaQuery.of(context).size.height,
                    child: Container(

                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: userList.length == 0
                              ? search.userTagList.length
                              : userList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileView(currentUser: userList.length == 0
                                          ? search.userTagList[index].userID
                                          : userList[index].userID,)),
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
                                    Text(userList.length == 0
                                        ? search.userTagList[index].userName
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
        );
      },
    );
  }
}
