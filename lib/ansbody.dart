import 'package:educationapp/finalres.dart';
import 'package:educationapp/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_view_indicators/step_page_indicator.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class AnsBody extends StatefulWidget {
  //final List quesList = List();
  final int pageNo;
  final List<dynamic> quesList;
  final int correct;
  final double tot;
  final Map ansList;
  final String mcqId;
  final String subId, setEnd;
  final int time, iniTime;

  AnsBody({List<dynamic> quesList, this.pageNo, this.correct, this.tot, this.ansList, this.mcqId, this.subId, this.time, this.iniTime, this.setEnd}) : this.quesList = quesList ?? [];

  @override
  _AnsBodyState createState() => _AnsBodyState();
}

class _AnsBodyState extends State<AnsBody> {
  bool ansOneB = false;
  bool ansTwoB = false;
  bool ansThreeB = false;
  bool ansFourB = false;
  bool ansFiveB = false;
  int endTime;
  List userData = List();
  String udId;
  int qNumber;
  int pgNo;
  String qNo, ansNo, selectedFinal;
  double total;
  int corPrev, quesAmt;
  Map<String, int> finQAndAList = {};
  int strtEndT, transTime;
  bool isClosed = true;

  final _items = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.amber,
    Colors.brown,
    Colors.yellow,
    Colors.blue,
  ];
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.pageNo);
    // print(widget.quesList[widget.pageNo]);
    corPrev  = widget.correct;
    finQAndAList = widget.ansList;
    pgNo = widget.pageNo;
    strtEndT = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    setState(() {
      int t = widget.time;
      endTime = widget.iniTime + t;
      _currentPageNotifier.value = widget.pageNo;
    });

    print(widget.time);
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
          udId = userData[0]['id'];

        });
      }
    }
  }

  pauseExit() async{

    transTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    Map<String, int> finQAns = {};

    String uId = userData[0]['id'];
    String subId = widget.subId;
    String ppr = widget.mcqId;
    String time = ((endTime - transTime)+3000).toString();
    double tot = (widget.correct/widget.quesList.length)*100;
    int page = widget.pageNo;
    finQAns = widget.ansList;

    var list = [];

    // list = finQAns.entries.map((e) => Ans(e.key, e.value)).toList();
    // var result = Map.fromIterable(list, key: (e) => e.ind, value: (e) => e.val);
    list = finQAns.values.toList();

    String tots = tot.toStringAsFixed(2);
    String pg = page.toString();
    String li = jsonEncode(list);

    print(uId);
    // print(subId);
    print(subId);
    print(ppr);
    print(time);
    print(tot);
    print(page);
    print(li);
    // print(result);

    setState(() {
      isClosed = false;
    });


    var url = 'http://rankme.ml/submitPause.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "uId" : uId,
          "subId" : subId,
          "papers_id" : ppr,
          "time" : time,
          "tot" : tots,
          "page" : pg,
          "ans" : li,
          "correct" : corPrev.toString(),
          "setEnd" : widget.setEnd,
        }
    );
    String regResponse = response.body.toString();
    print(regResponse);

    if(regResponse == "Success"){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage(
          )
      ));
    }
    else{
      //print("Cannot Submit");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Cannot Pause",
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



  validateAns(ans){

    setState(() {
      isClosed = false;
    });

    transTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

    var restTime =  (endTime - transTime)+(3000*(pgNo+1));


    if(ans != null) {
      int corAns = int.parse(widget.quesList[widget.pageNo]['answer']);
      quesAmt = widget.quesList.length;
      assert(corAns is int);
      int selAns = int.parse(ans);
      assert(selAns is int);
      print(ans);
      print(corAns);
      if (selAns == corAns) {
        print("Question " + widget.quesList[widget.pageNo]['no'] + " Correct");
        corPrev = corPrev + 1;
      }
      else {
        print("Question " + widget.quesList[widget.pageNo]['no'] + " wrong");
      }
      setState(() {
        total = (corPrev / quesAmt) * 100;
        finQAndAList["$pgNo"] = selAns;
      });


      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: widget.quesList,
                pageNo: widget.pageNo + 1,
                correct: corPrev,
                ansList: finQAndAList,
                mcqId: widget.mcqId,
                subId: widget.subId,
                time : restTime,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,

              )
      ));
    }
    else if(ans == null) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: widget.quesList,
                pageNo: widget.pageNo + 1,
                correct: corPrev,
                ansList: finQAndAList,
                mcqId: widget.mcqId,
                subId: widget.subId,
                time: restTime,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,

              )
      ));
    }


  }

  validateAnsFinal(ans){

    Alert(
      context: context,
      type: AlertType.warning,
      title: "Are You Sure?",
      desc: "You won't be able to change the answer again!",
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
          onPressed: () {
            setState(() {
              isClosed = false;
            });

            transTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

            var restTime =  (endTime - transTime)+3000;

            if(ans != null){
              int corAns = int.parse(widget.quesList[widget.pageNo]['answer']);
              quesAmt = widget.quesList.length;
              assert(corAns is int);
              int selAns = int.parse(ans);
              assert(selAns is int);
              print(ans);
              print(corAns);
              if(selAns == corAns)
              {
                print("Question "+ widget.quesList[widget.pageNo]['no'] +" Correct");
                corPrev = corPrev + 1;
              }
              else{
                print("Question "+ widget.quesList[widget.pageNo]['no'] +" wrong");
                //wrong = wrong+1;
              }
              setState(() {
                total = (corPrev/quesAmt)*100;
                finQAndAList["$pgNo"] = selAns ;
              });

              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FinalRes(
                    tot : total,
                    ansList: finQAndAList,
                    realAns: widget.quesList,
                    mcqId: widget.mcqId,
                    subId: widget.subId,
                    time : restTime,
                    iniTime: widget.iniTime,
                    setEnd : widget.setEnd,
                  )
              ));
            }
            else if(ans == null) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      FinalRes(
                        tot: total,
                        ansList: finQAndAList,
                        realAns: widget.quesList,
                        mcqId: widget.mcqId,
                        subId: widget.subId,
                        time: restTime,
                        iniTime: widget.iniTime,
                        setEnd : widget.setEnd,
                      )
              ));
            }
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();



  }

  _buildCircleIndicator5() {
    return CirclePageIndicator(
      size: 8.0,
      selectedSize: 16.0,
      dotColor: Colors.black,
      selectedDotColor: Colors.blue,
      itemCount: widget.quesList.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }

  _buildStepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(

          color: Colors.indigo[100],
          padding: const EdgeInsets.all(4.0),
          child: StepPageIndicator(

            itemCount: 50,
            currentPageNotifier: _currentPageNotifier,
            size: 18,
            onPageSelected: (int index) {
              if (_currentPageNotifier.value > index)
                _pageController.jumpToPage(index);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    bool _allow = false;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isClosed ? CountdownTimer(endTime: endTime,
              hoursTextStyle:GoogleFonts.yesevaOne(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.red
              ),
              minTextStyle: GoogleFonts.yesevaOne(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.red
              ),
              secTextStyle: GoogleFonts.yesevaOne(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent
              ),

              onEnd: (){
                print("Game Over");
                // Navigator.push(context, MaterialPageRoute(
                //     builder: (context) => FinalRes(
                //       tot : total,
                //     )
                // ));
                //validateAns(selectedFinal);
              },
            ): Container(),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          //   child: Row(
          //     children: [
          //
          //
          //
          //     ],
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(widget.quesList[widget.pageNo]['text']),
              widget.quesList[widget.pageNo]['image'] != null ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['image']),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.transparent,
                  ),
                  height: size.height*0.2,
                  width: size.width*0.1,
                ),
              ): Container(width: 0, height: 0),
            ],
          ),


          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[


                  CheckboxListTile(

                      title: Text(widget.quesList[widget.pageNo]['ans_one']),
                      value: ansOneB,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_one_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                          ansOneB = true;
                          ansFiveB = false;
                          ansTwoB = false;
                          ansThreeB = false;
                          ansFourB = false;
                          selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.quesList[widget.pageNo]['ans_one_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_one_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(
                                img: widget.quesList[widget.pageNo]['ans_one_img'],
                              );
                            }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  CheckboxListTile(
                      title: Text(widget.quesList[widget.pageNo]['ans_two']),
                      value: ansTwoB,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_two_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoTwo = mcqQuestions[0]['ans_two_no'];
                          ansTwoB = true;
                          ansFiveB = false;
                          ansOneB = false;
                          ansThreeB = false;
                          ansFourB = false;
                          selectedFinal = widget.quesList[widget.pageNo]['ans_two_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);

                      },
                      subtitle: widget.quesList[widget.pageNo]['ans_two_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_two_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(
                                img: widget.quesList[widget.pageNo]['ans_two_img'],
                              );
                            }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  CheckboxListTile(
                      title: Text(widget.quesList[widget.pageNo]['ans_three']),
                      value: ansThreeB,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_three_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoThree = mcqQuestions[0]['ans_three_no'];
                          ansThreeB = true;
                          ansFiveB = false;
                          ansOneB = false;
                          ansTwoB = false;
                          ansFourB = false;
                          selectedFinal = widget.quesList[widget.pageNo]['ans_three_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.quesList[widget.pageNo]['ans_three_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_three_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(
                                img: widget.quesList[widget.pageNo]['ans_three_img'],
                              );
                            }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  CheckboxListTile(
                      title: Text(widget.quesList[widget.pageNo]['ans_four']),
                      value: ansFourB,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_four_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoFour = mcqQuestions[0]['ans_four_no'];
                          ansFourB = true;
                          ansFiveB = false;
                          ansOneB = false;
                          ansTwoB = false;
                          ansThreeB = false;
                          selectedFinal = widget.quesList[widget.pageNo]['ans_four_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.quesList[widget.pageNo]['ans_four_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_four_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(
                                img: widget.quesList[widget.pageNo]['ans_four_img'],
                              );
                            }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  (widget.quesList[widget.pageNo]['ans_five'] != null) ? CheckboxListTile(
                      title: Text(widget.quesList[widget.pageNo]['ans_five']),
                      value: ansFiveB,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_five_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoFive = mcqQuestions[0]['ans_five_no'];
                          ansFiveB = true;
                          ansOneB = false;
                          ansTwoB = false;
                          ansThreeB = false;
                          ansFourB = false;
                          selectedFinal = widget.quesList[widget.pageNo]['ans_five_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.quesList[widget.pageNo]['ans_five_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_five_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(
                                img: widget.quesList[widget.pageNo]['ans_five_img'],
                              );
                            }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ): SizedBox(
                    height: 1.0,
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: _buildPageIndicator(),
                  // ),

                ],
              ),
            ),
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       child: widget.pageNo < widget.quesList.length ?  MaterialButton(
          //         elevation: 2,
          //         child: Text('Next'),
          //         onPressed: (){
          //
          //           Navigator.push(context, MaterialPageRoute(
          //               builder: (context) => AnsBody(
          //                 quesList: widget.quesList,
          //                 pageNo: widget.pageNo+1,
          //
          //               )
          //           ));
          //         },
          //         color: Colors.indigoAccent,
          //       ):
          //       MaterialButton(
          //         elevation: 2,
          //         child: Text('Finish'),
          //         onPressed: (){
          //           print("End");
          //
          //           // Navigator.push(context, MaterialPageRoute(
          //           //     builder: (context) => McqBody(
          //           //
          //           //     )
          //           //));
          //         },
          //         color: Colors.indigoAccent,
          //       ),
          //     )
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              color: Colors.indigo[100],
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      elevation: 2,
                      child: Text('Pause and Exit',
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      onPressed: (){
                        pauseExit();
                      },
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  Expanded(

                    child:
                    MaterialButton(
                      elevation: 2,
                      child: Text('Finish'),
                      onPressed: (){
                        validateAnsFinal(selectedFinal);
                        // Navigator.push(context, MaterialPageRoute(

                        //validateAnsFinal(selectedFinal);

                        // builder: (context) => AnsBody(
                        //   quesList: widget.quesList,
                        //   pageNo: widget.pageNo+1,
                        //
                        // )
                        // ));
                      },
                      color: Colors.indigoAccent,
                    ),
                  ),
                  SizedBox(
                    width: size.width*0.01,
                  ),
                  Expanded(

                    child: widget.pageNo < widget.quesList.length-1 ?  MaterialButton(
                      elevation: 2,
                      child: Text('Next'),
                      onPressed: (){

                        validateAns(selectedFinal);

                      },
                      color: Colors.indigoAccent,
                    ):
                    MaterialButton(
                      elevation: 2,
                      child: Text('Next'),
                      onPressed: null,
                      color: Colors.indigoAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
          // _buildCircleIndicator5()
          Container(
            child: Row(
              children: [
                Expanded(child: Container(
                  width: size.width*0.1,
                )),
                FloatingActionButton(
                  backgroundColor: Colors.indigo[400],
                  onPressed: (){
                    _settingModalBottomSheet(context);
                  },
                  child: new Icon(Icons.arrow_drop_up),
                  shape: RoundedRectangleBorder(),
                ),
              ],
            ),
          ),
          // Column(
          //   children: [
          //
          //     FloatingActionButton(
          //       onPressed: (){
          //         _settingModalBottomSheet(context);
          //       },
          //       child: new Icon(Icons.arrow_drop_up),
          //     ),
          //   ],
          // ),

          // Expanded(
          //   child: ListView(
          //     children: <Widget>[
          //
          //
          //       _buildCircleIndicator5(),
          //     ]
          //         .map((item) => Padding(
          //       child: item,
          //       padding: EdgeInsets.all(1.0),
          //     ))
          //         .toList(),
          //   ),
          // ),

        ],
      ),

    );
  }
  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                _buildStepIndicator(),
                // new ListTile(
                //     leading: new Icon(Icons.music_note),
                //     title: new Text('Music'),
                //     onTap: () => {}
                // ),
                // new ListTile(
                //   leading: new Icon(Icons.videocam),
                //   title: new Text('Video'),
                //   onTap: () => {},
                // ),
              ],
            ),
          );
        }
    );
  }
}



class DetailScreen extends StatelessWidget {
  final String img;

  DetailScreen({this.img});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(

              "http://rankme.ml/dashbord/dist/"+img,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
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
