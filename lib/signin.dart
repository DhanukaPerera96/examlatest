import 'package:flutter/material.dart';
import 'package:educationapp/loginui/components/text_field_container.dart';
import 'package:educationapp/loginui/components/rounded_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SigninPage(),
    );
  }
}

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
          child: Container(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.only(top: 38.0, left: 8.0, right: 8.0),
          child: Column(
            children: <Widget>[
              Text(
                "REGISTER",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  fontSize: 20.0,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                child: Card(
                  color: Colors.white,
                  child: TextField(

//              focusNode: myFocusNodePasswordLogin,
//              controller: loginPasswordController,
//              obscureText: _obscureTextLogin,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.person_outline,
                        size: 22.0,
                        color: Colors.black,
                      ),
                      hintText: "Firstname",
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      suffixIcon: GestureDetector(
                        onTap: (){},
                        child: Icon(
                          Icons.panorama_fish_eye,
//                    _obscureTextLogin
//                        ? FontAwesomeIcons.eye
//                        : FontAwesomeIcons.eyeSlash,
                          size: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),),
              Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                child: Card(
                  color: Colors.white,
                  child: TextField(

//              focusNode: myFocusNodePasswordLogin,
//              controller: loginPasswordController,
//              obscureText: _obscureTextLogin,
                    style: TextStyle(
                        fontFamily: "WorkSansSemiBold",
                        fontSize: 16.0,
                        color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.dehaze,
                        size: 22.0,
                        color: Colors.black,
                      ),
                      hintText: "Lastname",
                      hintStyle: TextStyle(
                          fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                      suffixIcon: GestureDetector(
                        onTap: (){},
                        child: Icon(
                          Icons.panorama_fish_eye,
//                    _obscureTextLogin
//                        ? FontAwesomeIcons.eye
//                        : FontAwesomeIcons.eyeSlash,
                          size: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),),
              RoundedButton(
                text: "REGISTER",
                press: () {},
              ),


          ],
          ),
        ),
      )),
    );
  }
}
