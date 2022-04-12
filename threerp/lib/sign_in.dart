import 'package:flutter/material.dart'; 
import 'auth.dart';
import 'package:threerp/constants.dart'; 

class SignIn extends StatefulWidget {
  
  final Function toggleView; 
  SignIn({this.toggleView}); 

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  final AuthService _auth = AuthService(); 
  
  String email = '';
  String password = '';
  String error = ''; 
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In"), actions: [
        FlatButton(child: Text("Register"), onPressed: (){widget.toggleView();}),
      ],), 
      body: Center(
        child: Column(
          children: [
            Form(
              key: _formKey, 
              child: Column(
                children: [
                  SizedBox(height: 20.0), 
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Email"), 
                    validator: (val) => val.isEmpty ? "Please Enter in a valid Email": null,
                    onChanged: (val){
                      setState(() {
                        email = val; 
                      });
                    }
                  ),
                  SizedBox(height: 25.0), 
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Password"),
                    obscureText: true,
                    validator: (val) => val.isEmpty ? "Please Enter a valid Password" : null, 
                    onChanged: (val){
                      setState(() {
                        password = val; 
                      });
                    }
                  ),
                  SizedBox(height: 15.0), 
                  Text(error, style: TextStyle(color: Colors.red)), 
                  SizedBox(height: 20.0), 
                  RaisedButton(
                    child: Text("Sign In!"), 
                    color: Colors.green, 
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.signInEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error = 'Invalid Email Please Try Again'; 
                          });
                        }
                      }
                    }
                  ) 
                ]
              ),
            ),
          ],
        ), 
      ),
    );
  }
}