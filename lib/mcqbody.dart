import 'package:educationapp/ansbody.dart';
import 'package:educationapp/finalres.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:page_view_indicators/step_page_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:timer_count_down/timer_controller.dart';

class McqBody extends StatefulWidget {

  final String mcqPprId;
  final String mcqTime;
  final String subId;

  McqBody({this.mcqPprId, this.mcqTime, this.subId});

  @override
  _McqBodyState createState() => _McqBodyState();
}

class _McqBodyState extends State<McqBody> {

  final CountdownController controller = CountdownController();

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

  String mcqPprId;
  String pprTime;
  List mcqQuestions = List();
  List mcqQueAns = List();
  List userData = List();
  List addsData = List();
  List mapList = List();

  final Map<String, int> qAndAList = {};
  List list = List();
  String mcqQuesId;
  String ansOne, ansTwo, ansThree, ansFour, correctAns;
  int ansOneNo, ansTwoNo, ansThreeNo, ansFourNo;
  String qNo, ansNo;
  String selectedNoOne, selectedNoTwo, selectedNoThree, selectedNoFour, selectedNoFive, selectedFinal;
  bool ansOneB = false;
  bool ansTwoB = false;
  bool ansThreeB = false;
  bool ansFourB = false;
  bool ansFiveB = false;
  int endTime;
  int transTime;
  int qNumber;
  int pageNo;
  int quesAmt;
  int correct = 0;
  int wrong = 0;
  double total = 0.0;
  int strtEndT;
  bool isClosed = true;
  String udId;
  String addPath;
  String userDisId;
  int groupVal = 0;
  int timeLeft;



  int selectedindex = 1;
  List<Widget> listWidget = new List<Widget>();


  int _lowerCount = -1;
  int _upperCount = 1;

  // final List<Widget> _pages = <Widget>[
  //   new Center(child: new Text("-1", style: new TextStyle(fontSize: 60.0))),
  //   new Center(child: new Text("0", style: new TextStyle(fontSize: 60.0))),
  //   new Center(child: new Text("1", style: new TextStyle(fontSize: 60.0)))
  // ];

  // final List<Widget> _pages = List.castFrom<dynamic, Widget>(mcqQuestions);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mcqPprId = widget.mcqPprId;
    pprTime = widget.mcqTime;
    int countD = int.parse(widget.mcqTime);
    assert(countD is int);
    getMcqQues(mcqPprId);
    endTime = countD * 60;
    strtEndT = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    pageNo = 0;
    getUserData();
    setState(() {
      _currentPageNotifier.value = 0;

    });
  }

  int current_index =0;
  // PageController pageController = PageController(viewportFraction: .2,initialPage: 0,keepPage:true );

  _onPageViewChange(int page) {


    setState(() {

      current_index=page;

    });
    print("Current Page: " + page.toString());
    int previousPage = page;

    if(page != 0) previousPage--;


    else previousPage = 2;

    print("Previous page: $previousPage");
  }

  getAdds(ppr, dis)async{
    print("Get Adds Called");
    print(ppr + "" + dis);

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
          print(addPath);


        });

      }
    }
  }

  //Getting dynamic subjects
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
          mcqQuestions = json.decode(jsonDataString.toString());
