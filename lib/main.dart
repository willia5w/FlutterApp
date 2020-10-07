import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:trotter/trotter.dart';
import 'trie.dart' as Trie;

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
      items = Amalgams(length, bagOfItems);

  List<String> perms = new List<String>();
  for (final item in items()) {
    perms.add(item.join());
  }

  for (int j = 0; j < perms.length; j++) {
    // For string in list of strings
    String perm = perms[j];
    for (int i = 0; i < length; i++) {
      // Check match letter by letter
      if (pattern.substring(i, i + 1) != "_") {
        if (perm.substring(i, i + 1) == pattern.substring(i, i + 1)) {
          if (checkPosition(perm, pattern, letters, i)) {
            if (i == length - 1 && perm.substring(i) == pattern.substring(i)) {
              if (t.contains(perm)) {
                letterSet.add(perm);
                // perms.remove(perm);
              }
            } else if (t.contains(perm)) {
              letterSet.add(perm);
              // perms.remove(perm);
            }
          }
        }
        // perms.remove(perm);
      }
    }
  }
  print(letterSet);
  return letterSet;
}

bool checkPosition(String perm, String pattern, String letters, int pos) {
  if (perm.substring(pos, pos + 1).allMatches(perm).length ==
      perm.substring(pos, pos + 1).allMatches(pattern).length) {
    return true;
  }
  return false;
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
      home: MyHomePage(title: appName),
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
          VerticalPadding(
            color: Colors.white,
            child: Text(
              // Update to get version code from Android Manifest
              'Version 2.0',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontFamily: 'Lato'),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DictionaryRoute extends StatelessWidget {

  List<String> words = List<String>();
  String availableLetters = '';
  String inputPattern = '';
  int numLetters = 0;

  final clearLettersField = TextEditingController();
  final clearPatternField = TextEditingController();
  final clearLengthField = TextEditingController();

  clearTextInput(){
    clearLettersField.clear();
    clearPatternField.clear();
    clearLengthField.clear();
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
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number of Letters:',
              ),
              onChanged: (val) {
                numLetters = int.parse(val);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                // SizedBox(
                //   // TODO: Show Timer
                //   child: Text('$time'+ "ms"),
                // ),
                FlatButton(
                    child: Text('LOOKUP'),
                    onPressed: () {
                      if (numLetters != inputPattern.length) {
                        generateLengthError(context);
                      } else {
                        stopwatch.start();
                        words = getPermutations(
                            availableLetters, numLetters, inputPattern);
                        stopwatch.stop();
                        elapsedTime = stopwatch.elapsedMilliseconds.toString();
                        stopwatch.reset();
                        showRuntime(context);
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
          ],
        ));
  }
}

void showRuntime(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Runtime: " + "$elapsedTime" + "ms",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
    // content: Text("Try Again",
    //     style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
    //     textAlign: TextAlign.center),
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
      title: Text("Number of letters must match pattern length.",
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
