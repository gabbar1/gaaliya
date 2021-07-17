import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
<<<<<<< HEAD
=======
import 'package:flutter_spinkit/flutter_spinkit.dart';
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d
import 'package:gaaliya/providerState/providerState.dart';
import 'package:gaaliya/screens/dashboard/dashBoard.dart';
import 'package:gaaliya/screens/forceUpdate/forceUpdate.dart';
import 'package:gaaliya/screens/profile/profileView.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:flutter/material.dart' as textFont;
import 'helper/appUtils.dart';
import 'helper/helper.dart';
import 'service/authService.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
<<<<<<< HEAD

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
=======
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d

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
  // await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
<<<<<<< HEAD
      AndroidFlutterLocalNotificationsPlugin>()
=======
          AndroidFlutterLocalNotificationsPlugin>()
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
<<<<<<< HEAD
  runApp(MultiProvider(
    providers: ProviderState().providerList,
    child: MyApp(),
  ));
=======
  runApp(
    MultiProvider(
      providers: ProviderState().providerList,
      child: MaterialApp(
        home: MyApp(),
        navigatorObservers: [AppUtils().routeObserver],
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AnimationController _controller;
  var version = "1";
  var scaleAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 2000),
        vsync: this
    )
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation = new Tween(
      begin: 0.5,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut
    ));
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        message.data.forEach((key, value) {
          if (value['screen'] == 'ProfileView') {
            Navigator.pushNamed(context, '/message',
                arguments: ProfileView(currentUser: value['uid']));
          }
        });
      }
    });
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_action_notification_gali');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  importance: Importance.max,
                  priority: Priority.high),
            ));
      } else {
        print(android.channelId);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, 'ProfileView', arguments: App());
    });
    AuthService().handleAuth();
    FirebaseDatabase.instance
        .reference()
        .child("content")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthService().handleAuth()),
            (route) => false);
      }
    });

    FirebaseDatabase.instance.reference().child("version").once().then((DataSnapshot snapshot) {
      if(snapshot.value!=null){
        if(snapshot.value['version']==version){
          print("--------latestVersion----------");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AuthService().handleAuth()),
                  (route) => false);
          // return AuthService().handleAuth();
        } else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ForceUpdateView(snapshot.value['update'].toString(), snapshot.value['force'].toString(), snapshot.value['maintance'].toString() )),
                  (route) => false);

        }
      }
    });

//"assets/images/splashScreen.png"
  }
  final controller = PageController(viewportFraction: 0.8);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height:  MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/galiSplashScreen.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width/6.5,
              right: MediaQuery.of(context).size.width/6.5,
              child: Column(children: [Row(
                children: [
                  Image.asset("assets/icons/gaali.png"),
                  Spacer(),
                  Text(
                    "Gaaliya",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
                SizedBox(height: 30,),
                Container(
                child:SpinKitThreeBounce(controller: _controller,color: Color(0xFFE811FC),size: 30,duration: Duration(seconds: 1),) ,
              ),SizedBox(height: 50,),],))
        ],
      ),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isUserSignedIn = false;
  var postID;
  Future<UserCredential> signInWithGoogle() async {
    FirebaseDatabase.instance.reference().child("user").once().then((value) {
      postID =
          "GL_" + (value.value!=null ?value.value.length + 1 : 1).toString().padLeft(10, '0');
    });
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

<<<<<<< HEAD

=======
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d
        FirebaseDatabase.instance
            .reference()
            .child("user")
            .child(value.user.uid)
            .once()
            .then((DataSnapshot snapshot) async {
          if (snapshot.value == null) {

<<<<<<< HEAD

=======
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d
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
<<<<<<< HEAD
              "followers":0,
              "following":0


            });
          } else {

=======
              "followers": 0,
              "following": 0,
              "galiUserID": postID,
              "notificationID":value.user.uid+postID.toString().replaceAll("_", "")
            }).whenComplete(() async{
              //value.user.uid+postID.toString().replaceAll("_", "")
              await FirebaseMessaging.instance.subscribeToTopic(value.user.uid+postID.toString().replaceAll("_", ""));
            });
          } else{
            await FirebaseMessaging.instance.subscribeToTopic(snapshot.value["notificationID"].toString().replaceAll("_", ""));
>>>>>>> 8ef9d5bb9ffb6b5d66a728ff1ba286c3fed5bd5d
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
            image: DecorationImage(
          image: ExactAssetImage("assets/icons/background.png"),
          fit: BoxFit.cover,
        )),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Center(
                child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.5),
                    child: Text(
                      'Google Login',
                      style:
                          textFont.TextStyle(color: Colors.white, fontSize: 30),
                    ))),
            Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.5,
                        left: 20,
                        right: 20),
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                          Image.asset("assets/icons/google.png"),
                          Spacer(),
                          Text('Continue With Google'),
                          Spacer(),
                          Image.asset(
                            "assets/icons/google.png",
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
