import 'package:educationapp/longqbody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionsList extends StatefulWidget {

  final String subId;
  final String subName;

  QuestionsList({this.subId, this.subName});


  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {

  String subId;
  String subName;
  List questionsList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subId = widget.subId;
    subName = widget.subName;
    getSubPapers(subId);
  }

  getSubPapers(subId)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String subject = subId;

    var url = 'http://rankme.ml/getSubLongQs.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "subId" : subject,
        }
    );

    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          questionsList = json.decode(jsonDataString.toString());
          print(questionsList);
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: Text(subName),
      ),
      body: questionsList.length == 0
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
        color: Colors.indigo[100],
            child: ListView(
        children: questionsList
              .map((list) => Container(
            width: size.width * 0.85,
            child: Card(
              child: ListTile(
                leading: Icon(Icons.library_books),
                title: Text("Question "+ list['no']),
                trailing: Icon(Icons.arrow_forward),
                onTap: (){

                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => LongQBody(qText: list['text'], qImage: list['image'], answer: list['answer'], answerImage: list['answer_image'], qNo: list['no']),
                  ),
                );
                },
              ),
            ),
        )).toList(),
      ),
          ),

    );
  }
}