//          print(mcqDetails);
          mcqQuesId = mcqQuestions[0]['id'];
          correctAns = mcqQuestions[0]['answer'];
          for(var i = 0; i < mcqQuestions.length; i++){
            mapList.add("0");

          }
          print(mapList.toString());
        });
      }




      // return new Row(children: list);

    }
  }





  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(

        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive
            ? 10:8.0,
        width: isActive
            ? 12:8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
              color: Colors.indigo.withOpacity(0.72),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            )
                : BoxShadow(
              color: Colors.transparent,
            )
          ],
          shape: BoxShape.circle,
          color: isActive ? Colors.indigo : Colors.indigo[300],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < mcqQuestions.length; i++) {
      list.add(i ==  0? _indicator(true) : _indicator(false));
    }
    return list;
  }


  Future<Widget> getMcqAns(mcqQId)async{
    print("GetSUbPapers called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String mcqQsId = mcqQId;

    var url = 'http://rankme.ml/getMcqQAns.php';
    final response = await http.post(Uri.encodeFull(url),headers: {"Accept":"application/json"},
        body: {
          "mcqQId" : mcqQsId,
        }
    );

    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          mcqQueAns = json.decode(jsonDataString.toString());
        });
      }

    }
    for(var i = 0; i < mcqQueAns.length; i++){
      print(mcqQueAns[0]['text']);
      list.add(new Text(mcqQueAns[0]['text']));
    }
    return new Column(children: list);
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
          print(userDisId);

        });
        getAdds(widget.mcqPprId, userDisId);
      }
    }
  }
  pauseExit(){
    transTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

    String uId = udId;
    String subId = widget.subId;
    String ppr = widget.mcqPprId;
    int time = (endTime - transTime)+3000;
    double tot = total;
    int page = 0;

    print(uId);
    print(subId);
    print(ppr);
    print(time);
    print(tot);
    print(page);

  }

  validateAns(ans){

    setState(() {
      isClosed = false;
    });
    transTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

    var restTime =  (endTime - transTime);
    // print(transTime);
    // print(strtEndT);
    // print(restTime);
    // print((endTime * 1000* 60) - transTime);

    if(ans != null) {
      int corAns = int.parse(mcqQuestions[0]['answer']);
      quesAmt = mcqQuestions.length;
      assert(corAns is int);
      int selAns = int.parse(ans);
      assert(selAns is int);
      print(ans);
      print(corAns);
      if (selAns == corAns) {
        print("Question " + mcqQuestions[0]['no'] + " Correct");
        correct = correct + 1;
      }
      else {
        print("Question " + mcqQuestions[0]['no'] + " wrong");
        wrong = wrong + 1;
      }
      setState(() {
        total = (correct / quesAmt) * 100;
        qAndAList["$pageNo"] = selAns;
      });

      mapList[0] = ans;
      print(mapList);

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: mcqQuestions,
                pageNo: pageNo + 1,
                correct: correct,
                tot: total,
                ansList: qAndAList,
                mcqId: mcqPprId,
                subId : widget.subId,
                time : timeLeft,
                iniTime: strtEndT,
                setEnd : pprTime,
                mapped : mapList,

              )
      ));
      // pageController.animateToPage(
      //     current_index +1 ,
      //     duration: const Duration(milliseconds: 400),
      //     curve: Curves.easeInOut,
      //   );
    }
    else if(ans == null) {

      setState(() {
         qAndAList["$pageNo"] = 0;
      });

      // mapList[0] = 0;

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: mcqQuestions,
                pageNo: pageNo + 1,
                correct: correct,
                tot: total,
                ansList: qAndAList,
                mcqId: mcqPprId,
                subId: widget.subId,
                time: timeLeft,
                iniTime: strtEndT,
                setEnd : pprTime,
                mapped : mapList,

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
    // print(transTime);
    // print(strtEndT);
    // print(restTime);
    // print((endTime * 1000* 60) - transTime);

    if(ans != null) {
      int corAns = int.parse(mcqQuestions[0]['answer']);
      quesAmt = mcqQuestions.length;
      assert(corAns is int);
      int selAns = int.parse(ans);
      assert(selAns is int);
      print(ans);
      print(corAns);
      if (selAns == corAns) {
        print("Question " + mcqQuestions[0]['no'] + " Correct");
        correct = correct + 1;
      }
      else {
        print("Question " + mcqQuestions[0]['no'] + " wrong");
        wrong = wrong + 1;
      }
      setState(() {
        total = (correct / quesAmt) * 100;
        qAndAList["$pageNo"] = selAns;
      });

      mapList[0] = ans;
      print(mapList);

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: mcqQuestions,
                pageNo: pg,
                correct: correct,
                tot: total,
                ansList: qAndAList,
                mcqId: mcqPprId,
                subId : widget.subId,
                time : timeLeft,
                iniTime: strtEndT,
                setEnd : pprTime,
                mapped : mapList,

              )
      ));
      // pageController.animateToPage(
      //   current_index +1 ,
      //   duration: const Duration(milliseconds: 400),
      //   curve: Curves.easeInOut,
      // );
    }
    else if(ans == null) {

      setState(() {
         qAndAList["$pageNo"] = 0;
      });


      // mapList[0] = 0;

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) =>
              AnsBody(
                quesList: mcqQuestions,
                pageNo: pg,
                correct: correct,
                tot: total,
                ansList: qAndAList,
                mcqId: mcqPprId,
                subId: widget.subId,
                time: timeLeft,
                iniTime: strtEndT,
                setEnd : pprTime,
                mapped : mapList,

              )
      ));
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
      title: "Do You want to Finish the paper?",
      desc: "You won't be able to change the answer again!",
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
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
              int corAns = int.parse(mcqQuestions[0]['answer']);
              quesAmt = mcqQuestions.length;
              assert(corAns is int);
              int selAns = int.parse(ans);
              assert(selAns is int);
              print(ans);
              print(corAns);
              if(selAns == corAns)
              {
                print("Question "+ mcqQuestions[0]['no'] +" Correct");
                correct =  correct + 1;
              }
              else{
                print("Question "+ mcqQuestions[0]['no'] +" wrong");
                wrong = wrong+1;
              }
              qAndAList["$pageNo"] = selAns ;

              total = (correct/quesAmt)*100;
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FinalRes(
                    tot : total,
                    mapped: mapList,
                    realAns : mcqQuestions,
                    mcqId: mcqPprId,
                    subId : widget.subId,
                    time : timeLeft,
                    iniTime: strtEndT,
                    setEnd : widget.mcqTime,
                  )
              ));

            }
            else if(ans == null)
            {

              setState(() {
         qAndAList["$pageNo"] = 0;
      });

              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FinalRes(
                    tot : total,
                    mapped: mapList,
                    realAns : mcqQuestions,
                    mcqId: mcqPprId,
                    subId : widget.subId,
                    time : timeLeft,
                    iniTime: strtEndT,
                    setEnd : widget.mcqTime,
                  )
              ));}
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
      int corAns = int.parse(mcqQuestions[0]['answer']);
      quesAmt = mcqQuestions.length;
      assert(corAns is int);
      int selAns = int.parse(ans);
      assert(selAns is int);
      print(ans);
      print(corAns);
      if(selAns == corAns)
      {
        print("Question "+ mcqQuestions[0]['no'] +" Correct");
        correct =  correct + 1;
      }
      else{
        print("Question "+ mcqQuestions[0]['no'] +" wrong");
        wrong = wrong+1;
      }
      qAndAList["$pageNo"] = selAns ;

      total = (correct/quesAmt)*100;
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => FinalRes(
            tot : total,
            mapped: mapList,
            realAns : mcqQuestions,
            mcqId: mcqPprId,
            subId : widget.subId,
            time : timeLeft,
            iniTime: strtEndT,
            setEnd : widget.mcqTime,
          )
      ));

    }
    else if(ans == null)
    {
      setState(() {
         qAndAList["$pageNo"] = 0;
      });

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => FinalRes(
            tot : total,
            mapped: mapList,
            realAns : mcqQuestions,
            mcqId: mcqPprId,
            subId : widget.subId,
            time : timeLeft,
            iniTime: strtEndT,
            setEnd : widget.mcqTime,
          )
      ));}




  }

  _buildCircleIndicator5() {
    return CirclePageIndicator(
      size: 8.0,
      selectedSize: 16.0,
      dotColor: Colors.black,
      selectedDotColor: Colors.blue,
      itemCount: mcqQuestions.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }
  _buildStepIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(

          color: Colors.white70,
          padding: const EdgeInsets.all(16.0),
          child: StepPageIndicator(
            itemCount: mcqQuestions.length,
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

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {



    Size size = MediaQuery.of(context).size;
    bool _allow = false;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(

          title: Text("Quiz Starting"),
        ),
        body: mcqQuestions.length == 0?

        Container(
          color: Colors.indigo[100],
          height: size.height*1,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: JumpingDotsProgressIndicator(
                    fontSize: size.height*0.1,
                  ),
                ),
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

            : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child:  CountdownTimer(
                //   endTime: endTime,
                //  /* hoursTextStyle:GoogleFonts.yesevaOne(
                //       fontSize: size.width * 0.05,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.red
                //   ),
                //   minTextStyle: GoogleFonts.yesevaOne(
                // fontSize: size.width * 0.05,
                //     fontWeight: FontWeight.w600,
                //     color: Colors.red
                // ),
                //   secTextStyle: GoogleFonts.yesevaOne(
                //       fontSize: size.width * 0.05,
                //       fontWeight: FontWeight.w600,
                //       color: Colors.redAccent
                //   ),*/
                //
                //
                //   onEnd: (){
                //     print("Game Over");
                //     // validateAnsFinalTime(selectedFinal);
                //
                //     // Navigator.push(context, MaterialPageRoute(
                //     //     builder: (context) => FinalRes(
                //     //       tot : total,
                //     //     )
                //     // ));
                //   },
                // ),
                child: Countdown(
                  controller: controller,
                  seconds: endTime,
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
              ),
              Container(
                height: size.height*0.8,
                margin: EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Container(
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        //   child: Row(
                        //     children: [
                        //
                        //
                        //     ],
                        //   ),
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mcqQuestions[0]['text']),
                            mcqQuestions[0]['image'] != null ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: new BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(mcqQuestions[0]['image']),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.transparent,
                                ),
                                height: size.height*0.2,
                                width: size.width*0.1,
                              ),
                            ): SizedBox(
                              height: 1.0,
                            ),
                          ],

                        ),

                        Expanded(
                          child: Container(
                            child: ListView(
                              children: <Widget>[

                                ListTile(
                                    title:
                                    Text(mcqQuestions[0]['ans_one']),

                                    leading: Radio(
                                      value: 1,
                                      groupValue: groupVal,
                                      onChanged: (int value) {
                                        setState(() {
                                          groupVal = value;
                                          selectedFinal = mcqQuestions[0]['ans_one_no'];
                                        });

                                      },
                                    ),
                                    subtitle: mcqQuestions[0]['ans_one_img'] != null ? ((!(mcqQuestions[0]['ans_one_img']).isEmpty) ?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(mcqQuestions[0]['ans_one_img']),
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
                                              img: mcqQuestions[0]['ans_one_img'],
                                            );
                                          }));
                                        },
                                      ),
                                    ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                                ),

                                ListTile(
                                    title: Text(mcqQuestions[0]['ans_two']),

                                    leading: Radio(
                                      value: 2,
                                      groupValue: groupVal,
                                      onChanged: (int value) {
                                        setState(() {
                                          groupVal = value;
                                          selectedFinal = mcqQuestions[0]['ans_two_no'];
                                        });

                                      },
                                    ),
                                    subtitle: mcqQuestions[0]['ans_two_img'] != null ? ((!(mcqQuestions[0]['ans_two_img']).isEmpty) ?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(mcqQuestions[0]['ans_two_img']),
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
                                              img: mcqQuestions[0]['ans_two_img'],
                                            );
                                          }));
                                        },
                                      ),
                                    ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                                ),

                                ListTile(
                                    title:
                                    Text(mcqQuestions[0]['ans_three']),

                                    leading: Radio(
                                      value: 3,
                                      groupValue: groupVal,
                                      onChanged:(int value) {
                                        setState(() {
                                          groupVal = value;
                                          selectedFinal = mcqQuestions[0]['ans_three_no'];
                                        });

                                      },
                                    ),
                                    subtitle: mcqQuestions[0]['ans_three_img'] != null ? ((!(mcqQuestions[0]['ans_three_img']).isEmpty) ?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(mcqQuestions[0]['ans_three_img']),
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
                                              img: mcqQuestions[0]['ans_three_img'],
                                            );
                                          }));
                                        },
                                      ),
                                    ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                  ),

                                ListTile(
                                    title:
                                    Text(mcqQuestions[0]['ans_four']),

                                    leading: Radio(
                                      value: 4,
                                      groupValue: groupVal,
                                      onChanged: (int value) {
                                        setState(() {
                                          groupVal = value;
                                          selectedFinal = mcqQuestions[0]['ans_four_no'];
                                        });

                                      },
                                    ),
                                    subtitle: mcqQuestions[0]['ans_four_img'] != null ? ((!(mcqQuestions[0]['ans_four_img']).isEmpty) ?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(mcqQuestions[0]['ans_four_img']),
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
                                              img: mcqQuestions[0]['ans_four_img'],
                                            );
                                          }));
                                        },
                                      ),
                                    ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                                ),

                                (!(mcqQuestions[0]['ans_five']).isEmpty) ? ListTile(
                                    title: Text(mcqQuestions[0]['ans_five']),

                                    leading: Radio(
                                      value: 5,
                                      groupValue: groupVal,
                                      onChanged: (int value) {
                                        setState(() {
                                          groupVal = value;
                                          selectedFinal = mcqQuestions[0]['ans_five_no'];
                                        });

                                      },
                                    ),
                                    subtitle: mcqQuestions[0]['ans_five_img'] != null ? ((!(mcqQuestions[0]['ans_five_img']).isEmpty) ?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(mcqQuestions[0]['ans_five_img']),
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
                                              img: mcqQuestions[0]['ans_five_img'],
                                            );
                                          }));
                                        },
                                      ),
                                    ): Container(width: 0, height: 0)): Container(width: 0, height: 0),
                                ): SizedBox(height: 1.0,),

                                // CheckboxListTile(
                                //
                                //     title: Text(mcqQuestions[0]['ans_one']),
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
                                //         selectedFinal = mcqQuestions[0]['ans_one_no'];
                                //         // qNumber = int.parse(qNo);
                                //         // assert(qNumber is int);
                                //       });
                                //       // print(selectedSubList);
                                //     },
                                //     subtitle: mcqQuestions[0]['ans_one_img'] != null ? Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: GestureDetector(
                                //         child: Container(
                                //           decoration: new BoxDecoration(
                                //             image: DecorationImage(
                                //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+mcqQuestions[0]['ans_one_img']),
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
                                //               img: mcqQuestions[0]['ans_one_img'],
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
                                //     title: Text(mcqQuestions[0]['ans_two']),
                                //     value: ansTwoB,
                                //     onChanged: (val) {
                                //       setState(() {
                                //         // _onSubSelected(val,list['id']);
                                //         // print(mcqQuestions[0]['no']);
                                //         // print(mcqQuestions[0]['answer']);
                                //         // print(mcqQuestions[0]['ans_two_no']);
                                //         // qNo = mcqQuestions[0]['no'];
                                //         // ansNo = mcqQuestions[0]['answer'];
                                //         selectedFinal = mcqQuestions[0]['ans_two_no'];
                                //         ansTwoB = true;
                                //         ansFiveB = false;
                                //         ansOneB = false;
                                //         ansThreeB = false;
                                //         ansFourB = false;
                                //         // qNumber = int.parse(qNo);
                                //         // assert(qNumber is int);
                                //       });
                                //       // print(selectedSubList);
                                //
                                //     },
                                //     subtitle: mcqQuestions[0]['ans_two_img'] != null ? Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: GestureDetector(
                                //         child: Container(
                                //           decoration: new BoxDecoration(
                                //             image: DecorationImage(
                                //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+mcqQuestions[0]['ans_two_img']),
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
                                //               img: mcqQuestions[0]['ans_two_img'],
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
                                //     title: Text(mcqQuestions[0]['ans_three']),
                                //     value: ansThreeB,
                                //     onChanged: (val) {
                                //       setState(() {
                                //         // _onSubSelected(val,list['id']);
                                //         // print(mcqQuestions[0]['no']);
                                //         // print(mcqQuestions[0]['answer']);
                                //         // print(mcqQuestions[0]['ans_three_no']);
                                //         // qNo = mcqQuestions[0]['no'];
                                //         // ansNo = mcqQuestions[0]['answer'];
                                //         selectedFinal = mcqQuestions[0]['ans_three_no'];
                                //         ansThreeB = true;
                                //         ansFiveB = false;
                                //         ansOneB = false;
                                //         ansTwoB = false;
                                //         ansFourB = false;
                                //         // qNumber = int.parse(qNo);
                                //         // assert(qNumber is int);
                                //       });
                                //       // print(selectedSubList);
                                //     },
                                //     subtitle: mcqQuestions[0]['ans_three_img'] != null ? Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: GestureDetector(
                                //         child: Container(
                                //           decoration: new BoxDecoration(
                                //             image: DecorationImage(
                                //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+mcqQuestions[0]['ans_three_img']),
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
                                //               img: mcqQuestions[0]['ans_three_img'],
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
                                //     title: Text(mcqQuestions[0]['ans_four']),
                                //     value: ansFourB,
                                //     onChanged: (val) {
                                //       setState(() {
                                //         // _onSubSelected(val,list['id']);
                                //         // print(mcqQuestions[0]['no']);
                                //         // print(mcqQuestions[0]['answer']);
                                //         // print(mcqQuestions[0]['ans_four_no']);
                                //         // qNo = mcqQuestions[0]['no'];
                                //         // ansNo = mcqQuestions[0]['answer'];
                                //         selectedFinal = mcqQuestions[0]['ans_four_no'];
                                //         ansFourB = true;
                                //         ansFiveB = false;
                                //         ansOneB = false;
                                //         ansTwoB = false;
                                //         ansThreeB = false;
                                //         // qNumber = int.parse(qNo);
                                //         // assert(qNumber is int);
                                //       });
                                //       // print(selectedSubList);
                                //     },
                                //     subtitle: mcqQuestions[0]['ans_four_img'] != null ? Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: GestureDetector(
                                //         child: Container(
                                //           decoration: new BoxDecoration(
                                //             image: DecorationImage(
                                //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+mcqQuestions[0]['ans_four_img']),
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
                                //               img: mcqQuestions[0]['ans_four_img'],
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
                                // (!(mcqQuestions[0]['ans_five']).isEmpty) ? CheckboxListTile(
                                //     title: Text(mcqQuestions[0]['ans_five']),
                                //     value: ansFiveB,
                                //     onChanged: (val) {
                                //       setState(() {
                                //         // _onSubSelected(val,list['id']);
                                //         // print(mcqQuestions[0]['no']);
                                //         // print(mcqQuestions[0]['answer']);
                                //         // print(mcqQuestions[0]['ans_five_no']);
                                //         // qNo = mcqQuestions[0]['no'];
                                //         // ansNo = mcqQuestions[0]['answer'];
                                //         selectedFinal = mcqQuestions[0]['ans_five_no'];
                                //         ansFiveB = true;
                                //         ansOneB = false;
                                //         ansTwoB = false;
                                //         ansThreeB = false;
                                //         ansFourB = false;
                                //         // qNumber = int.parse(qNo);
                                //         // assert(qNumber is int);
                                //       });
                                //       // print(selectedSubList);
                                //     },
                                //     subtitle: mcqQuestions[0]['ans_five_img'] != null ? Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: GestureDetector(
                                //         child: Container(
                                //           decoration: new BoxDecoration(
                                //             image: DecorationImage(
                                //               image: NetworkImage("http://rankme.ml/dashbord/dist/"+mcqQuestions[0]['ans_five_img']),
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
                                //               img: mcqQuestions[0]['ans_five_img'],
                                //             );
                                //           }));
                                //         },
                                //       ),
                                //     ): Container(width: 0, height: 0)
                                // ): SizedBox(
                                //   height: 1.0,
                                // ),



                              ],
                            ),
                          ),
                        ),

                        // _buildCircleIndicator5()
                        // Container(
                        //   child: Row(
                        //     children: [
                        //       Expanded(child: Container(
                        //         width: size.width*0.1,
                        //       )),
                        //       FloatingActionButton(
                        //         backgroundColor: Colors.indigo[400],
                        //         onPressed: (){
                        //           _settingModalBottomSheet(context);
                        //         },
                        //         child: new Icon(Icons.arrow_drop_up),
                        //         shape: RoundedRectangleBorder(),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Expanded(
                        //   child: ListView(
                        //     children: <Widget>[
                        //
                        //
                        //
                        //     ]
                        //         .map((item) => Padding(
                        //       child: item,
                        //       padding: EdgeInsets.all(1.0),
                        //     ))
                        //         .toList(),
                        //   ),
                        // ),
                        // SmoothPageIndicator(
                        //                       //     controller: _pageController,  // PageController
                        //                       //     count:  mcqQuestions.length,
                        //                       //     effect:  WormEffect(),  // your preferred effect
                        //                       //     onDotClicked: (index){
                        //                       //
                        //                       //     }
                        //                       // )
                        Container(


                        //  margin: EdgeInsets.all(20.0),
                          height: size.height*0.11,
                          child:        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              GestureDetector(
                                onTap: null,
                                child: Container(

                                    decoration: BoxDecoration(
                                        color: Colors.grey,
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
                                //   itemCount: mcqQuestions.length,
                                //   controller: pageController,
                                //   onPageChanged: _onPageViewChange,
                                //   itemBuilder: (BuildContext context, int itemIndex,) {
                                //     return GestureDetector(
                                //       child: Container(
                                //           width: 60.0,
                                //           child: Text((itemIndex+1).toString())),
                                //       onTap: (){
                                //         print(Text((itemIndex+1).toString()));
                                //
                                //
                                //         if(pageNo < itemIndex)
                                //         {
                                //
                                //           validateAnsSpec(selectedFinal, itemIndex);
                                //
                                //
                                //         }
                                //
                                //         // validateAns(selectedFinal);
                                //       },
                                //     );
                                //   },
                                // ),

                                child: ListView(
                                  // controller: pageController,
                                  // This next line does the trick.
                                  scrollDirection: Axis.horizontal,

                                  children: List.generate(mapList.length,(itemIndex){
                                    return GestureDetector(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child:
                                            mapList[itemIndex] == "0" ? Container() : pageNo == itemIndex ? Icon(

                                              Icons.mode_edit,
                                              color: Colors.redAccent,
                                              size: size.height*0.04,
                                            ):
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


                                        if(pageNo < itemIndex)
                                        {

                                          validateAnsSpec(selectedFinal, itemIndex);


                                        }

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
                          child: Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  elevation: 2,
                                  child: Text('Pause and Exit',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),),
                                  onPressed: null,
                                  color: Colors.redAccent,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              Expanded(
                                child: pageNo < mcqQuestions.length-1 ?  MaterialButton(
                                  elevation: 2,
                                  child: Text('Finish'),
                                  onPressed: (){
                                    validateAnsFinal(selectedFinal);

                                  },
                                  color: Colors.indigoAccent,
                                ):
                                MaterialButton(
                                  elevation: 2,
                                  child: Text('Finish'),
                                  onPressed: (){
                                    validateAnsFinal(selectedFinal);
                                    // Navigator.push(context, MaterialPageRoute(
                                    //     builder: (context) => McqBody(
                                    //
                                    //     )
                                    // ));
                                  },
                                  color: Colors.indigoAccent,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),

                              // Expanded(
                              //
                              //   child:
                              //   MaterialButton(
                              //     elevation: 2,
                              //     child: Text('Next'),
                              //     onPressed: (){
                              //
                              //       validateAns(selectedFinal);
                              //     },
                              //     color: Colors.indigoAccent,
                              //   ),
                              // )

                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
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
