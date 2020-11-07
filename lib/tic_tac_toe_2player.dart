import 'package:firebase_database/firebase_database.dart';
import 'package:assignment1_app/GameLocalizations.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'GameLocalizations.dart';
import '././game_resources/game_translator.dart' as translator;
import 'firebase_realtime_db.dart';
import '././game_resources/game_setup.dart' as setup;


final db = FirebaseDatabase.instance.reference();

//TODO: Access tiles as KVP to clean up board reference
String blankTile = "https://picsum.photos/300/300.jpg";
String ohTile = 'https://cdn.pixabay.com/photo/2013/07/12/16/22/alphabet-150778_1280.png';
String exTile = 'https://cdn.pixabay.com/photo/2012/04/12/20/12/x-30465_1280.png';


class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}


class _GamePageState extends State<GamePage> {

  List<dynamic> displayExOh = [
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


  // bool gameStarted = db.child("GameAttributes").key(tilesPlayed) > 0;
  bool gameStarted = false;
  bool playerTurn = true;
  String currentLeader = "";
  int ohScore = 0;
  int exScore = 0;
  int filledBoxes = 0;
  bool isOpponent;

  String playerName = setup.getPlayer();
  String opponentName = setup.getOpponent();
  String playerWinning = setup.getPlayer() + " " + translator.translate("is winning!");
  String opponentWinning = setup.getOpponent() + " " + translator.translate("is winning!");
  String won = translator.translate(" won!");
  String playAgain = translator.translate("Play Again!");
  String draw = translator.translate("Draw");
  String resetGame = translator.translate("Reset Game");


  @override
  void initState(){
    db.once().then((DataSnapshot snapshot) {
      isOpponent = snapshot.value['GameAttributes']['tilesPlayed'] > 0;
      print("Tiles played so far" + snapshot.value['GameAttributes']['tilesPlayed'].toString());
    });

    // Future.delayed(const Duration(milliseconds: 1000), ()
    // {
    //   if (!gameStarted) {
    //     _setPlayers();
    //     _createBoard();
    //     print(isOpponent);
    //   } else {
    //     isOpponent = true;
    //     print(isOpponent);
    //   }
    //
    // });
  }

  @override
  void didChangeDependencies() {
    // TODO: Add onDisconnect functionality
    // Map<> =
    db.onChildChanged.listen((event) {
      // print(event.snapshot.key.toString());
      if (event.snapshot.key == "GameAttributes") {
        Map<dynamic, dynamic> currentGameAttributes = event.snapshot.value;
        playerTurn = currentGameAttributes['isPlayerTurn'];
        currentLeader = currentGameAttributes['currentLeader'];
        ohScore = currentGameAttributes['playerScore'];
        exScore = currentGameAttributes['opponentScore'];
        filledBoxes = currentGameAttributes['tilesPlayed'];

      } else if (event.snapshot.key == "GameBoard") {
        // displayExOh = event.snapshot.value;
          _reloadBoard(event.snapshot.value);

      }
    });
    _checkWinner();  // Should print win dialog for loser as well
  }


  void _reloadBoard(List<dynamic> updatedBoard) {
    setState(() {
      displayExOh = updatedBoard;
    });
  }

  void _setPlayers() {
    db.child("PlayerAttributes").set({
      'playerName': playerName,
      'playerId': 'Player\'s FCM Messaging Token',
      'opponentName': opponentName,
      'opponentId': 'Opponent\'s FCM Messaging Token',
    });
    db.child("GameAttributes").update({
      'playerScore': 0,
      'isPlayerTurn': true,
      'opponentScore': 0,
      'tilesPlayed': 0,
      'currentLeader': ""
    });
  }

  void _createBoard() {
    db.child("GameBoard").set(displayExOh);
  }

  void _updateStats(int p1Score, int p2Score, bool isTurn, int filledBoxes, String leader) {
    db.child("GameAttributes").set({
      'tilesPlayed': filledBoxes,
      'playerScore': p1Score,
      'opponentScore': p2Score,
      'currentLeader': leader
    });
  }

  // void _getSnapShot() {
  //   db.once().then((DataSnapshot snapshot) {
  //     print('Data : ${snapshot.value}');
  //   });
  // }

  var myTextStyle = TextStyle(color: Colors.white, fontSize: 30);
  var myTextStyleLeader = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0,top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(playerName, style: myTextStyle, ),
                            Text(ohScore.toString(), style: myTextStyle, ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0,top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(opponentName, style: myTextStyle, ),
                            Text(exScore.toString(), style: myTextStyle, ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currentLeader, style: myTextStyleLeader, ),
                ]
            ),
            Expanded (
              flex: 3,
              child: GridView.builder(
                  itemCount: 9, // Number of squares
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        _tapped(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[700]),
                          image: new DecorationImage(
                              image: new NetworkImage(displayExOh[index]),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            GestureDetector(
                onTap: (){
                  _resetGame();
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10,top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      color: Colors.red,
                      child: Center(
                          child: Text(
                            resetGame,
                            style: myTextStyle,
                          )
                      ),
                    ),
                  ),
                )
            )
          ],
        )
    );
  }


