import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
class ChooserUserID extends StatefulWidget {
  @override
  _ChooserUserIDState createState() => _ChooserUserIDState();
}

class _ChooserUserIDState extends State<ChooserUserID> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 80,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              style: material.TextStyle(color: material.Color(0xFFD8D6D9)),
              controller: nameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: material.TextStyle(
                      color: material.Color(0xFFD8D6D9)),
                  hintText: "Enter UserID",
                  fillColor: material.Color(0xFF312E34)),
            ),
          ),
          Container(
            height: 10,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              style: material.TextStyle(color: material.Color(0xFFD8D6D9)),
              controller: emailController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: material.TextStyle(
                      color: material.Color(0xFFD8D6D9)),
                  hintText: "Email",

                  fillColor: material.Color(0xFF312E34)),
            ),
          ),
          Container(
            height: 10,
          ),

          GestureDetector(
            onTap: (){
              print("------------FolderName-----------");
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              height: 70,
              width: MediaQuery.of(context).size.width/2,
              child: Center(child: Text("Update")),
            ),
          ),
        ],
      ),
    );
  }
}
