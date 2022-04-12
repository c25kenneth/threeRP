import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threerp/auth.dart';
import 'package:threerp/database.dart';
import 'recycleupdate.dart'; 
import 'leaderboard.dart';
import 'user.dart'; 

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService(); 
  
  void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: RecycleUpdate(),
        );
      });
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Recycle>>.value(
        value: DatabaseService().recycle,
        child: Scaffold(
        appBar: AppBar(title: Text("Home Page"), actions: [
          FlatButton(
            onPressed: () async {
              _auth.authSignOut(); 
            },
            child: Text("Sign Out"), 
          ),
          FlatButton(
            onPressed: () {
              _showSettingsPanel();
            },
            child: Text("Edit recycle count"),
          ),
        ],
        ),
        body: LeaderBoard(),
      ),
    );
  }
}