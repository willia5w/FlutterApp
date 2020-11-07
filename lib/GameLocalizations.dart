import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// #Acknowledgements: Reso Coder https://resocoder.com/2019/06/01/flutter-localization-the-easy-way-internationalization-with-json/

class GameLocalizations {

  final Locale locale;
  GameLocalizations(this.locale);

  static const LocalizationsDelegate<GameLocalizations> delegate = _GameLocalizationsDelegate();


  static GameLocalizations of(BuildContext context) {
    return Localizations.of<GameLocalizations>(context, GameLocalizations);
  }

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
    await rootBundle.loadString('lang/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }


  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _GameLocalizationsDelegate extends LocalizationsDelegate<GameLocalizations> {

  const  _GameLocalizationsDelegate();


  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  // Load the translated message
  @override
  Future<GameLocalizations> load(Locale locale) async {
    // Calls load
    GameLocalizations localizations = new GameLocalizations(locale);
    await localizations.load();
    return localizations;
  }


  @override
  bool shouldReload(_GameLocalizationsDelegate old) => false;
}