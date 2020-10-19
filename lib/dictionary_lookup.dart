import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart'show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:trotter/trotter.dart';

import 'trie.dart' as Trie;
var t = new Trie.Trie();
var stopwatch = new Stopwatch();
String elapsedTime = "0";

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/textFiles/wordlist.txt');
}

class DictionaryRoute extends StatefulWidget {
  @override
  _DictionaryRouteState createState() => _DictionaryRouteState();
}

final _text = TextEditingController();
bool _validate = false;

class _DictionaryRouteState extends State<DictionaryRoute> {

  List<String> words = List<String>();

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

  String time = "0";

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
            // TODO: View should expand to fill screen
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: words.length,
                itemBuilder: (BuildContext context, int index) {
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

// TODO: Validation broken, not matching pattern
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
      // if (pattern.substring(i, i) != "_") {
        // If current letter doesnt match letter in pattern then skip
        if (perm.substring(i, i + 1) == pattern.substring(i, i + 1)) {
          // If count of occurences for this letter doesnt match occurences in the pattern then skip
          if (checkOccurences(perm, pattern, letters, i)) {
            if (t.contains(perm)) {
              letterSet.add(perm);
            }
          }
        }
      // }
    }
  }
  stopwatch.stop();
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

