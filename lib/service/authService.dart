

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaaliya/screens/dashboard/homeNavigator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class AuthService extends ChangeNotifier {
  AuthService();
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,spanshot){
          if(spanshot.hasData){
            return HomeNavigator();
          } else {
            return LoginPageWidget();
          }

        }
    );
  }

  signOut() async{
   await GoogleSignIn().disconnect();
   await FirebaseAuth.instance.signOut();
    notifyListeners();
  }





}