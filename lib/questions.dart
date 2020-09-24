import 'package:educationapp/questionslist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {

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
    bool _allow = false;
    return WillPopScope(
      child: Scaffold(
        body: subList.length == 0
            ? Container(
          color: Colors.indigo[100],
          height: size.height*1,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              Container(
                color: Colors.indigo[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("No Information Available", style: GoogleFonts.yesevaOne(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                      )),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
            :Container(
          height: size.height*1,
          decoration: BoxDecoration(
            color: Colors.blue[800],
            image: DecorationImage(
              image: AssetImage("images/main_top.png"),
              fit: BoxFit.cover,
            ),
          ),
              child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Center(
                  child: new Image(
                    image: AssetImage('images/logo.png'),
                    height: size.height * 0.3,
                    width: size.width * 0.5,
                  ),
                ),
                Center(child: Text("Questions", style: GoogleFonts.yesevaOne(
                    fontSize: size.width * 0.08,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ))),
                Column(
                  children: subList
                      .map((list) => Container(
                    width: size.width * 0.8,
                        child: Card(
                    child: ListTile(
                        leading: Icon(Icons.library_books),
                        title: Text(list['name']),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => QuestionsList(
                                subId: list['id'],
                                subName: list['name'],
                              )
                          ));
                        },
                    ),
                  ),
                      )).toList(),
                ),
              ],
          ),
        ),
            ),
        backgroundColor: Colors.white,
      ),
      onWillPop: () {
        return Future.value(_allow); // if true allow back else block it
      },
    );
  }
}
