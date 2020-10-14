import 'dart:async';
import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Method that retrives tranlated messages
// We have to build this file before we uncomment the next import line,
// and we'll get to that shortly
// import '../../l10n/messages_all.dart';
class GameLocalizations {

  final Locale locale;
  GameLocalizations(this.locale);
  // //
  static const LocalizationsDelegate<GameLocalizations> delegate = _GameLocalizationsDelegate();
  // GameLocalizationsDelegate();

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
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

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _GameLocalizationsDelegate extends LocalizationsDelegate<GameLocalizations> {

  const  _GameLocalizationsDelegate();


  // Returns True if the languageCode is supported by our app
  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  // Load the translated message
  @override
  Future<GameLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    GameLocalizations localizations = new GameLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  // @override
  // Future<GameLocalizations> load(Locale locale) => GameLocalizations.load(locale);

  // TODO: Returns true when the localization changes. Update to allow changing
  @override
  bool shouldReload(_GameLocalizationsDelegate old) => false;
// bool shouldReload(LocalizationsDelegate<GameLocalizations> old) => true;
}