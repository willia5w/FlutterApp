
import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:trotter/trotter.dart';
import 'trie.dart' as Trie;
var t = new Trie.Trie();

// DictionarySingleton dictionarySingleton;

void main() {
  runApp(MyApp());

  // Get singleton instance
  // dictionarySingleton = DictionarySingleton.instance;
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/textFiles/wordlist.txt');
}

// class Dictionary() {
//   var t = new Trie.Trie();
// }


// class DictionarySingleton  {
//   Dictionary dictionary = new Dictionary();
//   DictionarySingleton._privateConstructor();
// @override
// void initState() {
//   super.initState(BuildContext contex);
//
//   });//   var t = new Trie.Trie();
// // }
//
//
// // class DictionarySingleton  {
// //   Dictionary dictionary = new Dictionary();
// //   DictionarySingleton._privateConstructor();
// // @override
// // void initState() {
// //   super.initState(BuildContext contex);
// //
// //   });
// // }
// //   static final DictionarySingleton instance = DictionarySingleton._privateConstructor();
// // }
// }
//   static final DictionarySingleton instance = DictionarySingleton._privateConstructor();
// }


void getPermutations(String letters, int length, String pattern) {

  // Stores matches
  LinkedHashSet letterSet = new LinkedHashSet();

  // Get unique chars from input
  List<String> chars = letters.split("");
  final seen = Set<String>();
  final unique = chars.where((str) => seen.add(str)).toList();
  final uniqueLetters = unique.join();

  final bagOfItems = characters(uniqueLetters), items = Amalgams(length, bagOfItems);


  List<String> perms = new List<String>();
  for (final item in items()) {
    perms.add(item.join());
  }

  for (int j = 0; j< perms.length; j++) {  // For string in list of strings
    String perm = perms[j];
    for (int i = 0; i < length; i++) {
      // If num occurences of this letter matches, _ll
      // d
      if (pattern.substring(i, i + 1) != "_") {
        // Skip check of letter occurence vs input of "_" wildcard
        if (perm.substring(i, i+1) == pattern.substring(i, i+1)) {
          print(i);
          if (checkPosition(perm, pattern, letters, i)) {
            if (t.contains(perm)) {
              perms.remove(perm);
              letterSet.add(perm);
            }
          }
        }
        // Catch "llb"
        perms.remove(perm);
      }
    }
  }
  print(letterSet);
  print(perms);
}

bool checkPosition(String perm, String pattern, String letters, int pos) {
  if (perm.substring(pos, pos+1).allMatches(perm).length == perm.substring(pos, pos+1).allMatches(pattern).length) {
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
      await words.forEach((element) {t.addString(element);});
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
  String availableLetters = 'ahasdfvbjhsdll';
  String inputPattern = '_ll';
  int numLetters = 3;

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
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Number of Letters:',
            ),
            onChanged: (val) {
              numLetters = int.parse(val);
            },
          ),
          // TODO: Pass letters, pattern, length
          Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              FlatButton(
                child: Text('submit'),
                onPressed: () {
                  // TODO: VALIDATE letters.length length/pattern.length else no not accept
                  // dictionarySingleton
                  getPermutations(availableLetters, numLetters, inputPattern);
                }),
            ],
          ),
          // TODO: BUILD LISTVIEW TO READ TRIE MATCHES FROM PERMUTATIONS()
        ],
      ),
    );
  }
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