// TODO: Improve image/graphic used for X and O marks
  void _tapped(int index) {
    // #Acknowledgements: Picsum Phots https://picsum.photos/
    // setState(() {
      if(isOpponent == false && playerTurn == true && displayExOh[index] == blankTile) {  // FIX THIS
        print("PLAYER MOVE MADE");
        displayExOh[index] = ohTile;
        db.child("GameBoard").set(displayExOh);
        filledBoxes += 1;
        db.child("GameAttributes").update({
          'tilesPlayed': filledBoxes,
          'isPlayerTurn': false,
        });
      }
      else if (isOpponent == true && playerTurn == false && displayExOh[index] == blankTile) {
        print("OPPONENT MOVE MADE");
        displayExOh[index] = exTile;
        db.child("GameBoard").set(displayExOh);
        filledBoxes += 1;
        db.child("GameAttributes").update({
          'tilesPlayed': filledBoxes,
          'isPlayerTurn': true,
        });
      }

      // playerTurn = !playerTurn; // Switches player each turn.
      _checkWinner();
    // });
  }

  String _checkPlayer(String xo) {
    if(xo == ohTile){
      return playerName;
    }
    else{
      return opponentName;
    }
  }

  // Checks if someone won
  void _checkWinner() {
    // Rows
    if(displayExOh[0] == displayExOh[1] &&
        displayExOh[0] == displayExOh[2] &&
        displayExOh[0] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[3]));
    }
    if(displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[6]));
    }

    // Columns
    if(displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[1]));
    }
    if(displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[2]));
    }

    // Diagonal
    if(displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[2] == displayExOh[4] &&
        displayExOh[2] == displayExOh[6] &&
        displayExOh[2] != blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[2]));
    }
    else if(filledBoxes == 9) {
      _showDrawDialog();
    }
  }

  // Shows a dialog if there is a winner
  void _showWinDialog(String winner) {
    
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(winner + won),
            actions: <Widget>[
              FlatButton (
                  child: Text(playAgain),
                  onPressed: (){
                    _clearBoard();
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
    // winner should be allowed to make first move on next round
    if(winner == playerName) {
      ohScore += 1;
      db.child("GameAttributes").set({
        'tilesPlayed': 0,
        'playerScore': exScore,
        'opponentScore': ohScore,
        'isPlayerTurn': true,
        'currentLeader': currentLeader
      });
    }
    else if(winner == opponentName){
      exScore += 1;
      db.child("GameAttributes").set({
        'tilesPlayed': 0,
        'playerScore': exScore,
        'opponentScore': ohScore,
        'isPlayerTurn': false,
        'currentLeader': currentLeader
      });
    }

    if (ohScore > exScore) {
      currentLeader = playerWinning;
    }
    else {
      currentLeader = opponentWinning;
    }

  }

  // Shows a dialog if there is a winner
  void _showDrawDialog() {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(draw),
            actions: <Widget>[
              FlatButton (
                  child: Text(playAgain),
                  onPressed: (){
                    _clearBoard();
                    _updateStats(exScore, ohScore, playerTurn, 0, currentLeader);
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }

  void _clearBoard() {
    setState(() {
      for(int i = 0; i < displayExOh.length; i++) {
        displayExOh[i] = blankTile;
      }
      db.child("GameBoard").set(displayExOh);
    });

    filledBoxes = 0;

  }

  void _resetGame() {
    _clearBoard();
    currentLeader = "";
    ohScore = 0;
    exScore = 0;
    filledBoxes = 0;
    db.child("GameAttributes").set({
      'tilesPlayed': 0,
      'playerScore': 0,
      'opponentScore': 0,
      'isPlayerTurn': true,
      'currentLeader': ""
    });

  }
}

