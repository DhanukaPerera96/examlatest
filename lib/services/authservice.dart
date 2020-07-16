import 'package:educationapp/homepage.dart';
import 'package:educationapp/loginui/login_screen.dart';
import 'package:educationapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService{


  //Handles Auth

  handleAuth(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData)
          {
            return HomePage();
          }
        else{
          return MySplashPage();
        }
      },
    );
  }

  //Signout
  signOut(){
      FirebaseAuth.instance.signOut();
  }

  //Signin
  SignIn(AuthCredential authCreds){
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  SignInWIthOTP(smsCode, verId){
    AuthCredential authCreds = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode);
    SignIn(authCreds);
  }
}