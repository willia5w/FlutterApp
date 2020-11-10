import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseRealtimeDemoScreen extends StatelessWidget {

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    readData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Realtime Database Demo'),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                RaisedButton(
                  child: Text('Create Data'),
                  color: Colors.redAccent,
                  onPressed: () {
                    createData();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                SizedBox(height: 8,),
                RaisedButton(
                  child: Text('Read/View Data'),
                  color: Colors.redAccent,

                  onPressed: () {
                    readData();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                ),
                SizedBox(height: 8,),

                RaisedButton(
                  child: Text('Update Data'),
                  color: Colors.redAccent,

                  onPressed: () {
                    updateData();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                ),
                SizedBox(height: 8,),

                RaisedButton(
                  child: Text('Delete Data'),
                  color: Colors.redAccent,

                  onPressed: () {
                    deleteData();
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

                ),
              ],
            ),
          )
      ), //center
    );
  }

  void createData(){
    var playerName =
    databaseReference.child("GameAttributes").set({
      'turn': 'player',
      'description': 'Team Lead'
    });
    // TODO: Save board as KVP within Firebase
    String blankTile = "https://picsum.photos/300/300.jpg";

    List<String> displayExOh = [
      blankTile,
      blankTile,
      blankTile,
      blankTile,
      blankTile,
      blankTile,
      blankTile,
      blankTile,
      blankTile,
    ];
    databaseReference.child("GameBoard").set(displayExOh);
    databaseReference.child("GameAttributes").set({
      'playerOneScore': 0,
      'playerTwoScore': 0,
      'isplayerOneTurn': true,
      'isPlayerTwoTurn': false,
      'tilesPlayed': 0,
      'currentLeader': ""
    });

    // databaseReference.child("flutterDevsTeam2").set({
    //   'name': 'Yashwant Kumar',
    //   'description': 'Senior Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam3").set({
    //   'name': 'Akshay',
    //   'description': 'Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam4").set({
    //   'name': 'Aditya',
    //   'description': 'Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam5").set({
    //   'name': 'Shaiq',
    //   'description': 'Associate Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam6").set({
    //   'name': 'Mohit',
    //   'description': 'Associate Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam7").set({
    //   'name': 'Naveen',
    //   'description': 'Associate Software Engineer'
    // });

  }
  void readData(){
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  void updateData(){
    databaseReference.child("PlayerAttributes").update({
      'playerName': 'shit',
      'playerId': 'dOv34cF_SgqGFmviQyHEnc:APA91bGFLORO_xHH_nBwdM1Rb4dph-_C_ItotUULPCaF_cjS861t9OBCFWSpUGBjw2v0g6zhlvOypZx8_jrlN2fth-dj3VUCIk52aerzEYMOPfs_ZXhI-fuNh2TmpKkeu3cN7cP-c-C0',
      'opponentName': 'fuck',
      'opponentId': 'elTgBPIDQVuSzW3ko2Uw6T:APA91bEuCja8WzJTyl-AWRS2UUdKfMqkjSEE7zfeuFZ70vgwSdR0q2aUI-9E8wdR95JCsKxMGCmJ6ZjHScVce8locBAhBkACAIQrdkKtUkgYHsgfJ6j6ptni0cnhqodE5y-rNFKoVPyr',
    });
  }

  void deleteData(){
    databaseReference.child('flutterDevsTeam1').remove();
    databaseReference.child('flutterDevsTeam2').remove();
    databaseReference.child('flutterDevsTeam3').remove();

  }
}