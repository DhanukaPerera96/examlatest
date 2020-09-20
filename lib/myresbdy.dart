import 'package:educationapp/myresbdyres.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:educationapp/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class MyResBdy extends StatefulWidget {

  final Data data;


  MyResBdy({this.data});

  @override
  _MyResBdyState createState() => _MyResBdyState();
}

class _MyResBdyState extends State<MyResBdy> {

  List papersList = List();
  List districtOne = List();
  String userId ;
  String subjectId;
  String subjectName;
  String districtId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = widget.data.userId;
    subjectId = widget.data.subId;
    subjectName = widget.data.subName;
    districtId = widget.data.district;

    getUserPapers(subjectId, userId, districtId);
//    getUserDisc();
  }



  //Getting dynamic subjects
  getUserPapers(subId, uId, disc)async{
    print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String subject = subId;
    String userId = uId;
    var url = 'http://rankme.ml/getUserPapers.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "subId" : subject,
          "userId" : userId,
          "district" : disc
        }
    );

    if(response.body.toString() != "Error") {
      print("Hello");
      String jsonDataString = response.body;
      // var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        print("Hello from other side");
        setState(() {
          papersList = json.decode(jsonDataString.toString());
          if(!response.body.isNotEmpty) {
            print("hello");
          }
          else{
            print(response.body);
          }

        });
      }
    }
    else{
      print("Error");
    }
  }

  getUserDisc()async{
    print("GetSUb called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String phoneNo = user.phoneNumber;
    String phoneFinal = phoneNo.replaceAll("+94", "");

    var url = 'http://rankme.ml/getUserDistrict.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "phoneNo" : phoneFinal,
        }
    );
    String jsonDataString = response.body;
//    var data = jsonDecode(jsonDataString);

    if (this.mounted){
      setState((){
        districtOne = json.decode(jsonDataString.toString());
        districtId = districtOne[0]['district_id'];
        print(districtId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Results'),
      ),
      body: papersList.length == 0
          ? Container(
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
      ):Container(
        color: Colors.indigo[100],
        height: size.height*1,
        child: SingleChildScrollView(
          child: new Container(
              color: Colors.indigo[100],
              child:
//              : ListView(
//            children: papersList
//                .map((list) => Container(
//              width: size.width * 0.85,
//              child: Card(
//                child: ListTile(
//                  leading: Icon(Icons.library_books),
//                  title: Text(list['name']),
//                  trailing: Icon(Icons.arrow_forward),
//                  onTap: (){
//                    Navigator.push(context,
//                            MaterialPageRoute(
//                              builder: (context) => MyResBdyRes(paperId: list['id'], paperName: list['name'], userId: userId),
//                            ),
//                          );
//                  },
//                ),
//              ),
//            )).toList(),
//          )
           FittedBox(
            child: DataTable(
              columnSpacing: 10.0,
                  columns: [
                    DataColumn(label: Text(
                        'Paper'
                        ,style: GoogleFonts.yesevaOne(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                        color: Colors.black
                    )
                    )),
                    DataColumn(label: Text('Score',style: GoogleFonts.yesevaOne(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                        color: Colors.black
                    ))),
                    DataColumn(label: Text('Time',style: GoogleFonts.yesevaOne(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                        color: Colors.black
                    ))),
                    DataColumn(label: Text('District\n Rank',style: GoogleFonts.yesevaOne(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                        color: Colors.black
                    ))),
                    DataColumn(label: Text('Island\n Rank',style: GoogleFonts.yesevaOne(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                        color: Colors.black
                    ))),
                  ],
                  rows:
                  papersList // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["name"],
                            style: GoogleFonts.yesevaOne(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ))), //Extracting from Map element the value
                        DataCell(Center(
                          child: Text(element["score"],
                              style: GoogleFonts.yesevaOne(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54
                              )),
                        )),
                        DataCell(Center(
                          child: Text(element["time"],
                              style: GoogleFonts.yesevaOne(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange
                              )),
                        )),
                        DataCell(Center(
                          child: Text(element["0"],
                              style: GoogleFonts.yesevaOne(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo
                              )),
                        )),
                        DataCell(Center(
                          child: Text(element["0"],
                              style: GoogleFonts.yesevaOne(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo
                              )),
                        )),
                      ],
                    )),
                  )
                      .toList(),
                ),
          ),
          ),
        ),
      ),
    );
  }
}
