import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:educationapp/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';


class MyResBdyRes extends StatefulWidget {

  final String paperId;
  final String userId;
  final String paperName;

  MyResBdyRes({this.paperId, this.paperName, this.userId});

  @override
  _MyResBdyResState createState() => _MyResBdyResState();
}

class _MyResBdyResState extends State<MyResBdyRes> {
  String pId;
  String pName;
  String uId;
  List paperRes = List();

  String pTime;
  String pScore;
  String pDRank;
  String pIRank;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pId = widget.paperId;
    pName = widget.paperName;
    uId = widget.userId;
    getUserPaperMarks(pId, uId);
  }

  getUserPaperMarks(pId, uId)async{
    print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String paperId = pId;
    String userId = uId;
    var url = 'http://rankme.ml/getUserPaperMarks.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "paperId" : paperId,
          "userId" : userId,
        }
    );

    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          paperRes = json.decode(jsonDataString.toString());
          pTime = paperRes[0]['time'];
          pScore = paperRes[0]['score'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text(pName),
      ),
      body: paperRes.length == 0
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      )
      :SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.48,
                      child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                "Score",
                              style: GoogleFonts.yesevaOne(
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            Text(
                                pScore,
                                style: GoogleFonts.yesevaOne(
                                    fontSize: size.width * 0.1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.48,
                      child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Time",
                              style: GoogleFonts.yesevaOne(
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            Text(
                                pTime,
                                style: GoogleFonts.yesevaOne(
                                  fontSize: size.width * 0.1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrangeAccent
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.48,
                      child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          
                          children: <Widget>[
                            Text(
                              "District Rank",
                              style: GoogleFonts.yesevaOne(
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                                pTime,
                                style: GoogleFonts.yesevaOne(
                                    fontSize: size.width * 0.1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.48,
                      child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Island Rank",
                              style: GoogleFonts.yesevaOne(
                                fontSize: size.width * 0.06,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                                pTime,
                                style: GoogleFonts.yesevaOne(
                                    fontSize: size.width * 0.1,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
