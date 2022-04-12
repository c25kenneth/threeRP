import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:threerp/database.dart';
import 'user.dart'; 
import 'package:provider/provider.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
class RecycleUpdate extends StatefulWidget {

  @override
  _RecycleUpdateState createState() => _RecycleUpdateState();
}

class _RecycleUpdateState extends State<RecycleUpdate> {
  int currentValue = 1; 
  int currentRecycle; 
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context); 
    return StreamBuilder<IndivRecycle>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        IndivRecycle userData = snapshot.data; 
        currentRecycle = userData.recycledKG; 
        return Column(
          children: [
            Text("Update Your Recycle Variable!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0)),
            SizedBox(height:35.0),
            Slider(  
              min: 0,  
              max: 10,  
              value: currentValue.toDouble(),  
              onChanged: (value) {  
                setState(() {  
                  currentValue = value.toInt();  
                });  
              }, 
              divisions: 10, 
            ),  
            
            Text('Current Value: ' + "+ " + currentValue.toString() + ' KG'),
            SizedBox(height: 55.0),
            Text('I would like to add ' + currentValue.toString() + " Kilograms of Recycling to my Total!", style: TextStyle(fontSize: 25.0)), 
            SizedBox(height: 15.0), 
            FlatButton(child: Text('Add to Total!'), color: Colors.green, onPressed: () async {
              await userCollection.document(user.uid).setData({'plastic_recycled' : currentValue + currentRecycle}, merge: true);
              Navigator.pop(context); 
            })
          ],
        );
      }
    );
  }
}