import 'dart:async';
import 'dart:convert';
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

final _text = TextEditingController();
bool _validate = false;

String getPlayer() {
  return playerUserName;
}

// May not need player token
// Future<String> getPlayerToken() {
//   return firebaseMessaging.getToken();
// }

String getOpponent() {
  return opponentUserName;
}

String getOpponentToken() {
  return opponentToken;
}

String playerUserName = '';
String opponentUserName = '';
String opponentToken = 'elTgBPIDQVuSzW3ko2Uw6T:APA91bEuCja8WzJTyl-AWRS2UUdKfMqkjSEE7zfeuFZ70vgwSdR0q2aUI-9E8wdR95JCsKxMGCmJ6ZjHScVce8locBAhBkACAIQrdkKtUkgYHsgfJ6j6ptni0cnhqodE5y-rNFKoVPyr';

final clearPlayerField = TextEditingController();
final clearOpponentField = TextEditingController();
final clearOpponentTokenField = TextEditingController();

clearTextInput() {
  clearPlayerField.clear();
  clearOpponentField.clear();
  clearOpponentTokenField.clear();
  playerUserName = '';
  opponentUserName = '';
  opponentToken = '';
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
            TextField(
              controller: clearOpponentTokenField,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Your Opponent\'s Token:',
              ),
              onChanged: (val) {
                opponentToken = val;
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => tic_tac_toe_2Play.GamePage()),
                      );
                    }),
                FlatButton(
                    child: Text('PLAY LOCALLY'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => tic_tac_toe.GamePage()),
                      );
                    }),
              ],
            ),
          ],
        ));
  }
}
