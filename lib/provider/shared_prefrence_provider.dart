import 'dart:convert';

import 'package:ocpua_app/support/Auth/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  ///// Singleton
  static SharedPreferencesProvider _spProvider;

  SharedPreferences prefs;
  String USER = "User";

  static SharedPreferencesProvider instance() {
    if (_spProvider == null) {
      _spProvider = SharedPreferencesProvider._();
    }
    return _spProvider;
  }

  SharedPreferencesProvider._();

  AuthUser _user;
  AuthUser get currentUser => this._user;

  void setUser(AuthUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        USER, [user.token, user.id, user.expire, user.credintials]);
  }

  Future deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(USER, []);
  }

  Future<List<String>> getUser(String USER) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(USER);
  }
}
