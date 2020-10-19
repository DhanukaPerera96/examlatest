import 'package:educationapp/homepage.dart';
import 'package:educationapp/mcqpaper.dart';
import 'package:educationapp/showres.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:collection';


class FinalRes extends StatefulWidget {
  final double tot;
  final Map ansList;
  final List<dynamic> realAns;
  final String mcqId;
  final String subId, setEnd;
  final int time, iniTime;

  FinalRes({List<dynamic> realAns, this.tot, this.ansList, this.mcqId, this.subId, this.time, this.iniTime, this.setEnd}): this.realAns = realAns ?? [];

  @override
  _FinalResState createState() => _FinalResState();
}

class _FinalResState extends State<FinalRes> {
  String result;
  List userData = List();
  String dId;
  String udId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double val = widget.tot;
    if(widget.tot == null){

      val = 0;
    }
    result = val.toStringAsFixed(2);
    // print(widget.ansList);
    // print("////////////////////////////////////////////////");
    // print(widget.realAns);
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
          dId = userData[0]['district_id'];
          udId = userData[0]['id'];

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _allow = false;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Final Result"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(result.toString())),
                    ),
                  ),
                  Expanded(

                    child:
                    MaterialButton(
                      elevation: 2,
                      child: Text('Home'),
                      onPressed: ()async {

                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Are You Sure?",
                          desc: "These answers will be submitted as final",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "No",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.red,
                            ),
                            DialogButton(
                              child: Text(
                                "Yes",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                String time = ((int.parse(widget.setEnd) - widget.time/60000)).toStringAsFixed(2);
                                String score = widget.tot.toString();
                                String paper = widget.mcqId;
                                String user = udId;
                                String district = dId;
                                String subject = widget.subId;

                                var url = 'http://rankme.ml/submitRes.php';
                                final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
                                    body: {
                                      "time" : time,
                                      "score" : score,
                                      "papers_id" : paper,
                                      "user_data_id" : user,
                                      "district_id" : district,
                                      "subject_id" : subject,
                                    }
                                );
                                String regResponse = response.body.toString();
                                print(regResponse);

                                if(regResponse == "Success"){
                                  // Navigator.push(context, MaterialPageRoute(
                                  //     builder: (context) => HomePage(
                                  //     )
                                  // ));
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                      HomePage()), (Route<dynamic> route) => false);
                                }
                                else{
                                  //print("Cannot Submit");
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Submission Failed",
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
                              },
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(116, 116, 191, 1.0),
                                Color.fromRGBO(52, 138, 199, 1.0)
                              ]),
                            )
                          ],
                        ).show();





                      },
                      color: Colors.indigoAccent,
                    ),
                  ),
                ],
              ),
              Container(
                height: size.height*0.75 ,
                child: new GridView.count(
                  crossAxisCount: 5,
                  children: new List<Widget>.generate(widget.realAns.length, (index) {
                    return GestureDetector(
                      child: new GridTile(
                        child: new Card(
                            color: widget.ansList["$index"] == int.parse(widget.realAns[index]['answer'])? Colors.green : Colors.red,
                            child: new Center(
                              child: new Text((index+1).toString()),
                            )
                        ),
                      ),
                      onTap: (){
                        print(widget.realAns[index]);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ShowRes(
                              showResList : widget.realAns,
                              userSel: widget.ansList["$index"],
                              qNo : index,

                            )
                        ));

                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        return Future.value(_allow); // if true allow back else block it
      },
    );
  }
}
