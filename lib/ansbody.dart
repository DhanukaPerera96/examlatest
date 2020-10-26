import 'package:educationapp/finalres.dart';
import 'package:educationapp/homepage.dart';
import 'package:educationapp/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_view_indicators/step_page_indicator.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';

class AnsBody extends StatefulWidget {
  //final List quesList = List();
  final int pageNo;
  final List<dynamic> quesList;
  final List<dynamic> mapped;
  final int correct;
  final double tot;
  final Map ansList;
  final String mcqId;
  final String subId, setEnd;
  final int time, iniTime;

  AnsBody({List<dynamic> quesList, List<dynamic> mapped, this.pageNo, this.correct, this.tot, this.ansList, this.mcqId, this.subId, this.time, this.iniTime, this.setEnd}) : this.quesList = quesList, this.mapped = mapped ?? [];

  @override
  _AnsBodyState createState() => _AnsBodyState();
}

class _AnsBodyState extends State<AnsBody> {
  bool ansOneB ;
  bool ansTwoB ;
  bool ansThreeB ;
  bool ansFourB ;
  bool ansFiveB ;
  int endTime;
  List userData = List();
  List addsData = List();
  String udId;
  String addPath;
  String userDisId;
  int qNumber;
  int pgNo;
  String qNo, ansNo, selectedFinal;
  double total;
  int corPrev, quesAmt;
  Map<String, int> finQAndAList = {};
  int strtEndT, transTime;
  bool isClosed = true;
  int timeLeft;
  int t;

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
  int current_index;

  int groupVal = 0;



  ScrollController _controller;

  @override
  void initState() {


    

    // TODO: implement initState
    super.initState();
    // print(widget.pageNo);
    // print(widget.quesList[widget.pageNo]);

    List map = widget.mapped;
    print(map);
    print("Map Ans Called");
    // print(widget.mapped[widget.pageNo]);

    pgNo = widget.pageNo;
    // print(map[pgNo]);



    

    corPrev  = widget.correct;
    finQAndAList = widget.ansList;
    pgNo = widget.pageNo;
    current_index = pgNo;
    strtEndT = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    setState(() {
      t = widget.time;
      endTime = widget.iniTime + t;
      _currentPageNotifier.value = widget.pageNo;



      // ansOneB = widget.mapped[widget.pageNo] == 1 ? true: false;
      // ansTwoB = widget.mapped[widget.pageNo] == 2 ? true: false;
      // ansThreeB = widget.mapped[widget.pageNo] == 3 ? true: false;
      // ansFourB = widget.mapped[widget.pageNo] == 4 ? true: false;
      // ansFiveB = widget.mapped[widget.pageNo] == 5 ? true: false;

    });

    print(widget.time);
    getUserData();
    // print(map[pgNo]);
    if(map[pgNo] != null){
      setState(() {
        _currentPageNotifier.value = 0;

        var myInt = int.parse(map[pgNo]);
        assert(myInt is int);
        groupVal = myInt;

      });
    }

  }

  mapAns(){
    
  }


  // PageController pageController = PageController(viewportFraction: .2,initialPage: 0,keepPage:true );

