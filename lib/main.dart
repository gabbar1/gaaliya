import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/providerState/providerState.dart';
import 'package:gaaliya/screens/dashboard/homeNavigator.dart';
import 'package:gaaliya/service/authService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:flutter/material.dart' as textFont;

import 'helper/googleCLientAPI.dart';
import 'helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard/dashBoard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: ProviderState().providerList,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthService().handleAuth());
  }
}

class LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  bool isUserSignedIn = false;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    Random random = new Random();
    int randomNumber = random.nextInt(8);
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      if (value.user != null) {
        final googleSignIn =
            signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
        final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
        final authHeaders = await account.authHeaders;
        final authenticateClient = GoogleAuthClient(authHeaders);
        final driveApi = drive.DriveApi(authenticateClient);
        final SharedPreferences prefs = await _prefs;
        print("User account $account");
        FirebaseDatabase.instance
            .reference()
            .child("user")
            .child(value.user.uid)
            .once()
            .then((DataSnapshot snapshot) async {
          if (snapshot.value == null) {
            drive.File folderUpload = drive.File();
            folderUpload.mimeType = "application/vnd.google-apps.folder";
            folderUpload.name = "gaaliya";
            final folder = await driveApi.files.create(folderUpload);
            prefs.setString('folderID', folder.id);
            FirebaseDatabase.instance
                .reference()
                .child("user")
                .child(value.user.uid)
                .update({
              'userID': value.user.uid,
              'userEmail': value.user.email,
              'userPhone': value.user.phoneNumber,
              'userName': value.user.displayName,
              'profile': dummyProfilePicList[randomNumber],
              'folderID': folder.id
            });
          } else {
            prefs.setString('folderID', snapshot.value["folderID"]);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
    
    image:  DecorationImage(
    image: ExactAssetImage("assets/icons/background.png"),
    fit: BoxFit.cover,
    )),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Center(child: Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.5),child: Text('Google Login',style: textFont.TextStyle(color: Colors.white,fontSize: 30),))),
            Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(30))),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.5,
                        left: 20,
                        right: 20),
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: (){
                        signInWithGoogle();
                      },
                      child: Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width/15,),
                          Image.asset("assets/icons/google.png"),
                          Spacer(),
                          Text('Continue With Google'),
                          Spacer(),
                          Image.asset("assets/icons/google.png",color: Colors.transparent,),
                          SizedBox(width: MediaQuery.of(context).size.width/15,),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
