import 'package:assignment1_app/GameLocalizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:trotter/trotter.dart';
import 'trie.dart' as Trie;
import './tic_tac_toe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'GameLocalizations.dart';

var t = new Trie.Trie();
var stopwatch = new Stopwatch();
String elapsedTime = "0";


void main() {
  runApp(MyApp());
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/textFiles/wordlist.txt');
}

List<String> getPermutations(String letters, int length, String pattern) {
  // Stores matches
  List<String> letterSet = new List<String>();

  // Get unique chars from input
  List<String> chars = letters.split("");
  final seen = Set<String>();
  final unique = chars.where((str) => seen.add(str)).toList();
  final uniqueLetters = unique.join();

  final bagOfItems = characters(uniqueLetters),
      items = Permutations(length, bagOfItems);

  List<String> perms = new List<String>();
  for (final item in items()) {
    perms.add(item.join());
  }
  // For each permutation
  for (int j = 0; j < perms.length; j++) {
    String perm = perms[j];
    // For each letter  of the permutation
    for (int i = 0; i < length; i++) {
      // If current letter is _ then skip
      if (pattern.substring(i, i) != "_") {
        // If current letter doesnt match letter in pattern then skip
        if (perm.substring(i, i + 1) == pattern.substring(i, i + 1)) {
          // If count of occurences for this letter doesnt match occurences in the pattern then skip
          if (checkOccurences(perm, pattern, letters, i)) {
            if (t.contains(perm)) {
              letterSet.add(perm);
            }
          }
        }
      }
    }
  }
  return letterSet;
}

bool checkOccurences(String perm, String pattern, String letters, int pos) {
  String letter = perm.substring(pos, pos + 1);
  if (letter
              .allMatches(perm)
              .length // # occurences of this letter in the permutation
          ==
          letter
              .allMatches(pattern)
              .length // # occurences of this letter in the pattern
      &&
      letter
              .allMatches(perm)
              .length // # occurences of this letter in the permutation
          ==
          letter.allMatches(letters).length) {
    // # occurences of this letter in the input string
    return true;
  }
  return false;
}

class MyApp extends StatelessWidget {

  // Widget updateLocale(BuildContext context) {
  //   return Localizations.override(
  //     context: context,
  //     locale: const Locale('es', 'US'),
  //     child: GamePage,
  //   );
  // }

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
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('es', 'US'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        GameLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: MyHomePage(title: appName),
    //  TODO: Build imported route
    routes: <String, WidgetBuilder>{
        '/tic_tac_toe': (BuildContext context) => new GamePage()
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
  List<String> words = new List<String>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String wordList = await loadAsset();
      setState(() {
        words = wordList.split("\n");
      });
      await words.forEach((element) {
        t.addString(element);
      });
    });
  }

  void _aboutPage() {
    setState(() {});
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DictionaryRoute()),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: RaisedButton(
              child: Text('Tic Tac Toe', style: TextStyle(fontSize: 24)),
              onPressed: (() => Navigator.of(context).pushNamed('/tic_tac_toe')),  // Name set in routes
              // onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => GameRoute),
              //   );
              // },
            ),
          ),
          // TODO: Align at bottom of screen (responsive)
          VerticalPadding(
            color: Colors.white,
            child: Text(
              // Update to get version code from Android Manifest
              'Version 3.0',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontFamily: 'Lato'),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DictionaryRoute extends StatefulWidget {
  @override
  _DictionaryRouteState createState() => _DictionaryRouteState();
}

final _text = TextEditingController();
bool _validate = false;

class _DictionaryRouteState extends State<DictionaryRoute> {
  String time = "0";
  List<String> words = List<String>();

  String availableLetters = '';

  String inputPattern = '';

  int numLetters = 0;

  final clearLettersField = TextEditingController();

  final clearPatternField = TextEditingController();

  final clearLengthField = TextEditingController();

  clearTextInput() {
    clearLettersField.clear();
    clearPatternField.clear();
    clearLengthField.clear();
    availableLetters = '';
    inputPattern = '';
    numLetters = 0;
    clearList();
  }

  changeText() {
    setState(() {
      time = elapsedTime;
    });
  }

  clearList() {
    setState(() {
      words.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dictionary",
              style: TextStyle(fontSize: 24, fontFamily: 'Lato')),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 15.0,
            ),
            // TODO: Should allow blank input and show all words of length specified
            // TODO: Restrict to 10 characters "Enter up to 10 characters" within text box
            TextField(
              controller: clearLettersField,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Available Letters:',
              ),
              onChanged: (val) {
                availableLetters = val;
              },
            ),
            TextField(
              controller: clearPatternField,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Pattern:',
              ),
              onChanged: (val) {
                inputPattern = val;
              },
            ),
            TextField(

              controller: clearLengthField,
              keyboardType: TextInputType.number,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number of Letters:',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              onChanged: (val) {
                numLetters = int.parse(val);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                SizedBox(
                  child: Text('$time' + "ms"),
                ),
                FlatButton(
                    child: Text('LOOKUP'),
                    onPressed: () {
                      if (numLetters != inputPattern.length ||
                          availableLetters == "" || !RegExp(r'^[a-zA-Z]*$').hasMatch(availableLetters)) {
                        generateLengthError(context);
                      } else {
                        stopwatch.start();
                        words = getPermutations(
                            availableLetters, numLetters, inputPattern);
                        stopwatch.stop();
                        elapsedTime = stopwatch.elapsedMilliseconds.toString();
                        stopwatch.reset();
                        if (words.length == 0) {
                          words.add("No results");
                        }
                        changeText();
                      }
                    }),
                FlatButton(
                  child: Text('CLEAR'),
                  onPressed: clearTextInput,
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: words.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Text('${words[index]}');
                  return ListTile(
                    title: Text('${words[index]}'),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  child: Text('Acknowledgements', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AcknowledgementsRoute()),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

class AcknowledgementsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acknowledgements",
            style: TextStyle(fontSize: 24, fontFamily: 'Lato')),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.center,
            child: VerticalPadding(
              color: Colors.yellow[50],
              child: new RichText(
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: 'GitHub: Trie\n\n',
                      style: new TextStyle(color: Colors.blue, fontSize: 24, fontFamily: 'Lato'),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL('https://github.com/joshy/trie.dart');
                        },
                    ),
                    new TextSpan(
                      text: 'Trotter: Permutations()',
                      style: new TextStyle(color: Colors.blue, fontSize: 24, fontFamily: 'Lato'),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          _launchURL('https://pub.dev/packages/trotter');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}

// Catches url launcher exceptions
_launchURL(url) async {
  try{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  catch(e){
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

void generateLengthError(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text(
        "Number of letters must match pattern length.\n\n "
        "Available letters cannot be blank.\n\n"
            "Only letters accepted as input.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
    content: Text("Try Again",
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
