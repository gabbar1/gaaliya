import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/model/userModel.dart';
import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:googleapis/run/v1.dart';
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
      print(element.name);
      print(element.key);
      print(element.image);
      print(element.type);
    });
    return Scaffold(
      backgroundColor: material.Color(0xFF767680),
      body: Consumer<GaliImageProvider>(builder: (context, type, child) {
        print("--------------");
        print(type.lst);
        return material.Container(
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
              material.Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 5),
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
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
                              alignment: Alignment.center,
                              imageUrl:type.lst.isEmpty?  type.listGaliImages[index].image : type.lst[index].image,
                              fit: BoxFit.fill,
                            )),
                      );
                    }),
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
                                material.Color(0xFF000000).withOpacity(.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                            child: Center(
                              child: Text(
                                type.result[index],
                                style: material.TextStyle(color: Colors.white),
                              ),
                            ),
                          ),onTap: (){
                            print("Filter-----------");
                            setState(() {
                              type.lst=  type.listGaliImages.where((element) => element.type.contains(type.result[index])).toList();
                            });

                           print(type.lst.length);
                           print(type.result[index]);
                            print(type.listGaliImages.length);
                          },);
                        }),
                  ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Provider.of<ImageFile>(context, listen: false)
            .showImagePicker(context: context);
      }),
    );
  }
}
