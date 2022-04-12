import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threerp/authenticate.dart';
import 'package:provider/provider.dart'; 
import 'package:threerp/home.dart'; 

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context); 

    return (user == null) ? Authenticate() : Home(); 
  }
}