import 'package:educationapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:educationapp/loginui/components/text_field_container.dart';
import 'package:educationapp/loginui/components/rounded_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

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
  bool _isChecked = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String selectedDistrict;
  String selectedStream;
  String subOne;
  String subTwo;
  String subThree;

  List districtList = List();
  List streamList = List();
  List subList = List();
  List selectedSubList = List();

  //Getting District Data
  Future getDistrictData() async {
    var url = 'http://rankme.ml/getDistrict.php';
    http.Response response = await http.get(url);
    String jsonDataString = response.body;
    var data = jsonDecode(jsonDataString);
    print(jsonDataString.toString());
    setState(() {
      districtList = json.decode(jsonDataString);
    });
  }

  //Getting Stream Data
  Future geStreamData() async {
    var url = 'http://rankme.ml/getStream.php';
    http.Response response = await http.get(url);
    String jsonDataString = response.body;
    var data = jsonDecode(jsonDataString);
    print(jsonDataString.toString());
    setState(() {
      streamList = json.decode(jsonDataString);
    });
  }

  //Getting dynamic subjects
  getSubjects(stream)async{
    print("GetSUb called");

    var url = 'http://rankme.ml/getDynamicSub.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
    body: {
      "selectedStream" : stream,
        }
    );
    String jsonDataString = response.body;
    var data = jsonDecode(jsonDataString);
    print(jsonDataString.toString());
    setState(() {
      subList = json.decode(jsonDataString.toString());
//      for(var i = 0; i < subList.length; i++){
//        selectedSubList[subList[i]] = false;
//      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDistrictData();
    geStreamData();
  }

  void _onSubSelected(bool selected, subId) {
    if (selected == true && selectedSubList.length < 3) {
      setState(() {
        selectedSubList.add(subId);
      });
    } else {
      setState(() {
        selectedSubList.remove(subId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      children: <Widget>[
        Material(
          type: MaterialType.transparency,
          child: SafeArea(
              child: Container(

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/splash_back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
//        color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 38.0, left: 8.0, right: 8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                        child: Card(
                          color: Colors.white,
                          child: TextField(
//              focusNode: myFocusNodePasswordLogin,
                            controller: _firstNameController,
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
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                        child: Card(
                          color: Colors.white,
                          child: TextField(
                            controller: _lastNameController,
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
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: DropdownButton(
                                value: selectedDistrict,
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Select District",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                items: districtList.map((list){
                                  return DropdownMenuItem(
                                    child: Text(
                                      list['name'],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    value: list['id'].toString(),
                                  );
                                },).toList(),
                                onChanged: (value){
                                  setState(() {
                                    selectedDistrict = value;
                                    print(selectedDistrict);
                                  });
                                }

                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                        child: Card(

                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: DropdownButton(
                                value: selectedStream,
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Select Stream",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                items: streamList.map((list){
                                  return DropdownMenuItem(
                                    child: Text(
                                      list['stream'],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    value: list['id'].toString(),
                                  );
                                },).toList(),
                                onChanged: (value){
                                  setState(() {
                                    selectedStream = value;
                                    print(selectedStream);
                                    selectedSubList.clear();
                                  });

                                  getSubjects(selectedStream);
                                }

                            ),
                          ),
                        ),
                      ),

              Container(
                height: size.height * 0.5,
                width: size.width * 0.8,
                child: Card(
                  child: Scrollbar(
                    child: ListView(
                      children: <Widget>[
                        Column(
                      children: subList
                          .map((list) => CheckboxListTile(
                        title: Text(list['name']),
                        value: selectedSubList.contains(list['id']),
                        onChanged: (val) {
                          setState(() {
                            _onSubSelected(val,list['id']);
                          });
                          print(selectedSubList);
                        },
                      )).toList(),
                    ),
                      ],
                    ),
                  ),
                ),
              ),
                      RoundedButton(
                        text: "REGISTER",
                        press: () async{
                          FirebaseUser user = await FirebaseAuth.instance.currentUser();
                          String firstName = _firstNameController.text;
                          String lastName = _lastNameController.text;
                          String district = selectedDistrict;
                          String stream = selectedStream;
                          subOne = selectedSubList[0];
                          subTwo = selectedSubList[1];
                          subThree = selectedSubList[2];
                          print(firstName);
                          print(lastName);
                          print(district);
                          print(stream);
                          print(subOne);
                          print(subTwo);
                          print(subThree);
                          print(user.phoneNumber);

                          var url = 'http://rankme.ml/registerUsers.php';
                          final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
                              body: {
                                "fName" : firstName,
                                "lName" : lastName,
                                "mobile" : user.phoneNumber,
                                "district" : district,
                                "stream" : stream,
                                "subOne" : subOne,
                                "subTwo" : subTwo,
                                "subThree" : subThree,
                              }
                          );
                          String regResponse = response.body.toString();
                          print(regResponse);

                          if(regResponse == "Success"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ),
                            );
                          }
                          else{
                            print("Reg Failed");
                          }

                        },
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],

    );
  }
}
