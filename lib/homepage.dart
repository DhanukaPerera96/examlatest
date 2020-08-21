import 'package:educationapp/aboutus.dart';
import 'package:educationapp/bestres.dart';
import 'package:educationapp/contactus.dart';
import 'package:educationapp/mcqpaper.dart';
import 'package:educationapp/myres.dart';
import 'package:educationapp/notices.dart';
import 'package:educationapp/profile.dart';
import 'package:educationapp/questions.dart';
import 'package:educationapp/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _pageController;
  int pageIndex;
  List userData = List();
  String fName;
  String lName;
  String profile;
  String stream;
  String district;
  String image;
  String address;
  String scl;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }
  onTap(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
//    pgController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 2);
    pageIndex = 2;
    getUserData();
  }

  getUserData()async{
    print("getUser called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String phoneNo = user.phoneNumber;
    String phoneFinal = phoneNo.replaceAll("+94", "");

    var url = 'http://rankme.ml/getUserData.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "phoneNo" : phoneFinal,
        }
    );
    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          userData = json.decode(jsonDataString.toString());
          fName = userData[0]['fname'];
          lName = userData[0]['lname'];
          profile = userData[0]['profile'];
          stream = userData[0]['stream_id'];
          district = userData[0]['district_id'];
          image = userData[0]['img'];
          address = userData[0]['address'];
          scl = userData[0]['school'];

          print(userData);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Rank Me"),
        ),
        backgroundColor: Colors.indigo,
        body: PageView(
          children: <Widget>[
            BestRes(),
            MyRes(),
            McqPaper(),
            Questions(),
            Notices(),
          ],
          controller: _pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
            backgroundColor: Colors.white,
            currentIndex: pageIndex,
            onTap: onTap,
            activeColor: Colors.indigo,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.report_problem),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notification_important),
              ),
            ]),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:  AssetImage('images/drawer_back.png'))),
                  child: Stack(children: <Widget>[
                    ListTile(
                      leading: new Image(image: AssetImage('images/logo.png')),
                    ),
                    Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: userData.length == 0
                            ? Text("Hello User",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500))
                            :Text("Hello " + fName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500))),
                  ])),
              ListTile(
                leading: Icon(Icons.verified_user),
                title: Text("Profile"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Profile(
                        firstName: fName,
                        lastName: lName,
                        skl: scl,
                        address: address,
                      )
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Settings(
                      )
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text("Share App"),
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: Text("About Us"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AboutUs(
                      )
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.call),
                title: Text("Contact Us"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ContactUs(
                      )
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
