import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ocpua_app/resources/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LangCode { EN, AR }

class SettingsBloc {
  static String _lang = CodeStrings.englishCode;
  static TextDirection langDirection = TextDirection.ltr;
  static SharedPreferences _prefs;

  static String get appLang => _lang;

  static const String PREFS_LANG = "Language";

  static Future<bool> init(BuildContext context) async {
    //setting prefs
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();

    _initLanguage(context: context);
    return true;
  }


  static void _initLanguage({BuildContext context}) {
    _lang = _prefs.getString(PREFS_LANG);

    if (_lang == null) {
      _lang = Localizations.localeOf(context).languageCode;
    }

    if (_lang == CodeStrings.englishCode) {
      langDirection = TextDirection.ltr;
    } else if (_lang == CodeStrings.arabicCode) {
      langDirection = TextDirection.rtl;
    } else {
      _lang = CodeStrings.englishCode;
      langDirection = TextDirection.ltr;
    }
  }
}
