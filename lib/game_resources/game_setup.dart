import 'package:flutter/material.dart';
import 'game_translator.dart' as translator;
import 'package:assignment1_app/tic_tac_toe_2player.dart' as tic_tac_toe;


class GameSetup extends StatefulWidget {
  @override
  _GameSetupState createState() => _GameSetupState();
}

final _text = TextEditingController();
bool _validate = false;

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
          title: Text("Menu",
              style: TextStyle(fontSize: 24, fontFamily: 'Lato')),
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
                labelText: 'Enter a UserName:',
              ),
              onChanged: (val) {
                playerUserName = val;
                translator.load('en');  // Defaulting to English
              },
            ),
            TextField(
              controller: clearOpponentField,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your opponent\'s UserName:',
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
                  child: Text('Select Language'),
                    onPressed: () {
                      translator.selectLanguage(context);
                    }
                ),
                FlatButton(
                  child: Text('START GAME!'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => tic_tac_toe.GamePage()),
                      );
                    }
                ),
              ],
            ),
          ],
        ));
  }
}