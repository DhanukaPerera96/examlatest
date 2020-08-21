import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class McqPaper extends StatefulWidget {

  @override
  _McqPaperState createState() => _McqPaperState();
}

class _McqPaperState extends State<McqPaper> {

  List subList = List();

  //Getting dynamic subjects
  getUserSubjects()async{
    print("GetSUb called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String phoneNo = user.phoneNumber;
  String phoneFinal = phoneNo.replaceAll("+94", "");

    var url = 'http://rankme.ml/getUserSub.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "phoneNo" : phoneFinal,
        }
    );
    String jsonDataString = response.body;
    var data = jsonDecode(jsonDataString);
//    print(jsonDataString.toString());

//    setState(() {
//      subList = json.decode(jsonDataString.toString());
//      print(subList);
//    });

    if (this.mounted){
      setState((){
        subList = json.decode(jsonDataString.toString());
        print(subList);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserSubjects();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: subList.length == 0
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        )
            :SingleChildScrollView(
          child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[800],
              image: DecorationImage(
                image: AssetImage("images/main_top.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Center(
                  child: new Image(
                      image: AssetImage('images/logo.png'),
                      height: size.height * 0.5,
                    width: size.width * 0.5,
                  ),
                ),
                Column(
                  children: subList
                      .map((list) => Container(
                    width: size.width * 0.9,
                        child: Card(
                          child: ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text(list['name']),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: (){},
                  ),
                        ),
                      )).toList(),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
    );
  }
}
