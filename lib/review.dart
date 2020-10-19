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

class Review extends StatefulWidget {

  final List<dynamic> showResList;
  final int userSel;
  final int qNo;
  final Map ans;

  Review({List<dynamic> showResList, this.userSel, this.qNo, this.ans}) : this.showResList = showResList ?? [];

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {


  int current_index =0;
  PageController pageController = PageController(viewportFraction: .2,initialPage: 0,keepPage:true );

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        children: [
          Container(
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.library_books),
                title: Text(widget.showResList[widget.qNo]['text']),
                subtitle: widget.showResList[widget.qNo]['image'] != null ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("http://rankme.ml/dashboard/dist/"+widget.showResList[widget.qNo]['image']),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.transparent,
                    ),
                    height: size.height*0.2,
                    width: size.width*0.1,
                  ),
                ): Container(width: 0, height: 0),
              ),
            ),
          ),
          SizedBox(height: 1.0,),
          Column(
            children: [
              Text("Correct Answer: "+ widget.showResList[widget.qNo]['answer'], style: GoogleFonts.yesevaOne(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              )),
              widget.userSel != null ? Text("You Selected" + widget.userSel.toString(), style: GoogleFonts.yesevaOne(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              )) : Text("You Selected None", style: GoogleFonts.yesevaOne(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              ) ),
            ],
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Card(
                    color: 1 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 1 ? Colors.redAccent : Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text(widget.showResList[widget.qNo]['ans_one']),
                      subtitle: widget.showResList[widget.qNo]['ans_one_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_one_img']),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.transparent,
                          ),
                          height: size.height*0.2,
                          width: size.width*0.1,
                        ),
                      ): Container(width: 0, height: 0),
                    ),
                  ),

                  CheckboxListTile(

                      title: Text(widget.showResList[widget.qNo]['ans_one']),
                      value: widget.userSel == 1 ? true : false,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_one_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                          // ansOneB = true;
                          // ansFiveB = false;
                          // ansTwoB = false;
                          // ansThreeB = false;
                          // ansFourB = false;
                          // selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.showResList[widget.qNo]['ans_one_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_one_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (_) {
                              // return DetailScreen(
                              //   img: widget.quesList[widget.pageNo]['ans_one_img'],
                              // );
                            // }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  CheckboxListTile(

                      title: Text(widget.showResList[widget.qNo]['ans_two']),
                      value: widget.userSel == 2 ? true : false,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_one_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                          // ansOneB = true;
                          // ansFiveB = false;
                          // ansTwoB = false;
                          // ansThreeB = false;
                          // ansFourB = false;
                          // selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.showResList[widget.qNo]['ans_two_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_two_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (_) {
                            // return DetailScreen(
                            //   img: widget.quesList[widget.pageNo]['ans_one_img'],
                            // );
                            // }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  CheckboxListTile(

                      title: Text(widget.showResList[widget.qNo]['ans_three']),
                      value: widget.userSel == 3 ? true : false,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_one_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                          // ansOneB = true;
                          // ansFiveB = false;
                          // ansTwoB = false;
                          // ansThreeB = false;
                          // ansFourB = false;
                          // selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.showResList[widget.qNo]['ans_three_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_three_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (_) {
                            // return DetailScreen(
                            //   img: widget.quesList[widget.pageNo]['ans_one_img'],
                            // );
                            // }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  CheckboxListTile(

                      title: Text(widget.showResList[widget.qNo]['ans_four']),
                      value: widget.userSel == 4 ? true : false,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_one_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                          // ansOneB = true;
                          // ansFiveB = false;
                          // ansTwoB = false;
                          // ansThreeB = false;
                          // ansFourB = false;
                          // selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.showResList[widget.qNo]['ans_four_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_four_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (_) {
                            // return DetailScreen(
                            //   img: widget.quesList[widget.pageNo]['ans_one_img'],
                            // );
                            // }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ),
                  (!(widget.showResList[widget.qNo]['ans_five']).isEmpty) ?CheckboxListTile(

                      title: Text(widget.showResList[widget.qNo]['ans_five']),
                      value: widget.userSel == 5 ? true : false,
                      onChanged: (val) {
                        setState(() {
                          // _onSubSelected(val,list['id']);
                          // print(mcqQuestions[0]['no']);
                          // print(mcqQuestions[0]['answer']);
                          // print(mcqQuestions[0]['ans_one_no']);
                          // qNo = mcqQuestions[0]['no'];
                          // ansNo = mcqQuestions[0]['answer'];
                          // selectedNoOne = mcqQuestions[0]['ans_one_no'];
                          // ansOneB = true;
                          // ansFiveB = false;
                          // ansTwoB = false;
                          // ansThreeB = false;
                          // ansFourB = false;
                          // selectedFinal = widget.quesList[widget.pageNo]['ans_one_no'];
                          // qNumber = int.parse(qNo);
                          // assert(qNumber is int);
                        });
                        // print(selectedSubList);
                      },
                      subtitle: widget.showResList[widget.qNo]['ans_fiver_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_five_img']),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.transparent,
                            ),
                            height: size.height*0.09,
                            width: size.width*0.1,
                          ),
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (_) {
                            // return DetailScreen(
                            //   img: widget.quesList[widget.pageNo]['ans_one_img'],
                            // );
                            // }));
                          },
                        ),
                      ): Container(width: 0, height: 0)
                  ): SizedBox(
                    height: 1.0,
                  ),

                  // Card(
                  //   color: 2 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 2 ? Colors.redAccent : Colors.transparent,
                  //   child: ListTile(
                  //     leading: Icon(Icons.library_books),
                  //     title: Text(widget.showResList[widget.qNo]['ans_two']),
                  //     subtitle: widget.showResList[widget.qNo]['ans_two_img'] != null ? Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //         decoration: new BoxDecoration(
                  //           image: DecorationImage(
                  //             image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_two_img']),
                  //             fit: BoxFit.cover,
                  //           ),
                  //           color: Colors.transparent,
                  //         ),
                  //         height: size.height*0.2,
                  //         width: size.width*0.1,
                  //       ),
                  //     ): Container(width: 0, height: 0),
                  //   ),
                  // ),
                  // Card(
                  //   color: 3 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 3 ? Colors.redAccent : Colors.transparent,
                  //   child: ListTile(
                  //     leading: Icon(Icons.library_books),
                  //     title: Text(widget.showResList[widget.qNo]['ans_three']),
                  //     subtitle: widget.showResList[widget.qNo]['ans_three_img'] != null ? Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //         decoration: new BoxDecoration(
                  //           image: DecorationImage(
                  //             image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_three_img']),
                  //             fit: BoxFit.cover,
                  //           ),
                  //           color: Colors.transparent,
                  //         ),
                  //         height: size.height*0.2,
                  //         width: size.width*0.1,
                  //       ),
                  //     ): Container(width: 0, height: 0),
                  //   ),
                  // ),
                  // Card(
                  //   color: 4 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 4 ? Colors.redAccent : Colors.transparent,
                  //   child: ListTile(
                  //     leading: Icon(Icons.library_books),
                  //     title: Text(widget.showResList[widget.qNo]['ans_four']),
                  //     subtitle: widget.showResList[widget.qNo]['ans_four_img'] != null ? Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //         decoration: new BoxDecoration(
                  //           image: DecorationImage(
                  //             image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_four_img']),
                  //             fit: BoxFit.cover,
                  //           ),
                  //           color: Colors.transparent,
                  //         ),
                  //         height: size.height*0.2,
                  //         width: size.width*0.1,
                  //       ),
                  //     ): Container(width: 0, height: 0),
                  //   ),
                  // ),
                  // widget.showResList[widget.qNo]['ans_five'] != null ?
                  // Card(
                  //   color: 5 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 5 ? Colors.redAccent : Colors.transparent,
                  //   child: ListTile(
                  //     leading: Icon(Icons.library_books),
                  //     title: Text(widget.showResList[widget.qNo]['ans_five']),
                  //     subtitle: widget.showResList[widget.qNo]['ans_fiver_img'] != null ? Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Container(
                  //         decoration: new BoxDecoration(
                  //           image: DecorationImage(
                  //             image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.showResList[widget.qNo]['ans_five_img']),
                  //             fit: BoxFit.cover,
                  //           ),
                  //           color: Colors.transparent,
                  //         ),
                  //         height: size.height*0.2,
                  //         width: size.width*0.1,
                  //       ),
                  //     ): Container(width: 0, height: 0),
                  //   ),
                  // ) : SizedBox(
                  //   height: 1.0,
                  // ),

                ],
              ),
            ),
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
                        // pauseExit();
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
                        // validateAnsFinal(selectedFinal);
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
                  // Expanded(
                  //
                  //   child: widget.pageNo < widget.quesList.length-1 ?  MaterialButton(
                  //     elevation: 2,
                  //     child: Text('Next'),
                  //     onPressed: (){
                  //
                  //       // validateAns(selectedFinal);
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
          // _buildCircleIndicator5()
          Container(


            //  margin: EdgeInsets.all(20.0),
            height: 40.0,
            child:        Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                GestureDetector(
                  onTap: (){
                    pageController.animateToPage(
                      current_index -1 ,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    // Navigator.pop(context);
                  },
                  child: Container(

                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              bottomLeft:  Radius.circular(10),
                              topLeft:  Radius.circular(10)
                          )
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.chevron_left,color: Colors.white)),
                ),
                Container(
                  width: size.width*0.7,
                  padding: EdgeInsets.all(10.0),
                  child: PageView.builder(
                    itemCount: widget.showResList.length,
                    controller: pageController,
                    onPageChanged: _onPageViewChange,
                    itemBuilder: (BuildContext context, int itemIndex,) {
                      return GestureDetector(
                        child: Container(
                            width: 60.0,
                            child: Text((itemIndex+1).toString())),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Review(
                                showResList : widget.showResList,
                                userSel: widget.ans["$itemIndex"],
                                qNo : itemIndex,

                              )
                          ));


                        },
                      );
                    },
                  ),
                ),


                GestureDetector(

                  onTap: (){

                    // validateAns(selectedFinal);

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
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.keyboard_arrow_right,color: Colors.white,)),
                ),

              ],
            ),
          ),
        ],
      ),

    );
  }
}
