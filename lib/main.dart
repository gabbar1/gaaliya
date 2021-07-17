import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gaaliya/providerState/providerState.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:flutter/material.dart' as textFont;
import 'helper/appUtils.dart';
import 'helper/googleCLientAPI.dart';
import 'helper/helper.dart';
import 'service/authService.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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
        navigatorObservers: [AppUtils().routeObserver],
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


        FirebaseDatabase.instance
            .reference()
            .child("user")
            .child(value.user.uid)
            .once()
            .then((DataSnapshot snapshot) async {
          if (snapshot.value == null) {


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
              "followers":0,
              "following":0


            });
          } else {

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