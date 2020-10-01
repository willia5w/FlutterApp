

import 'package:flutter/material.dart';
import 'package:trotter/trotter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'dart:io';
import 'dart:convert';

import 'trie.dart' as Trie;
var t = new Trie.Trie();

void main() {
  runApp(MyApp());

  // Get text file
  // var file = File('test.txt');
  // var contents;
  // // Read file
  // contents = file.readAsString();
  // print(contents);

  // Load wordlist into Trie
  t.addStrings(['one', 'two']);
  print(t.contains('one')); // Expected = True

  final bagOfItems = characters('dan'), perms = Permutations(2, bagOfItems);
  for (final perm in perms()) {
    // Validate Regex
    print(perm);
  }
}


// Reads words line-by-line into the Trie
void readFileByLines() async {

  // Adding file contents to Trie
  LineSplitter.split(FileUtils.readFromFile().toString()).forEach((line) => t.addString('$line'));

  print(await FileUtils.readFromFile().toString());

  Future.delayed(const Duration(milliseconds: 400), () {
    print(t.contains('three'));  // Expected = True
  });
}

// Async File Opening and Reading Methods
class FileUtils {
  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/lib/test.txt');
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return "";
    }
  }
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

// Testing other option for opening file
class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path.assets/textFiles/wordlist.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          Align(
              alignment: Alignment.center,
              child: RaisedButton(
                  child: Text('Load Dict', style: TextStyle(fontSize: 24)),
                  onPressed: () => readFileByLines())),
          SizedBox(
            height: 15.0,
          ),
          TextField(
            // TODO: Feed letters into Permutations() method
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Available Letters:',
            ),
          ),
          TextField(
            // TODO: Filter Permut
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Pattern:',
            ),
          ),
          TextField(
            // TODO: Feed length into Permutations() method
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Number of Letters:',
            ),
          ),
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
