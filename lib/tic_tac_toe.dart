import 'package:assignment1_app/GameLocalizations.dart';
import 'package:flutter/material.dart';
import 'GameLocalizations.dart';

String _blankTile = "https://picsum.photos/300/300.jpg";


class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}


// class _HomePageState extends State<HomePage> {
class _GamePageState extends State<GamePage> {
  // TODO: Allow Locale override within Tic Tac Toe activity
  // GameLocalizations gameLocalizations = new GameLocalizations(Locale('es', 'US'));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        selectLanguage(context);
      });
    });
  }

  
  bool ohTurn = true; // first player is O!
  List<String> displayExOh = [
    _blankTile,
    _blankTile,
    _blankTile,
    _blankTile,
    _blankTile,
    _blankTile,
    _blankTile,
    _blankTile,
    _blankTile,
  ];

  var myTextStyle = TextStyle(color: Colors.white, fontSize: 30);
  var myTextStyleLeader = TextStyle(color: Colors.white, fontSize: 20);

  String currentLeader = "";
  int ohScore = 0;
  int exScore = 0;
  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {

    String playerO = GameLocalizations.of(context).translate("Player O");
    String playerX = GameLocalizations.of(context).translate("Player X");
    String resetGame = GameLocalizations.of(context).translate("Reset Game");

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
                            Text(playerX, style: myTextStyle, ),
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



  void _tapped(int index) {
    // #Acknowledgements: Picsum Phots https://picsum.photos/
    setState(() {
      if(ohTurn && displayExOh[index] == _blankTile) {
        displayExOh[index] = 'https://cdn.pixabay.com/photo/2013/07/12/16/22/alphabet-150778_1280.png';
        filledBoxes += 1;
      }
      else if (!ohTurn && displayExOh[index] == _blankTile) {
        displayExOh[index] = 'https://cdn.pixabay.com/photo/2012/04/12/20/12/x-30465_1280.png';
        filledBoxes += 1;
      }

      ohTurn = !ohTurn; // Switches player each turn.
      _checkWinner();
    });
  }

  String _checkPlayer(String xo) {
    String playerO = GameLocalizations.of(context).translate("Player O");
    String playerX = GameLocalizations.of(context).translate("Player X");
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
        displayExOh[0] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[3]));
    }
    if(displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[6]));
    }

    // Columns
    if(displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[1]));
    }
    if(displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[2]));
    }

    // Diagonal
    if(displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[0]));
    }
    if(displayExOh[2] == displayExOh[4] &&
        displayExOh[2] == displayExOh[6] &&
        displayExOh[2] != _blankTile) {
      _showWinDialog(_checkPlayer(displayExOh[2]));
    }
    else if(filledBoxes == 9) {
      _showDrawDialog();
    }


  }

  // Shows a dialog if there is a winner
  void _showWinDialog(String winner) {
    String playerO = GameLocalizations.of(context).translate("Player O");
    String playerX = GameLocalizations.of(context).translate("Player X");
    String playerOWinning = GameLocalizations.of(context).translate("Player O is winning!");
    String playerXWinning = GameLocalizations.of(context).translate("Player X is winning!");
    String won = GameLocalizations.of(context).translate(" won!");
    String winnerPreface = GameLocalizations.of(context).translate("Winner ");
    String playAgain = GameLocalizations.of(context).translate("Play Again!");

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
    String playAgain = GameLocalizations.of(context).translate("Play Again!");
    String draw = GameLocalizations.of(context).translate("Draw");

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
        displayExOh[i] = _blankTile;
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

void selectLanguage(BuildContext context) {
  var alertDialog = AlertDialog(
      title: Text("Set Language",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
      actions: [
        Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
                child: Text(
                  "Spanish",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
                ),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(
                  GameLocalizations.delegate.load(Locale('es')))
                )),
        Align(
            alignment: Alignment.bottomLeft,
            child: FlatButton(
                child: Text(
                  "English",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
                ),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(
                  GameLocalizations.delegate.load(Locale('en')))
                )),
      ]);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}