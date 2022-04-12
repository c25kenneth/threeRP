import 'package:flutter/material.dart';
import 'user.dart'; 
class LeaderBoardTile extends StatelessWidget {

  final Recycle recycle;
  LeaderBoardTile({this.recycle});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0), 
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: ListTile(
          title: Text(recycle.userName), 
          subtitle: Text("Recycled " + recycle.recycledKG.toString() + " times")
        ),
      ),
    );
  }
}