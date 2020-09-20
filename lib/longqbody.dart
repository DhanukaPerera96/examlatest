import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class LongQBody extends StatefulWidget {

  final String qText;
  final String qImage;
  final String answer;
  final String answerImage;
  final String qNo;

  LongQBody({this.qText, this.qImage, this.answer, this.answerImage, this.qNo});

  @override
  _LongQBodyState createState() => _LongQBodyState();
}

class _LongQBodyState extends State<LongQBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Question "+ widget.qNo),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.qText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width*0.05,
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.02,
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(24)
                              ),
                              image: DecorationImage(

                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.qImage),
                                fit: BoxFit.fill,

                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                )
                              ]
                          ),
                          height: size.height * 0.30,
                          width: size.width*0.40,

                        ),),
                    ],
                  ),

                ],

              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height* 0.05),
              padding: EdgeInsets.only(
                top: size.height* 0.03,
                left: 8.0,
                right: 8.0,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

              ),
              child: Column(
                children: <Widget>[
                  Text(
                    "Answer",
                      style: GoogleFonts.yesevaOne(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.w600,
                      )
                  ),
                  Text(

                    widget.answer,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 99,
                    style: TextStyle(
                      fontSize: size.width*0.06,),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: size.height*0.02,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(24)
                              ),
                              image: DecorationImage(

                                image: NetworkImage("http://rankme.ml/dashbord/dist/"+widget.answerImage),
                                fit: BoxFit.fill,

                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                )
                              ]
                          ),
                          height: size.height * 0.30,
                          width: size.width*0.40,

                        ),),
                    ],
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