  _onPageViewChange(int page) {


    // setState(() {
    //
    //   current_index=page;
    //
    // });
    print("Current Page: " + page.toString());
    int previousPage = page;

    if(page != 0) previousPage--;


    else previousPage = 2;

    print("Previous page: $previousPage");
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
          userDisId = userData[0]['district_id'];
        });
        getAdds(widget.mcqId, userDisId);
      }
    }
  }

  getAdds(ppr, dis)async{

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String mcqPpr = ppr;
    String district = dis;

    var url = 'http://rankme.ml/getAdds.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "ppr" : mcqPpr,
          "district" : district,
        }
    );
    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          addsData = json.decode(jsonDataString.toString());
          addPath = addsData[0]['img'];
        });
      }
    }
  }


      String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
    String timeL = timeLeft.toString();

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
          "time" : timeL,
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

    var restTime =  (endTime - transTime);


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


      widget.mapped[pgNo] = ans;
      print(widget.quesList);
       print(widget.pageNo + 1);
        print(corPrev);
         print(finQAndAList);
          print(widget.mcqId);
           print(widget.subId);
            print(restTime);
             print(widget.iniTime);
             print(widget.setEnd);
             print(widget.mapped);

      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: widget.quesList,
                pageNo: widget.pageNo + 1,
                correct: corPrev,
                ansList: finQAndAList,
                mcqId: widget.mcqId,
                subId: widget.subId,
                time : timeLeft,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,
                mapped : widget.mapped,

              )
      ));
      // pageController.animateToPage(
      //     current_index +1 ,
      //     duration: const Duration(milliseconds: 400),
      //     curve: Curves.easeInOut,
      //   );
    }
    else if(ans == null) {

      // widget.mapped[widget.pageNo] = 0;


      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: widget.quesList,
                pageNo: widget.pageNo + 1,
                correct: corPrev,
                ansList: finQAndAList,
                mcqId: widget.mcqId,
                subId: widget.subId,
                time: timeLeft,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,
                mapped : widget.mapped,

              )
      ));
      // pageController.animateToPage(
      //       current_index +1 ,
      //       duration: const Duration(milliseconds: 400),
      //       curve: Curves.easeInOut,
      //     );
    }


  }

  validateAnsSpec(ans, pg){

    setState(() {
      isClosed = false;
    });

    transTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

    var restTime =  (endTime - transTime);


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


      widget.mapped[pgNo] = ans;

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: widget.quesList,
                pageNo: pg,
                correct: corPrev,
                ansList: finQAndAList,
                mcqId: widget.mcqId,
                subId: widget.subId,
                time : timeLeft,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,
                mapped : widget.mapped,

              )
      ), (Route<dynamic> route) => false);
      // pageController.animateToPage(
      //   current_index +1 ,
      //   duration: const Duration(milliseconds: 400),
      //   curve: Curves.easeInOut,
      // );
    }
    else if(ans == null) {

      // widget.mapped[widget.pageNo] = 0;


     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: widget.quesList,
                pageNo: pg,
                correct: corPrev,
                ansList: finQAndAList,
                mcqId: widget.mcqId,
                subId: widget.subId,
                time: timeLeft,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,
                mapped : widget.mapped,

              )
      ), (Route<dynamic> route) => false);
      // pageController.animateToPage(
      //   current_index +1 ,
      //   duration: const Duration(milliseconds: 400),
      //   curve: Curves.easeInOut,
      // );
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
                    time : timeLeft,
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
                        time: timeLeft,
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

  validateAnsFinalTime(ans){

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
            time : timeLeft,
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
                time: timeLeft,
                iniTime: widget.iniTime,
                setEnd : widget.setEnd,
              )
      ));
    }



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

            itemCount: widget.quesList.length,
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



    mapAns();

    bool _allow = false;
    Size size = MediaQuery.of(context).size;

    if(pgNo > 2){
      double doubleVar = pgNo.toDouble();
      double val = (size.width*0.14)*(doubleVar-2.0);
      _controller = ScrollController(initialScrollOffset: val);
    }

    String _printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Countdown(

                seconds: t,
                build: (_, double time) {

                  final now = Duration(seconds: time.toInt());
                  // print("${_printDuration(now)}");

                    timeLeft = time.toInt();


                  var t = time/ 60;
                  return Text(
                    _printDuration(now),
                    style: GoogleFonts.yesevaOne(
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w600,
                            color: Colors.red
                        ),
                  );
                },
                interval: Duration(milliseconds: 100),
                onFinished: () {
                  print('Timer is done!');
                  validateAnsFinalTime(selectedFinal);


                },
              ),

              // CountdownTimer(endTime: endTime,
              //   hoursTextStyle:GoogleFonts.yesevaOne(
              //       fontSize: size.width * 0.05,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.red
              //   ),
              //   minTextStyle: GoogleFonts.yesevaOne(
              //       fontSize: size.width * 0.05,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.red
              //   ),
              //   secTextStyle: GoogleFonts.yesevaOne(
              //       fontSize: size.width * 0.05,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.redAccent
              //   ),
              //
              //   onEnd: (){
              //     print("Game Over");
              //     // Navigator.push(context, MaterialPageRoute(
              //     //     builder: (context) => FinalRes(
              //     //       tot : total,
              //     //     )
              //     // ));
              //     //validateAns(selectedFinal);
              //     // validateAnsFinalTime(selectedFinal);
              //   },
              // ),
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
                        image: NetworkImage(widget.quesList[widget.pageNo]['image']),
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

                    ListTile(
                      title:
                        Text(widget.quesList[widget.pageNo]['ans_one']),

                      leading: Radio(
                        value: 1,
                        groupValue: groupVal,
                        onChanged: (int value) {
                          setState(() {
                            groupVal = value;
                            selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          });

                        },
                      ),
                        subtitle: widget.quesList[widget.pageNo]['ans_one_img'] != null ? ((!(widget.quesList[widget.pageNo]['ans_one_img']).isEmpty) ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.quesList[widget.pageNo]['ans_one_img']),
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
                        ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                    ),

                    ListTile(
                        title: Text(widget.quesList[widget.pageNo]['ans_two']),

                        leading: Radio(
                          value: 2,
                          groupValue: groupVal,
                          onChanged: (int value) {
                            setState(() {
                              groupVal = value;
                              selectedFinal = widget.quesList[widget.pageNo]['ans_two_no'];
                            });

                          },
                        ),
                        subtitle: widget.quesList[widget.pageNo]['ans_two_img'] != null ? ((!(widget.quesList[widget.pageNo]['ans_two_img']).isEmpty) ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.quesList[widget.pageNo]['ans_two_img']),
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
                        ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                    ),

                    ListTile(
                        title:
                        Text(widget.quesList[widget.pageNo]['ans_three']),

                        leading: Radio(
                          value: 3,
                          groupValue: groupVal,
                          onChanged:(int value) {
                            setState(() {
                              groupVal = value;
                              selectedFinal = widget.quesList[widget.pageNo]['ans_three_no'];
                            });

                          },
                        ),
                        subtitle: widget.quesList[widget.pageNo]['ans_three_img'] != null ? ((!(widget.quesList[widget.pageNo]['ans_three_img']).isEmpty) ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.quesList[widget.pageNo]['ans_three_img']),
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
                        ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                    ),

                    ListTile(
                        title:
                        Text(widget.quesList[widget.pageNo]['ans_four']),

                        leading: Radio(
                          value: 4,
                          groupValue: groupVal,
                          onChanged: (int value) {
                            setState(() {
                              groupVal = value;
                              selectedFinal = widget.quesList[widget.pageNo]['ans_four_no'];
                            });

                          },
                        ),
                        subtitle: widget.quesList[widget.pageNo]['ans_four_img'] != null ? ((!(widget.quesList[widget.pageNo]['ans_four_img']).isEmpty) ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.quesList[widget.pageNo]['ans_four_img']),
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
                        ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                    ),

                    (!(widget.quesList[widget.pageNo]['ans_five']).isEmpty) ? ListTile(
                        title: Text(widget.quesList[widget.pageNo]['ans_five']),

                        leading: Radio(
                          value: 5,
                          groupValue: groupVal,
                          onChanged: (int value) {
                            setState(() {
                              groupVal = value;
                              selectedFinal = widget.quesList[widget.pageNo]['ans_five_no'];
                            });

                          },
                        ),
                        subtitle: widget.quesList[widget.pageNo]['ans_five_img'] != null ? ((!(widget.quesList[widget.pageNo]['ans_five_img']).isEmpty) ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.quesList[widget.pageNo]['ans_five_img']),
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
                        ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                    ): SizedBox(height: 1.0,),

                    // CheckboxListTile(
                    //
                    //     title: Text(widget.quesList[widget.pageNo]['ans_one']),
                    //     value: ansOneB,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         // _onSubSelected(val,list['id']);
                    //         // print(mcqQuestions[0]['no']);
                    //         // print(mcqQuestions[0]['answer']);
                    //         // print(mcqQuestions[0]['ans_one_no']);
                    //         // qNo = mcqQuestions[0]['no'];
                    //         // ansNo = mcqQuestions[0]['answer'];
                    //         // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                    //         ansOneB = true;
                    //         ansFiveB = false;
                    //         ansTwoB = false;
                    //         ansThreeB = false;
                    //         ansFourB = false;
                    //         selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                    //         // qNumber = int.parse(qNo);
                    //         // assert(qNumber is int);
                    //       });
                    //       // print(selectedSubList);
                    //     },
                    //     subtitle: widget.quesList[widget.pageNo]['ans_one_img'] != null ? Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: GestureDetector(
                    //         child: Container(
                    //           decoration: new BoxDecoration(
                    //             image: DecorationImage(
                    //               image: NetworkImage("http://rankme.ml/dashboard/assets/img/full-screen-image-4.jpg"+widget.quesList[widget.pageNo]['ans_one_img']),

                    //               fit: BoxFit.cover,
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           height: size.height*0.09,
                    //           width: size.width*0.1,
                    //         ),
                    //         onTap: (){
                    //           Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //             return DetailScreen(
                    //               img: widget.quesList[widget.pageNo]['ans_one_img'],
                    //             );
                    //           }));
                    //         },
                    //       ),
                    //     ): Container(width: 0, height: 0)
                    // ),
                    // Divider(
                    //   thickness: 1,
                    //   color: Colors.grey,
                    // ),
                    // CheckboxListTile(
                    //     title: Text(widget.quesList[widget.pageNo]['ans_two']),
                    //     value: ansTwoB,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         // _onSubSelected(val,list['id']);
                    //         // print(mcqQuestions[0]['no']);
                    //         // print(mcqQuestions[0]['answer']);
                    //         // print(mcqQuestions[0]['ans_two_no']);
                    //         // qNo = mcqQuestions[0]['no'];
                    //         // ansNo = mcqQuestions[0]['answer'];
                    //         // selectedNoTwo = mcqQuestions[0]['ans_two_no'];
                    //         ansTwoB = true;
                    //         ansFiveB = false;
                    //         ansOneB = false;
                    //         ansThreeB = false;
                    //         ansFourB = false;
                    //         selectedFinal = widget.quesList[widget.pageNo]['ans_two_no'];
                    //         // qNumber = int.parse(qNo);
                    //         // assert(qNumber is int);
                    //       });
                    //       // print(selectedSubList);
                    //
                    //     },
                    //     subtitle: widget.quesList[widget.pageNo]['ans_two_img'] != null ? Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: GestureDetector(
                    //         child: Container(
                    //           decoration: new BoxDecoration(
                    //             image: DecorationImage(
                    //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_two_img']),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           height: size.height*0.09,
                    //           width: size.width*0.1,
                    //         ),
                    //         onTap: (){
                    //           Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //             return DetailScreen(
                    //               img: widget.quesList[widget.pageNo]['ans_two_img'],
                    //             );
                    //           }));
                    //         },
                    //       ),
                    //     ): Container(width: 0, height: 0)
                    // ),
                    // Divider(
                    //   thickness: 1,
                    //   color: Colors.grey,
                    // ),
                    // CheckboxListTile(
                    //     title: Text(widget.quesList[widget.pageNo]['ans_three']),
                    //     value: ansThreeB,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         // _onSubSelected(val,list['id']);
                    //         // print(mcqQuestions[0]['no']);
                    //         // print(mcqQuestions[0]['answer']);
                    //         // print(mcqQuestions[0]['ans_three_no']);
                    //         // qNo = mcqQuestions[0]['no'];
                    //         // ansNo = mcqQuestions[0]['answer'];
                    //         // selectedNoThree = mcqQuestions[0]['ans_three_no'];
                    //         ansThreeB = true;
                    //         ansFiveB = false;
                    //         ansOneB = false;
                    //         ansTwoB = false;
                    //         ansFourB = false;
                    //         selectedFinal = widget.quesList[widget.pageNo]['ans_three_no'];
                    //         // qNumber = int.parse(qNo);
                    //         // assert(qNumber is int);
                    //       });
                    //       // print(selectedSubList);
                    //     },
                    //     subtitle: widget.quesList[widget.pageNo]['ans_three_img'] != null ? Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: GestureDetector(
                    //         child: Container(
                    //           decoration: new BoxDecoration(
                    //             image: DecorationImage(
                    //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_three_img']),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           height: size.height*0.09,
                    //           width: size.width*0.1,
                    //         ),
                    //         onTap: (){
                    //           Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //             return DetailScreen(
                    //               img: widget.quesList[widget.pageNo]['ans_three_img'],
                    //             );
                    //           }));
                    //         },
                    //       ),
                    //     ): Container(width: 0, height: 0)
                    // ),
                    // Divider(
                    //   thickness: 1,
                    //   color: Colors.grey,
                    // ),
                    // CheckboxListTile(
                    //     title: Text(widget.quesList[widget.pageNo]['ans_four']),
                    //     value: ansFourB,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         // _onSubSelected(val,list['id']);
                    //         // print(mcqQuestions[0]['no']);
                    //         // print(mcqQuestions[0]['answer']);
                    //         // print(mcqQuestions[0]['ans_four_no']);
                    //         // qNo = mcqQuestions[0]['no'];
                    //         // ansNo = mcqQuestions[0]['answer'];
                    //         // selectedNoFour = mcqQuestions[0]['ans_four_no'];
                    //         ansFourB = true;
                    //         ansFiveB = false;
                    //         ansOneB = false;
                    //         ansTwoB = false;
                    //         ansThreeB = false;
                    //         selectedFinal = widget.quesList[widget.pageNo]['ans_four_no'];
                    //         // qNumber = int.parse(qNo);
                    //         // assert(qNumber is int);
                    //       });
                    //       // print(selectedSubList);
                    //     },
                    //     subtitle: widget.quesList[widget.pageNo]['ans_four_img'] != null ? Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: GestureDetector(
                    //         child: Container(
                    //           decoration: new BoxDecoration(
                    //             image: DecorationImage(
                    //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_four_img']),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           height: size.height*0.09,
                    //           width: size.width*0.1,
                    //         ),
                    //         onTap: (){
                    //           Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //             return DetailScreen(
                    //               img: widget.quesList[widget.pageNo]['ans_four_img'],
                    //             );
                    //           }));
                    //         },
                    //       ),
                    //     ): Container(width: 0, height: 0)
                    // ),
                    // Divider(
                    //   thickness: 1,
                    //   color: Colors.grey,
                    // ),
                    // (!(widget.quesList[widget.pageNo]['ans_five']).isEmpty) ? CheckboxListTile(
                    //     title: Text(widget.quesList[widget.pageNo]['ans_five']),
                    //     value: ansFiveB,
                    //     onChanged: (val) {
                    //       setState(() {
                    //         // _onSubSelected(val,list['id']);
                    //         // print(mcqQuestions[0]['no']);
                    //         // print(mcqQuestions[0]['answer']);
                    //         // print(mcqQuestions[0]['ans_five_no']);
                    //         // qNo = mcqQuestions[0]['no'];
                    //         // ansNo = mcqQuestions[0]['answer'];
                    //         // selectedNoFive = mcqQuestions[0]['ans_five_no'];
                    //         ansFiveB = true;
                    //         ansOneB = false;
                    //         ansTwoB = false;
                    //         ansThreeB = false;
                    //         ansFourB = false;
                    //         selectedFinal = widget.quesList[widget.pageNo]['ans_five_no'];
                    //         // qNumber = int.parse(qNo);
                    //         // assert(qNumber is int);
                    //       });
                    //       // print(selectedSubList);
                    //     },
                    //     subtitle: widget.quesList[widget.pageNo]['ans_five_img'] != null ? Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: GestureDetector(
                    //         child: Container(
                    //           decoration: new BoxDecoration(
                    //             image: DecorationImage(
                    //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.quesList[widget.pageNo]['ans_five_img']),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           height: size.height*0.09,
                    //           width: size.width*0.1,
                    //         ),
                    //         onTap: (){
                    //           Navigator.push(context, MaterialPageRoute(builder: (_) {
                    //             return DetailScreen(
                    //               img: widget.quesList[widget.pageNo]['ans_five_img'],
                    //             );
                    //           }));
                    //         },
                    //       ),
                    //     ): Container(width: 0, height: 0)
                    // ): SizedBox(
                    //   height: 1.0,
                    // ),

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

            // _buildCircleIndicator5()
            Container(


              //  margin: EdgeInsets.all(20.0),
              height: size.height*0.11,
              child:        Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  GestureDetector(
                    onTap: (){
                      // pageController.animateToPage(
                      //   current_index -1 ,
                      //   duration: const Duration(milliseconds: 400),
                      //   curve: Curves.easeInOut,
                      // );
                      // Navigator.pop(context);
                      int no = pgNo -1;
                      validateAnsSpec(selectedFinal, no);
                    },
                    child: Container(

                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                bottomLeft:  Radius.circular(10),
                                topLeft:  Radius.circular(10)
                            )
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.chevron_left,color: Colors.white)),
                  ),
                  Container(
                    height: size.height*0.1,
                    width: size.width*0.7,
                    padding: EdgeInsets.all(2.0),
                    // child: PageView.builder(
                    //   itemCount: widget.quesList.length,
                    //   controller: pageController,
                    //   onPageChanged: _onPageViewChange,
                    //   itemBuilder: (BuildContext context, int itemIndex,) {
                    //     return GestureDetector(
                    //       child: Container(
                    //           width: 60.0,
                    //           child: Text((itemIndex+1).toString())),
                    //       onTap: (){
                    //         // Navigator.push(context, MaterialPageRoute(
                    //         //     builder: (context) => Review(
                    //         //       showResList : widget.quesList,
                    //         //       userSel: widget.ansList["$itemIndex"],
                    //         //       qNo : itemIndex,
                    //         //       ans : widget.ansList,
                    //         //
                    //         //     )
                    //         // ));
                    //
                    //         // validateAns(selectedFinal);
                    //         print(itemIndex);
                    //         print(pgNo);
                    //
                    //         validateAnsSpec(selectedFinal, itemIndex);
                    //
                    //         // if(pgNo > itemIndex)
                    //         // {
                    //         //   int count =  pgNo- itemIndex;
                    //         //   print("GO back" + count.toString() + "pages" );
                    //         //
                    //         //   int counts = count;
                    //         //
                    //         //   validateAnsSpec(selectedFinal, itemIndex);
                    //         //
                    //         // }
                    //         // else{
                    //         //   validateAnsSpec(selectedFinal, itemIndex); // here must pass the selected page number so have to create a seperate function for this.
                    //         // }
                    //
                    //       },
                    //     );
                    //   },
                    // ),
                    child: ListView(
                      // This next line does the trick.
                      // controller: pageController,
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      children: List.generate(widget.mapped.length,(itemIndex){
                        return GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: pgNo == itemIndex ? Icon(

                          Icons.mode_edit,
                          color: Colors.redAccent,
                          size: size.height*0.04,
                          ):
                                widget.mapped[itemIndex] == null ? Container() :
                                Icon(

                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: size.height*0.04,
                                ),
                              ),
                              Container(

                                  width: size.width*0.14,
                                  height: size.height*0.05,
                                  child: Center(child: Text((itemIndex+1).toString()))
                              ),

                            ],
                          ),
                          onTap: (){
                            print(Text((itemIndex+1).toString()));



                              validateAnsSpec(selectedFinal, itemIndex);


                            // validateAns(selectedFinal);
                          },
                        );
                      }),
                    ),
                  ),


                  GestureDetector(

                    onTap: (){

                      validateAns(selectedFinal);

                      // print(qAndAList.length);
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) =>
                      //         AnsBody(
                      //           quesList: mcqQuestions,
                      //           pageNo: pageNo + 1,
                      //           correct: correct,
                      //           tot: total,
                      //           ansList: qAndAList,
                      //           mcqId: mcqPprId,
                      //           subId : widget.subId,
                      //           time : 300,
                      //           iniTime: strtEndT,
                      //           setEnd : widget.mcqTime,
                      //
                      //         )
                      // ));
                      // pageController.animateToPage(
                      //   current_index +1 ,
                      //   duration: const Duration(milliseconds: 400),
                      //   curve: Curves.easeInOut,
                      // );

                      setState(() {
                        // pgNo = current_index + 1;
                      });
                      /* Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              AnsBody(
                                quesList: widget.quesList,
                                pageNo: current_index + 1,
                                correct: corPrev,
                                ansList: finQAndAList,
                                mcqId: widget.mcqId,
                                subId: widget.subId,
                                time : restTime,
                                iniTime: widget.iniTime,
                                setEnd : widget.setEnd,

                              )
                      ));*/
                    },

                    child: Container(

                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                bottomRight:  Radius.circular(10),
                                topRight:  Radius.circular(10)
                            )
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.keyboard_arrow_right,color: Colors.white,)),
                  ),

                ],
              ),
            ),
            addPath != null ? (((addPath.isNotEmpty))?
            Container(
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(addPath),
                  fit: BoxFit.cover,
                ),
                color: Colors.transparent,
              ),
              height: size.height*0.09,
              width: size.width*0.9,
            ): SizedBox(
              height: 0.1,
            )): SizedBox(
              height: 0.1,
            ),
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
                    // SizedBox(
                    //   width: size.width*0.01,
                    // ),
                    // Expanded(
                    //
                    //   child: widget.pageNo < widget.quesList.length-1 ?  MaterialButton(
                    //     elevation: 2,
                    //     child: Text('Next'),
                    //     onPressed: (){
                    //
                    //       validateAns(selectedFinal);
                    //
                    //     },
                    //     color: Colors.indigoAccent,
                    //   ):
                    //   MaterialButton(
                    //     elevation: 2,
                    //     child: Text('Next'),
                    //     onPressed: null,
                    //     color: Colors.indigoAccent,
                    //   ),
                    // )
                  ],
                ),
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

              img,
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
