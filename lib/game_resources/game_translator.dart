import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void selectLanguage(BuildContext context) {

  // TODO: Move from buttons to scrollable selector for supported languages
  Map<String, String> _supportedLangs = {'Spanish': 'es', 'English': 'en'};
  // var langs = _supportedLangs.keys.toList();

  var alertDialog = AlertDialog(
      title: Text("Set Language",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Lato')),
      actions: [
        // ListView.builder(
        //     padding: const EdgeInsets.all(8),
        //     itemCount: _supportedLangs.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return new Column(
        //         children: <Widget> [
        //                 new FlatButton(
        //                   child: Text(
        //                   langs[index],
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(fontSize: 5, fontFamily: 'Lato'),
        //                 ),
        //                 onPressed: () => Navigator.of(context, rootNavigator: true).pop(
        //                     load(_supportedLangs[langs[index]]))
        //                 )]);
        //
        //     }),
        Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
                child: Text(
                  "Spanish",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontFamily: 'Lato'),
                ),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(
                    load(_supportedLangs['Spanish']))
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
                    load(_supportedLangs['English']))
            )),
      ]);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

Map<String, String> localizedStrings;

Future<bool> load(String languageCode) async {
  // Load the language JSON file from the "lang" folder
  String jsonString = await rootBundle.loadString('lang/${languageCode}.json');

  print('\nFileName for Translation: lang/${languageCode}.json\n');
  print('\nFile Contents: ' + jsonString + '\n');

  Map<String, dynamic> jsonMap = json.decode(jsonString);

  localizedStrings = jsonMap.map((key, value) {
    return MapEntry(key, value.toString());
  });

  return true;
}

String translate(String key) {
  print(key + ", " + "Translation: " + localizedStrings[key]);
  return localizedStrings[key];
}
