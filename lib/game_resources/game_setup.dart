import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'game_translator.dart' as translator;
import 'package:assignment1_app/tic_tac_toe.dart' as tic_tac_toe;
import 'package:assignment1_app/tic_tac_toe_2player.dart' as tic_tac_toe_2Play;

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class GameSetup extends StatefulWidget {
  @override
  _GameSetupState createState() => _GameSetupState();
}

String getPlayer() {
  return playerUserName;
}

String getOpponent() {
  return opponentUserName;
}


String playerUserName = '';
String opponentUserName = '';

final clearPlayerField = TextEditingController();
final clearOpponentField = TextEditingController();

clearTextInput() {
  clearPlayerField.clear();
  clearOpponentField.clear();
  playerUserName = '';
  opponentUserName = '';
}

class _GameSetupState extends State<GameSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Menu", style: TextStyle(fontSize: 24, fontFamily: 'Lato')),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: clearPlayerField,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a UserName',
              ),
              onChanged: (val) {
                playerUserName = val;
                translator.load('en'); // Defaulting to English
              },
            ),
            TextField(
              controller: clearOpponentField,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Your Opponent\'s UserName:',
              ),
              onChanged: (val) {
                opponentUserName = val;
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                FlatButton(
                    child: Text('SELECT YOUR LANGUAGE'),
                    onPressed: () {
                      translator.selectLanguage(context);
                    }),
                FlatButton(
                    child: Text('PLAY ON THE CLOUD'),
                    onPressed: () {
                      if(playerUserName.length == 0 || opponentUserName.length == 0) {
                        generateLengthError(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tic_tac_toe_2Play.GamePage()),
                        );
                      }
                    }),
                FlatButton(
                    child: Text('PLAY LOCALLY'),
                    onPressed: () {
                      if(playerUserName.length == 0 || opponentUserName.length == 0) {
                        generateLengthError(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => tic_tac_toe.GamePage()),
                        );
                      }
                    }),
              ],
            ),
          ],
        ));
  }
}

void generateLengthError(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text(
        "Fields Cannot Be Blank!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
    content: Text("Please Try Again",
        style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
        textAlign: TextAlign.center),
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return alertDialog;
      });
}
