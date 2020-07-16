import 'package:educationapp/homepage.dart';
import 'package:educationapp/signin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaintainRoute extends StatefulWidget {
  @override
  _MaintainRouteState createState() => _MaintainRouteState();
}

class _MaintainRouteState extends State<MaintainRoute> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getCurrentUser ();
  }

  getCurrentUser () async{
    final usersref = Firestore.instance.collection('userId');
    DocumentSnapshot docCurrent;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    docCurrent = await usersref.document(user.uid).get();
    print(user.uid);
    print(docCurrent);

    if(!docCurrent.exists)
    {
      await usersref.document(user.uid).setData({
        "uid":user.uid,
      });
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SigninPage()
      ));
    }
    else{
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage()
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
