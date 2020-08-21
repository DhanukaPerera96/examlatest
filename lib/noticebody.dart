import 'package:flutter/material.dart';

class NoticeBody extends StatefulWidget {

  final String title;
  final String image;
  final String text;
  NoticeBody({this.title, this.image, this.text});

  @override
  _NoticeBodyState createState() => _NoticeBodyState();
}

class _NoticeBodyState extends State<NoticeBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Notices"),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height* 0.3),
                    padding: EdgeInsets.only(
                      top: size.height* 0.18,
                      left: 8.0,
                      right: 8.0,
                    ),
                    height: size.height* 0.7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        )
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(widget.text,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 99,
                              style: TextStyle(
                                fontSize: size.width*0.06,),
                              textAlign: TextAlign.justify,

                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.2,
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width*0.10,
                          ),
                        ),

                        Row(
                          children: <Widget>[

                            SizedBox(
                              width: size.width * 0.30,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24)
                                    ),
                                    image: DecorationImage(

                                      image: NetworkImage("http://rankme.ml/"+widget.image),
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
            )
          ],
        ),
      ),

    );
  }
}
