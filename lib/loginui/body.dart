import 'package:educationapp/homepage.dart';
import 'package:educationapp/services/authservice.dart';
import 'package:educationapp/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:educationapp/loginui/components/already_have_an_account_acheck.dart';
import 'package:educationapp/loginui/components/rounded_button.dart';
import 'package:educationapp/loginui/components/rounded_input_field.dart';
import 'package:educationapp/loginui/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:educationapp/loginui/login_screen.dart';
import 'package:educationapp/loginui/background.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String mobileNo;
    String smsCode;
    String verificationId;

    Future<void> verifyPhone(mob) async{

      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verifId){
        verificationId = verifId;
      };

      final PhoneCodeSent smsCodeSent = (String verifId, [int forceCodeResend]){
        verificationId = verifId;

      };

      final PhoneVerificationCompleted verifiedSuccess = (AuthCredential authresult){
        AuthService().SignIn(authresult);
      };

      final PhoneVerificationFailed verifyFailed = (AuthException exception){
        print('${exception.message}');
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: mob,
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verifiedSuccess,
          verificationFailed: verifyFailed
      );
      print(mob);
    }

//    Future<bool> smsCodeDialog(BuildContext context){
//      return showDialog(
//          context: context,
//        barrierDismissible: false,
//        builder: (BuildContext context){
//            return new AlertDialog(
//              title: Text('Enter sms code'),
//              content: TextField(
//                onChanged: (value){
//                  smsCode = value;
//                },
//              ),
//              contentPadding: EdgeInsets.all(10.0),
//              actions: <Widget>[
//                new FlatButton(
//                    onPressed: (){
//                      FirebaseAuth.instance.currentUser().then((user){
//                        if(user != null){
//                          Navigator.of(context).pop();
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) {
//                                return HomePage();
//                              },
//                            ),
//                          );
//                        }
//                        else{
//                          Navigator.of(context).pop();
//                        }
//                      });
//                    },
//                    child: Text("Done")
//                ),
//              ],
//            );
//        }
//      );
//    }
//
//    signIn(){
//      FirebaseAuth.instance.p
//    }




    Size size = MediaQuery.of(context).size;
    return Container(
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: AssetImage("images/splash_back.jpg"),
//          fit: BoxFit.cover,
//        ),
//      ),
    color: Colors.blueAccent,
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "images/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Mobile Number",
                onChanged: (value) {

                  mobileNo = value;

                },
              ),
//              RoundedPasswordField(
//                onChanged: (value) {},
//              ),
              RoundedButton(
                text: "LOGIN",
                press: (){
                  verifyPhone(mobileNo);
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SigninPage();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}