import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String address;
  final String skl;

  Profile({this.firstName, this.lastName, this.address, this.skl});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  final picker = ImagePicker();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController schoolController = TextEditingController();

  Future getImage() async{
    print("Hello");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      print(_image);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fNameController.text = widget.firstName;
    lNameController.text = widget.lastName;
    addressController.text = widget.address;
    schoolController.text = widget.skl;

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.indigo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xffFDCF09),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/calenderapp-ec93d.appspot.com/o/events.jpg?alt=media&token=c1cb0edf-bbbf-48ae-ab54-79b7eb6525ab"),
                          ),
                        ),

                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 30.0,
                    ),
                    onPressed: getImage,
                  ),


                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0, bottom: 8.0, left: 16.0, right: 16.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: fNameController,
                        decoration: InputDecoration(
//                  errorText: true
//                      ? null
//                      : "Invalid Mobile Number",
                          hintText: "First Name",
                          border: new OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: lNameController,
                        decoration: InputDecoration(
//                  errorText: true
//                      ? null
//                      : "Invalid Mobile Number",
                          hintText: "Last Name",
                          border: new OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
//                  errorText: true
//                      ? null
//                      : "Invalid Mobile Number",
                          hintText: "Address",
                          border: new OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: schoolController,
                        decoration: InputDecoration(
//                  errorText: true
//                      ? null
//                      : "Invalid Mobile Number",
                          hintText: "School",
                          border: new OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.indigo,
                        splashColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0))),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "Update Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "WorkSansBold"),
                          ),
                        ),
//                        onPressed: updateProfData,
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
