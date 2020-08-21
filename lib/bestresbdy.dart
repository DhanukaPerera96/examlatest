import 'package:educationapp/bestresdrank.dart';
import 'package:educationapp/bestresirank.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:educationapp/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BestResBody extends StatefulWidget {
  final Data data;


  BestResBody({this.data});

  @override
  _BestResBodyState createState() => _BestResBodyState();
}

class _BestResBodyState extends State<BestResBody> {

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

    getSubPapers(subjectId);
    getUserDisc();
  }



  //Getting dynamic subjects
  getSubPapers(subId)async{
    print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String subject = subId;

    var url = 'http://rankme.ml/getSubPapers.php';
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
          papersList = json.decode(jsonDataString.toString());
          print(papersList);
        });
      }
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
      body: papersList.length == 0
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      )
          :DefaultTabController(
          length: 2,
          child: new Scaffold(
            appBar: AppBar(
              title: Text('Best Results'),
              bottom: TabBar(
                  tabs:
                  [
                    Tab(icon: Icon(Icons.home),text: "District Rank",),
                    Tab(icon: Icon(Icons.all_out),text: "Island Rank",),
                  ]

              ),
            ),
            body: TabBarView(children:
            [
//             any widget can work very well here <3

              new Container(
                color: Colors.indigo[100],
                child: papersList.length == 0
                    ? Container(
                  child: Center(
                    child: Text("No Information Available"),
                  ),
                )
                    : ListView(
                  children: papersList
                      .map((list) => Container(
                    width: size.width * 0.85,
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.library_books),
                        title: Text(list['name']),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: (){

                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => BestRestDrank(paperId: list['id'], districtId: districtId),
                            ),
                          );
                        },
                      ),
                    ),
                  )).toList(),
                )
              ),
              new Container(
                  color: Colors.indigo[100],
                  child: papersList.length == 0
                      ? Container(
                    child: Center(
                      child: Text("No Information Available"),
                    ),
                  )
                      : ListView(
                    children: papersList
                        .map((list) => Container(
                      width: size.width * 0.85,
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.library_books),
                          title: Text(list['name']),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => BestResIRank(paperId: list['id']),
                              ),
                            );
                          },
                        ),
                      ),
                    )).toList(),
                  )
              ),

            ]),
          )),
    );
  }
}
