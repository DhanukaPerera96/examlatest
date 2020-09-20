import 'package:educationapp/ansbody.dart';
import 'package:educationapp/mcqbody.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SubMcq extends StatefulWidget {

  final String subId;
  final String subName;
  final String user;

  SubMcq({this.subId, this.subName, this.user});

  @override
  _SubMcqState createState() => _SubMcqState();
}

class _SubMcqState extends State<SubMcq> {
  String subjectId;
  List mcqDetails = List();
  List pmcqQuestions = List();
  String mcqPaperId;
  String mcqPaperName;
  String mcqPaperQs;
  String mcqPaperTime;
  String mcqPaperInst;
  String puId, pSub, pppr;
  int pTime, pPage, pCor, psetEnd, transTime;
  double pTot;
  var result;
  List oldAns = List();
  List pausedList = List();
  Map<String, int> finalsPause = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subjectId = widget.subId;

    getSubMcq(subjectId);

  }



  //Getting dynamic subjects
  getSubMcq(subId)async{
    print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String subject = subId;

    var url = 'http://rankme.ml/getSubMcq.php';
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
          mcqDetails = json.decode(jsonDataString.toString());
//          print(mcqDetails);
          mcqPaperId = mcqDetails[0]['id'];
          mcqPaperName = mcqDetails[0]['name'];
          mcqPaperQs = mcqDetails[0]['questions'];
          mcqPaperTime = mcqDetails[0]['time'];
          mcqPaperInst = mcqDetails[0]['instructions'];
        });
      }
      getPaused(mcqPaperId);
      getMcqQues(mcqPaperId);
    }
  }

  getPaused(mcqPprId)async{
    // print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String pprId = mcqPprId;

    var url = 'http://rankme.ml/getPause.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "mcqPprId" : pprId,
          "user_id" : widget.user,
        }
    );

    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          pausedList = json.decode(jsonDataString.toString());
//          print(mcqDetails);
//           mcqQuesId = pausedList[0]['id'];
//           correctAns = mcqQuestions[0]['answer'];
          puId = pausedList[0]['user'];
          pSub = pausedList[0]['sub'];
          pTime = int.parse(pausedList[0]['time']);
          pPage = int.parse(pausedList[0]['page']);
          pppr = pausedList[0]['paper'];
          pTot = double.parse(pausedList[0]['total']);
          pCor = int.parse(pausedList[0]['correct']);
          psetEnd = int.parse(pausedList[0]['setEnd']);
          // oldAns = jsonDecode(pausedList[0]['oldAns']);

          // result = Map.fromIterable(oldAns, key: (e) => e.ind, value: (e) => e.val);
          var val = jsonDecode(pausedList[0]['oldAns']);
          print(pppr);
          print(val);
          var arry = val.replaceAll("[","");
          var secondarr = arry.replaceAll("]","");
          print(secondarr);
          oldAns = secondarr.split(',');
          print(oldAns);
          print(pTime);

          int i = 0;

          while(i < oldAns.length){
            finalsPause['$i'] = int.parse(oldAns[i]);
            i++;
          }

          print(finalsPause);



          // print(result);
        });
      }




      // return new Row(children: list);

    }
  }

  getMcqQues(mcqPprId)async{
    print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String pprId = mcqPprId;

    var url = 'http://rankme.ml/getMcqPprs.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "mcqPprId" : pprId,
        }
    );

    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          pmcqQuestions = json.decode(jsonDataString.toString());
        });
      }




      // return new Row(children: list);

    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: mcqDetails.length == 0
            ? Container(
          child: Center(
            child: JumpingDotsProgressIndicator(
              fontSize: size.height*0.1,
            ),
          ),
        )
            :Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Center(
                    child: Text("Instructions",
                    style: TextStyle(
                      fontSize: size.height*0.05,
                    ),
                    ),
                  ),

                ),
                Divider(),
                ListTile(
                  title: Text("Time Limit"),
                  subtitle: Text(mcqPaperTime),
                  leading: Icon(Icons.timer, color: Colors.red,),
                ),
                ListTile(
                  title: Text("Subject"),
                  subtitle: Text(widget.subName),
                  leading: Icon(Icons.book, color: Colors.red,),
                ),
                ListTile(
                  title: Text("Questions"),
                  subtitle: Text(mcqPaperQs),
                  leading: Icon(Icons.format_list_numbered, color: Colors.red,),
                ),
                Center(
                  child: ListTile(
                    title: Text("Instructions"),
                    subtitle: Text(mcqPaperInst),
                    leading: Icon(Icons.question_answer, color: Colors.red,),
                  ),
                ),
                pppr != null ? Padding(
                  padding: const EdgeInsets.only(top: 28.0, left: 28.0, right: 28.0),
                  child: RaisedButton(

                      color: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      onPressed: () {

                        transTime = DateTime.now().millisecondsSinceEpoch +1000 * 60;

                        // var restTime =  (int.parse(mcqPaperTime) - pTime)+(3000*(pPage+1));
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) {
//                          return LoginScreen();
//                        },
//                      ),
//                    );


                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                AnsBody(
                                  quesList: pmcqQuestions,
                                  pageNo: pPage,
                                  correct: pCor,
                                  ansList: finalsPause,
                                  mcqId: pppr,
                                  subId: pSub,
                                  time : pTime,
                                  iniTime: transTime,
                                  setEnd : psetEnd.toString(),

                                )
                        ));
                      },
                      child: Text('Continue',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ))

                  ),
                ): Padding(
                  padding: const EdgeInsets.only(top: 28.0, left: 28.0, right: 28.0),
                  child: RaisedButton(

                    color: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    onPressed: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) {
//                          return LoginScreen();
//                        },
//                      ),
//                    );

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => McqBody(
                            mcqPprId: mcqPaperId,
                            mcqTime: mcqPaperTime,
                            subId : subjectId,
                          )
                      ));
                    },
                    child: Text('Start',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ))

                  ),
                ),
              ],
          ),
        ),
            ),
      ),
    );
  }
}

class Ans {
  String ind;
  int val;

  Ans(this.ind, this.val);

  @override
  String toString() {
    return '{ ${this.ind}, ${this.val} }';
  }
}