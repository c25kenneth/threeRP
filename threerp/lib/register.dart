import 'package:flutter/material.dart'; 
import 'package:threerp/auth.dart'; 
import 'package:threerp/constants.dart';
import 'package:threerp/database.dart'; 
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 


class Register extends StatefulWidget {
  final Function toggleView; 
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  final AuthService _auth = AuthService(); 
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://threerp-5e282.appspot.com');
  StorageUploadTask _uploadTask; 
  String email = '';
  String password = '';
  String error = ''; 
  String username = '';
  final _formKey = GlobalKey<FormState>();
  File _imageFile;  

  void _startUpload(String path) {
    String filePath = 'Users/$path.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(_imageFile); 
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source); 
    setState(() {
      _imageFile = selected; 
    });
  }
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path, 
      toolbarColor: Colors.blue, 
      toolbarWidgetColor: Colors.white, 
      toolbarTitle: 'Crop Image',
    );
    setState(() {
      _imageFile = cropped ?? _imageFile; 
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null; 
    });
  }


  @override
  Widget build(BuildContext context) {
     //final user = Provider.of<FirebaseUser>(context); 
    return Scaffold(
      appBar: AppBar(title: Text("Register"), actions: [
        FlatButton(child: Text("Sign In"), onPressed: (){widget.toggleView();}),
      ],), 
      body: Center(
        child: Column(
          children: [
            Form(
              key: _formKey, 
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                            icon: Icon(Icons.photo_camera), 
                            onPressed: () => _pickImage(ImageSource.camera),
                            tooltip: 'Update Profile Picture by Camera'
                            ),
                          ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(Icons.photo_library), 
                          onPressed: () => _pickImage(ImageSource.gallery),
                          tooltip: 'Update Profile Picture by Gallery',
                        ),
                      ),
                        ],
                      ), 
                      Column(
                        children: [
                          (_imageFile != null) ? Padding(child: IconButton(icon: Icon(Icons.crop), onPressed: _cropImage), padding: EdgeInsets.all(15.0),) : Text(" "),
                          (_imageFile != null) ? Padding(padding: const EdgeInsets.all(10.0), child: IconButton(icon: Icon(Icons.refresh), onPressed: _clear,)): Text(' '),
                        ],
                      ),                          
                      (_imageFile == null) ? Padding(padding: const EdgeInsets.fromLTRB(30, 30, 1, 30), child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),radius: 60.0,),) : Image.file(_imageFile, width: 150.0, height: 150.0),
                      //(_imageFile != null) ? Uploader(file: _imageFile, user: user): Text(" ")
                    ],
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Email"), 
                    validator: (val) => val.isEmpty ? "Please Enter in an Email": null,
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
                    validator: (val) => val.length < 6 ? "Please Enter in a longer Password of 6+ characters" : null, 
                    onChanged: (val){
                      setState(() {
                        password = val; 
                      });
                    }
                  ),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Username"), 
                    validator: (val) => val.isEmpty ? "Please Enter in a Username" : null,
                    onChanged: (val) {
                      setState(() {
                        username = val; 
                      });
                    }
                  ),
                  SizedBox(height: 15.0), 
                  Text(error, style: TextStyle(color: Colors.red)), 
                  SizedBox(height: 20.0), 
                  RaisedButton(
                    child: Text("Sign Up!"), 
                    color: Colors.green, 
                    onPressed: () async {
                      if (_formKey.currentState.validate() && _imageFile != null) {
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        DatabaseService(uid: result.uid).updateUserData(email, username, password, 0, result.uid, '0', _imageFile.path);
                        _startUpload(result.uid);
                        if (result == null) {
                          setState(() {
                            error = 'Invalid Email Please Try Again'; 
                          });
                        }
                      }
                    }
                  ),
                ]
              ),
            ),
          ],
        ), 
      ),
    );
  }
}