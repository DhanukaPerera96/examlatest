import 'package:educationapp/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:educationapp/loginui/login_screen.dart';
import 'package:educationapp/loginui/components/rounded_button.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySplashPage(),
    );
  }
}

class MySplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Splash Screen"),
//      ),
      body: SafeArea(
        child: Container(
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage("images/splash_back.jpg"),
//              fit: BoxFit.cover,
//            ),
//          ),
          color: Colors.blueAccent,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "images/signup_top.png",
                  width: size.width * 0.55,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "images/login_bottom.png",
                  width: size.width * 0.7,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image(image: AssetImage('images/logo.png')),
                  Container(
                    height: 50.0,
                    width: 200.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:  BorderRadius.circular(15),
                            color: Colors.indigo,
//                        gradient: LinearGradient(
//                            colors: [Color(0xff36d1dc), Color(0xff5b86e5)],
//                            begin: FractionalOffset(0.0, 0.0),
//                            end: FractionalOffset(0.5, 0.0),
//                            stops: [0.0, 1.0],
//                            tileMode: TileMode.clamp),
                      ),
                      child: RaisedButton(

                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('Continue',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                            Icon(Icons.arrow_forward,
                              color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}
