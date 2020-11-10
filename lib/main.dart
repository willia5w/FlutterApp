// import 'GameLocalizations.dart' as translator;
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'dictionary_lookup.dart';
import 'tic_tac_toe_2player.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'GameLocalizations.dart';
import '././game_resources/game_setup.dart';
import '././game_resources/game_translator.dart' as translator;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(OverlaySupport(child: MyApp()));
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  // Or do other work.
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appName = 'Daniel Williams';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Lato',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
        ),
      ),
      supportedLocales: [
        Locale('en'),
        Locale('es'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        GameLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
      // If the locale of the device is not supported, defaults to first from supportedLocales
        return supportedLocales.first;
      },
      home: MyHomePage(title: appName),
      routes: <String, WidgetBuilder>{
        '/tic_tac_toe_2player': (BuildContext context) => new GamePage(),
        '././game_resources/game_setup.dart': (BuildContext context) => new GameSetup(),
        '/dictionary_lookup': (BuildContext context) => new DictionaryRoute(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        translator.load('en');
        acceptInvite(context);

        // Case where app is in the background
        showOverlayNotification((context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(
                        child: Container(
                          color: Colors.black,
                        ))),
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ),
            ),
          );
        }, duration: Duration(milliseconds: 4000));

        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
        translator.load('en');
        Navigator.of(context).pushNamed('/tic_tac_toe_2player');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
        translator.load('en');
        Navigator.of(context).pushNamed('/tic_tac_toe_2player');
      },
    );
    _firebaseMessaging.getToken().then((token){
      print("This device\'s token is: " + token.toString());
    });
  }

  void acceptInvite(BuildContext context) {
    var alertDialog = AlertDialog(
        title: Text("Game Invite: Tic-Tac-Toe",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
        content: Text("Someone has invited you to play a game.",
            style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
            textAlign: TextAlign.center),
        actions: [
          Align(
              alignment: Alignment.center,
              child: FlatButton(
                  child: Text(
                    "Accept Challenge!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/tic_tac_toe_2player');
                  })
              // FlatButton(
              //     child: Text(
              //       "Flee!",
              //       textAlign: TextAlign.center,
              //       style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
              //     ),
              //     onPressed: () {
              //       exit(0);
              //     })
          ),
        ]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100.0,
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('About', style: TextStyle(fontSize: 24)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutRoute()),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
                child: Text('Generate Error', style: TextStyle(fontSize: 24)),
                onPressed: () => generateError(context)),
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('Dictionary', style: TextStyle(fontSize: 24)),
              onPressed: () {
                    Navigator.of(context).pushNamed('/dictionary_lookup');
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('Tic Tac Toe', style: TextStyle(fontSize: 24)),
              onPressed: (){
                Navigator.of(context).pushNamed('././game_resources/game_setup.dart');
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                'Version 3.0',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontFamily: 'Lato'),
                  ),
              ),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


void showRuntime(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Runtime: " + "$elapsedTime" + "ms",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
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


class AboutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Me",
            style: TextStyle(fontSize: 24, fontFamily: 'Lato')),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10.0,
          ),
          VerticalPadding(
            color: Colors.yellow[50],
            child: Text(
              'Daniel Williams',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'Lato'),
            ),
          ),
          VerticalPadding(
            color: Colors.yellow[50],
            child: Text(
              'Email: williams.dan@northeastern.edu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
            ),
          ),
          VerticalPadding(
            color: Colors.yellow[50],
            child: Text(
              'Starting Semester: ALIGN Spring 2019',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/corporate_daniel_williams.jpg',
                width: 300, height: 300),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

class VerticalPadding extends StatelessWidget {
  // Colored faded padding for positioned items.

  VerticalPadding({
    @required this.child,
    this.padding = 16.0,
    this.color = Colors.white,
  });

  final double padding;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(vertical: padding),
      child: child,
    );
  }
}

void generateError(BuildContext context) {
  var alertDialog = AlertDialog(
      title: Text("Error Generated!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
      content: Text("Please close the app.",
          style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
          textAlign: TextAlign.center),
      actions: [
        Align(
            alignment: Alignment.center,
            child: FlatButton(
                child: Text(
                  "Close now.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
                ),
                onPressed: () {
                  exit(0);
                })),
      ]);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}


