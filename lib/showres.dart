import 'package:flutter/material.dart';

class ShowRes extends StatefulWidget {

  final List<dynamic> showResList;
  final int userSel;
  final int qNo;

  ShowRes({List<dynamic> showResList, this.userSel, this.qNo}) : this.showResList = showResList ?? [];

  @override
  _ShowResState createState() => _ShowResState();
}

class _ShowResState extends State<ShowRes> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.showResList[widget.qNo]);
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
                        image: NetworkImage("http://rankme.ml/"+widget.showResList[widget.qNo]['image']),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.redAccent,
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
              Text("Correct Answer: "+ widget.showResList[widget.qNo]['answer']),
              widget.userSel != null ? Text("You Selected" + widget.userSel.toString()) : Text("You Selected None" ),
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
                              image: NetworkImage("http://rankme.ml/"+widget.showResList[widget.qNo]['image']),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.redAccent,
                          ),
                          height: size.height*0.2,
                          width: size.width*0.1,
                        ),
                      ): Container(width: 0, height: 0),
                    ),
                  ),

                  Card(
                    color: 2 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 2 ? Colors.redAccent : Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text(widget.showResList[widget.qNo]['ans_two']),
                      subtitle: widget.showResList[widget.qNo]['ans_two_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://rankme.ml/"+widget.showResList[widget.qNo]['ans_two_img']),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.redAccent,
                          ),
                          height: size.height*0.2,
                          width: size.width*0.1,
                        ),
                      ): Container(width: 0, height: 0),
                    ),
                  ),
                  Card(
                    color: 3 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 3 ? Colors.redAccent : Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text(widget.showResList[widget.qNo]['ans_three']),
                      subtitle: widget.showResList[widget.qNo]['ans_three_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://rankme.ml/"+widget.showResList[widget.qNo]['ans_three_img']),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.redAccent,
                          ),
                          height: size.height*0.2,
                          width: size.width*0.1,
                        ),
                      ): Container(width: 0, height: 0),
                    ),
                  ),
                  Card(
                    color: 4 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 4 ? Colors.redAccent : Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text(widget.showResList[widget.qNo]['ans_four']),
                      subtitle: widget.showResList[widget.qNo]['ans_four_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://rankme.ml/"+widget.showResList[widget.qNo]['ans_four_img']),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.redAccent,
                          ),
                          height: size.height*0.2,
                          width: size.width*0.1,
                        ),
                      ): Container(width: 0, height: 0),
                    ),
                  ),
                  widget.showResList[widget.qNo]['ans_five'] != null ?
                  Card(
                    color: 5 == int.parse(widget.showResList[widget.qNo]['answer']) ? Colors.greenAccent : widget.userSel == 5 ? Colors.redAccent : Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text(widget.showResList[widget.qNo]['ans_five']),
                      subtitle: widget.showResList[widget.qNo]['ans_fiver_img'] != null ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://rankme.ml/"+widget.showResList[widget.qNo]['ans_five_img']),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.redAccent,
                          ),
                          height: size.height*0.2,
                          width: size.width*0.1,
                        ),
                      ): Container(width: 0, height: 0),
                    ),
                  ) : SizedBox(
                    height: 1.0,
                  ),

                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}
