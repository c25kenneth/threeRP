import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threerp/leaderboard.dart';
import 'package:threerp/leaderboardtile.dart';
import 'user.dart';


class LeaderBoard extends StatefulWidget {

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {

    final recycleList = Provider.of<List<Recycle>>(context) ?? []; 
    
    recycleList.sort((b,a) => a.recycledKG.compareTo(b.recycledKG));
    return ListView.builder(
      itemCount: recycleList.length, 
      itemBuilder: (context, index) {
        return LeaderBoardTile(
          recycle: recycleList[index],
        );
      }
    );
  }
}