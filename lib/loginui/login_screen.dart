import 'package:educationapp/mainntainRoute.dart';
import 'package:flutter/material.dart';
import 'body.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyLogin(),
    );
  }
}

class BodyLogin extends StatefulWidget {
  @override
  _BodyLoginState createState() => _BodyLoginState();
}

class _BodyLoginState extends State<BodyLogin> {

  FocusNode focusNode = FocusNode();
  String hintText = '+94 71567689';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = '+94 715676899';
      }
      setState(() {});
    });
    autoLog();

  }

  autoLog() async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();

    if(user != null ){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => MaintainRoute()
      ));
    }
  }

  String mobileNo;
  String smsCode;
  bool codeSent = false;
  String verificationId;
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    Future<bool> loginUser(String phone, BuildContext context) async{

      FirebaseAuth _auth = FirebaseAuth.instance;

      phone = "+94"+phone;

      _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential credential) async{
            Navigator.of(context).pop();

            AuthResult result = await _auth.signInWithCredential(credential);

            FirebaseUser user = result.user;


            if(user != null ){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MaintainRoute()
              ));
            }else{
              print("Error");
//              Navigator.push(context, MaterialPageRoute(
//                  builder: (context) => SigninPage()
//              ));
            }

            //This callback would gets called when verification is done automaticlly
          },
          verificationFailed: (AuthException exception){
            print(exception);
          },
          codeSent: (String verificationId, [int forceResendingToken]){
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Enter the code?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async{
                          final code = _codeController.text.trim();
                          AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);

                          AuthResult result = await _auth.signInWithCredential(credential);

                          FirebaseUser user = result.user;

                          if(user != null){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MaintainRoute()
                            ));
                          }else{
                            print("Enter Valid Code");
//                            Navigator.push(context, MaterialPageRoute(
//                                builder: (context) => SigninPage()
//                            ));
                          }
                        },
                      )
                    ],
                  );
                }
            );
          },
          codeAutoRetrievalTimeout: null
      );
    }

    Size size = MediaQuery.of(context).size;
    return Container(

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

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextField(
                  maxLength: 9,
                  focusNode: focusNode,
                  controller: _phoneController,
                  onChanged: (value) {
                    setState(() {
                      mobileNo = value;
//                    print("mobile altered");
                    });
                  },
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    prefixText: '+94 ',
                    prefixStyle: TextStyle(color: Colors.black),
                    icon: Icon(
                      Icons.mobile_screen_share,
                      color: Colors.blue,
                    ),
                    hintText: hintText,
                    border: InputBorder.none,
                    counterText: ''
                  ),
                ),
              ),
//              RoundedInputField(
//                hintText: "Enter OTP Code",
//                onChanged: (value) {
//                  setState(() {
//                    smsCode = value;
//                  });
//
//
//                },
//              ),
//              RoundedPasswordField(
//                onChanged: (value) {},
//              ),
              RoundedButton(
                text: "LOGIN",
                press: (){
                  final phone = _phoneController.text.trim();
                  loginUser(phone, context);

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
