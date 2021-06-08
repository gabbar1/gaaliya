import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:provider/provider.dart';

class GaliImagesView extends StatefulWidget {
  @override
  _GaliImagesViewState createState() => _GaliImagesViewState();
}

class _GaliImagesViewState extends State<GaliImagesView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GaliImageProvider>(context, listen: false).galiImages();
    Provider.of<GaliImageProvider>(context, listen: false).imageLink=null;
  }
  String searchTerms = "";


  @override
  Widget build(BuildContext context) {
    Provider.of<GaliImageProvider>(context, listen: false)
        .listGaliImages
        .forEach((element) {

    });
    return SafeArea(child: Scaffold(
      backgroundColor: Color(0xFF232027),
      body: Consumer<GaliImageProvider>(builder: (context, type, child) {

        return material.Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 5, left: 10, right: 10),
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
              ),

              material.Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5),
                height: MediaQuery.of(context).size.height,
                child:type.lst.length!=0 || type.listGaliImages.length!=0 ? ListView.builder(
                    itemCount:type.lst.isEmpty ? type.listGaliImages.length:type.lst.length,
                    itemBuilder: (context, index) {

                      return GestureDetector(
                        onTap: (){
                          type.getImageLink(link: type.lst.isEmpty ? type.listGaliImages[index].image : type.lst[index].image);
                          Navigator.of(context).pop();
                        },
                        child: material.Container(
                            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                            height: MediaQuery.of(context).size.height / 3,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>material.Container(
                                child: Center(child: material.Container( height: 100.0,
                                  width: 100.0,child: CircularProgressIndicator(strokeWidth: 5,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
                                height: 100.0,
                                width: 100.0,
                              ),
                              alignment: Alignment.center,
                              imageUrl:type.lst.isEmpty?  type.listGaliImages[index].image : type.lst[index].image,
                              fit: BoxFit.fill,
                            )),
                      );
                    }) :Center(child: material.Container(child: CircularProgressIndicator(strokeWidth: 20,backgroundColor: Colors.grey,valueColor: AlwaysStoppedAnimation(Colors.blue),),)),
              ),
              material.Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10),
                height: MediaQuery.of(context).size.height / 16,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: type.result.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(child: material.Container(
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
                            style: material.TextStyle(color: Colors.white),
                          ),
                        ),
                      ),onTap: (){

                        setState(() {
                          type.lst=  type.listGaliImages.where((element) => element.type.contains(type.result[index])).toList();
                        });

                      },);
                    }),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Provider.of<ImageFile>(context, listen: false)
            .showImagePicker(context: context,type: 2);
      }),
    ));
  }
}
