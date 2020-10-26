import 'package:educationapp/noticebody.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {

  List noticeList = List();

  //Getting dynamic subjects
  getNotices()async{
    print("GetSUb called");
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String phoneNo = user.phoneNumber;
    String phoneFinal = phoneNo.replaceAll("+94", "");

    var url = 'http://rankme.ml/getNotices.php';
    http.Response response = await http.get(url);

    if(response.body.toString() != "Error") {
      String jsonDataString = response.body;
      var data = jsonDecode(jsonDataString);

      if (this.mounted) {
        setState(() {
          noticeList = json.decode(jsonDataString.toString());
          print(noticeList);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotices();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _allow = false;
    return WillPopScope(
      child: Scaffold(
        body: noticeList.length == 0
            ? Container(
          color: Colors.indigo[100],
          height: size.height*1,
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
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
            :Container(
          decoration: BoxDecoration(
            color: Colors.blue[800],
            image: DecorationImage(
              image: AssetImage("images/main_top.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: noticeList
                .map((list) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
              width: size.width * 0.85,
              child: GestureDetector(
                  child: SizedBox(
                    height: size.height*0.15,
                    child: Material(

//                      borderRadius: BorderRadius.circular(24.0),
                      elevation: 24.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: list['image'] != null ? Container(
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(list['image']),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.redAccent,


                              ),

                              height: double.infinity,
                              width: size.width*6,
                            ) : SizedBox(height: 1.0,),
                          ),
                          SizedBox(
                            width: size.width*0.1,
                          ),
                          Expanded(
                            child: Container(
                              child: new Text(list['title'],style: GoogleFonts.yesevaOne(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                              ),
                                ),
                              width: size.height*8,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> NoticeBody(title: list['title'], image: list['image'], text: list['text'],))),
              ),
            ),
                )).toList(),
          )
        ),
        backgroundColor: Colors.white,
      ),
      onWillPop: () {
        return Future.value(_allow); // if true allow back else block it
      },
    );
  }
}
