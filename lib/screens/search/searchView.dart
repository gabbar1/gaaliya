import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/userModel.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:gaaliya/screens/search/searchProvider.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  String status;
  SearchView({this.status});
  @override
  _SearchViewState createState() => _SearchViewState();
}

TextEditingController searchController = TextEditingController();

class _SearchViewState extends State<SearchView> with SingleTickerProviderStateMixin {
  int startIndex = 10;
  ScrollController scrollController = new ScrollController();
  bool isLoading = false;

  final _nativeAdController = NativeAdmobController();
  String searchTerms = "";
  List<UserModel> userList = <UserModel>[];

  List<Widget> list = [
    Tab(
      text: "Image Library",
    ),
    Tab(
      text: "Users",
    )
  ];
  var _controller = ScrollController();
  static final double _height = 120;
  double _top = 0, _topList = _height;
  double _offsetA = 0, _offsetB = 0, _savedA = 0, _savedB = 0;
  var _tookA = false, _tookB = false, _fadeContainer = true;
  TabController tabController;
  int selectedIndex = 0;
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.uid = '';
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.uid = user.uid;
    tabController = TabController(
        length: list.length, vsync:this, initialIndex: selectedIndex);
    _controller.addListener(listener);
    Provider.of<GaliImageProvider>(context, listen: false).galiImages();
    Provider.of<GaliImageProvider>(context, listen: false).imageLink=null;
    tabController.addListener(() {});
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF232027),
      appBar: AppBar(  backgroundColor: Color(0xFF232027),bottom: TabBar(
        onTap: (index) {},
        controller: tabController,
        tabs: list,
      ),),
      body: TabBarView(controller: tabController,children: [Consumer<GaliImageProvider>(builder: (context,type,child){
        return Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Stack(
            children: [

              Positioned(top: _top,
              left: 0,
              right: 0,child:    Theme(
                  data: ThemeData(primaryColor:Color(0xFF312E34) ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(

                          border: new OutlineInputBorder(

                            borderRadius: const BorderRadius.all(
                              const Radius.circular(45.0),
                            ),
                          ),
                          prefixIcon: Padding(padding: EdgeInsets.only(left: 10,right: 0),child: SvgPicture.asset("assets/images/search.svg"),),
                          hintText: "Search Gaali",
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (val) {
                        setState(() {
                          type.lst.clear();
                          searchTerms = val;
                          type.listGaliImages.forEach((element) {
                            if (element.type.contains(searchTerms) ||
                                element.type
                                    .toLowerCase()
                                    .contains(searchTerms) ||
                                element.type
                                    .toUpperCase()
                                    .contains(searchTerms)) {
                              type.lst.add(element);
                            }
                          });
                        });
                      },
                    ),
              ),),
              Positioned( top: _topList,
                  left: 0,
                  right: 0,
                  bottom: 0,child: Container(
                height: MediaQuery.of(context).size.height,
                child:type.lst.length!=0 || type.listGaliImages.length!=0 ? ListView.separated(
                    controller: _controller,
                    itemCount:type.listGaliImages.length<10 ? type.lst.isEmpty ? type.listGaliImages.length:type.lst.length : startIndex+1,
                    separatorBuilder: (context,index){
                      if(index%10 == 0&& index !=0){
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
                        return nextImageIndex(index,type);
                      }else{
                        return GestureDetector(
                          onTap: (){
                            type.getImageLink(link: type.lst.isEmpty ? type.listGaliImages[index].image : type.lst[index].image);
                            widget.status != "1"?  Navigator.of(context).pop():null;
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                              height: MediaQuery.of(context).size.height / 3,
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>Container(
                                  child: Center(child: Container( height: 100.0,
                                    width: 100.0,child: CircularProgressIndicator(strokeWidth: 5,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
                                  height: 100.0,
                                  width: 100.0,
                                ),
                                alignment: Alignment.center,
                                imageUrl:type.lst.isEmpty?  type.listGaliImages[index].image : type.lst[index].image,
                                fit: BoxFit.fill,
                              )),
                        );
                      }
                    }) :Center(child: Container(child: CircularProgressIndicator(strokeWidth: 20,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
              )),
              Positioned(top: _top,
                  left: 0,
                  right: 0,child: Container(
                    margin: EdgeInsets.only(top: 70),
                    height: MediaQuery.of(context).size.height / 16,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: type.result.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(child: Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                color:
                                Color(0xFF312E34).withOpacity(.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                            child: Center(
                              child: Text(
                                type.result[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),onTap: (){

                            setState(() {
                              type.lst=  type.listGaliImages.where((element) => element.type.contains(type.result[index])).toList();
                            });

                          },);
                        }),
                  )),
              
            ],
          ),
        );
      }),Consumer<SearchProvider>(builder: (context,search,child){
        return Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                    prefixIcon: Padding(padding: EdgeInsets.only(left: 10,right: 0),child: SvgPicture.asset("assets/images/search.svg"),),
                    hintText: "Search User",
                    hintStyle: TextStyle(color: Colors.white)),
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
              ),),

              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 10),
                  height: MediaQuery.of(context).size.height,
                  child: Container(

                    height: MediaQuery.of(context).size.height,
                    child:search.userTagList.length !=0 || userList.length != 0? ListView.builder(
                        itemCount: userList.length == 0 ? search.userTagList.length<10 ? search.userTagList.length :  startIndex +1 : userList.length ,
                        itemBuilder: (context, index) {
                          if(index == startIndex){
                            return   nextIndex(index,search);
                          } else{
                            if(search.userTagList[index].userID !=uid)
                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileView(notificationID: search.userTagList[index].notificationID,currentUser: userList.length == 0
                                          ? search.userTagList[index].userID
                                          : userList[index].userID,currentUsername: userList.length == 0 ? search.userTagList[index].userName : userList[index].userName,)),
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
                            else
                              return Container();
                          }

                        })
                        : Center(child: Container(child: CircularProgressIndicator(strokeWidth: 20,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
                  )),

            ],
          ),
        );
      })],),
    );
  }
  void listener() {
    double offset = _controller.offset;

    _topList = _height - offset;
    if (_topList < 0) _topList = 0;

    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      _tookB = false;
      if (!_tookA) {
        _tookA = true;
        _offsetA = offset;
      }

      var difference = offset - _offsetA;
      _top = _savedB - difference;
      if (_top <= -_height) _top = -_height;
      _savedA = _top;
    } else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      _tookA = false;
      if (!_tookB) {
        _tookB = true;
        _offsetB = offset;
      }

      var difference = offset - _offsetB;
      _top = _savedA - difference;
      if (_top >= 0) _top = 0;
      _savedB = _top;
    }

    setState(() {});
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

  nextImageIndex(int index, GaliImageProvider post) {
    if (startIndex < post.listGaliImages.length) {
      if (startIndex + 10 >=  post.listGaliImages.length) {
        var lastIndex =
            post.listGaliImages.length - index;
        startIndex = index + lastIndex;
        Future.delayed(Duration(seconds: 5));

      } else {
        startIndex = index + 10;
      }}}}

