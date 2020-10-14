import 'package:assignment1_app/GameLocalizations.dart';
import 'package:flutter/material.dart';
import 'GameLocalizations.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}


// class _HomePageState extends State<HomePage> {
class _GamePageState extends State<GamePage> {

  bool ohTurn = true; // first player is O!
  List<String> displayExOh = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  var myTextStyle = TextStyle(color: Colors.white, fontSize: 30);
  var myTextStyleLeader = TextStyle(color: Colors.white, fontSize: 20);
  String playerO = "Player O";
  String playerX = "Player X";
  String playerOWinning = "Player O is winning!";
  String playerXWinning = "Player X is winning!";
  String resetGame = "Reset Game";
  String playAgain = "Play Again!";
  String won = " won!";
  String winnerPreface = "Winner ";
  String draw = "Draw";

  Locale locale;


  String currentLeader = "";
  int ohScore = 0;
  int exScore = 0;
  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Column(
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
                            Text(playerO, style: myTextStyle, ),
                            Text(ohScore.toString(), style: myTextStyle, ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0,top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TODO: Attempt translation within text object
                            Text(GameLocalizations.of(context).translate(playerO), style: myTextStyle, ),
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
                      // TODO: Bring out Box fragment into its own class and import + instantiate
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[700])
                        ),
                        child: Center(
                          // TODO: Change "X" to an image of an X
                          child: Text(displayExOh[index], style: TextStyle(color: Colors.white, fontSize: 40),),
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

  void _tapped(int index) {

    setState(() {
      if(ohTurn && displayExOh[index] == '') {
        displayExOh[index] = 'O';
        filledBoxes += 1;
      }
      else if (!ohTurn && displayExOh[index] == '') {
        displayExOh[index] = 'X';
        filledBoxes += 1;
      }

      ohTurn = !ohTurn; // Switches player each turn.
      _checkWinner();
    });
  }

  String _checkPlayer(String xo) {
    if(xo == 'O'){
      return playerO;
    }
    else{
      return playerX;
    }
  }

  // Checks if someone won
  void _checkWinner() {
    // Rows
    if(displayExOh[0] == displayExOh[1] &&
        displayExOh[0] == displayExOh[2] &&
        displayExOh[0] != '') {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      _showWinDialog(_checkPlayer(displayExOh[3]));
    }
    if(displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      _showWinDialog(_checkPlayer(displayExOh[6]));
    }

    // Columns
    if(displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      _showWinDialog(_checkPlayer(displayExOh[1]));
    }
    if(displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      _showWinDialog(_checkPlayer(displayExOh[2]));
    }

    // Diagonal
    if(displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[2] == displayExOh[4] &&
        displayExOh[2] == displayExOh[6] &&
        displayExOh[2] != '') {
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
            title: Text(winnerPreface + winner + won),
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
    if(winner == playerO) {
      ohScore += 1;
    }
    else if(winner == playerX){
      exScore += 1;
    }

    if (ohScore > exScore) {
      currentLeader = playerOWinning;
    }
    else {
      currentLeader = playerXWinning;
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
        displayExOh[i] = "";
      }
    });

    filledBoxes = 0;

  }

  void _resetGame() {
    _clearBoard();
    currentLeader = "";
    ohScore = 0;
    exScore = 0;
    filledBoxes = 0;


  }

}