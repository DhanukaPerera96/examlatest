import 'package:educationapp/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';

import 'package:rflutter_alert/rflutter_alert.dart';

class Profile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String address;
  final String skl;
  final String id;
  final String img;

  Profile({this.firstName, this.lastName, this.address, this.skl, this.id, this.img});

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

  static final String uploadEndPoint =
      'http://rankme.ml/uploads/prof/uploadimg.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  String img;
  String uImage;

  Future getImage() async{
    print("Hello");
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
       img = _image.toString();
      print(_image);
    });
    upload();
  }

  // upload(String fileName) {
  //   http.post(uploadEndPoint, body: {
  //     "image": base64Image,
  //     "name": fileName,
  //     "user" : widget.id,
  //   }).then((result) {
  //     // ignore: invalid_use_of_protected_member
  //     // (context as Element).reassemble();
  //     setState(() {});
  //   }).catchError((error) {
  //     // setStatus(error);
  //     setState(() {});
  //   });
  // }

  Future upload() async{
    final uri = Uri.parse("http://rankme.ml/uploadimg.php");
    var request = http.MultipartRequest('POST',uri);
    request.fields['name'] = widget.id;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();
    String regResponse = response.statusCode.toString();
    print(regResponse);

    // if(regResponse == "Success"){
    if(response.statusCode == 200){
      // setState(() {});
      // ignore: invalid_use_of_protected_member
      Alert(
        context: context,
        type: AlertType.success,
        title: "Updated",
        desc: "Profile Picture Successfully",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePage(
                  )
              ));
            },
            width: 120,
          )
        ],
      ).show();
      // ignore: invalid_use_of_protected_member
      // (context as Element).reassemble();
      // setState(() {});
      // setState(() {
      //   uImage = _image.path;
      // });

    }
    else{
      // setState(() {});
      // ignore: invalid_use_of_protected_member
      (context as Element).reassemble();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fNameController.text = widget.firstName;
    lNameController.text = widget.lastName;
    addressController.text = widget.address;
    schoolController.text = widget.skl;
    uImage = widget.img;
  }

  updateProfData () async{
    print(fNameController.text);
    print(lNameController.text);
    print(addressController.text);
    print(schoolController.text);
    print(widget.id);


    var url = 'http://rankme.ml/updateProf.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "id" : widget.id,
          "fname" : fNameController.text,
          "lname" : lNameController.text,
          "address" : addressController.text,
          "skl" : schoolController.text,
        }
    );
    String regResponse = response.body.toString();
    print(regResponse);

    if(regResponse == "Success"){
      Alert(
        context: context,
        type: AlertType.success,
        title: "Updated",
        desc: "Profile Updated Successfully",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    else{
      //print("Cannot Submit");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Update Failed",
        desc: "Please Try Again.",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }

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
                            backgroundImage: widget.img == null ? NetworkImage("http://rankme.ml/uploads/prof/avatar.png"): NetworkImage("http://rankme.ml/uploads/prof/$uImage"),
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
                       onPressed: updateProfData,
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
