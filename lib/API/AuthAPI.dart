
import 'package:flutter/services.dart';
import 'package:ocpua_app/API/APIManager.dart';
import 'package:ocpua_app/PODO/LocalError.dart';
import 'package:ocpua_app/resources/string.dart';


class AuthAPI extends APIManager {
  static final AuthAPI _authAPI = AuthAPI._internal();
  String USER_C = "Users";

  factory AuthAPI() {
    return _authAPI;
  }

  AuthAPI._internal();

  static LocalError parseFirebaseErrors(PlatformException error) {
    LocalError r = LocalError(0, "", "", "Firebase");
    if (error.code == "ERROR_WRONG_PASSWORD") {
      r.msg = AppStrings.invalidPassword;
    } else if (error.code == "ERROR_USER_NOT_FOUND") {
      r.msg = AppStrings.invalidEmail;
    } else if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
      r.msg = AppStrings.invalidEmail;
    }
    return r;
  }

/*
   * Firebase Auth Login with email & password
   */
//  Future<AuthUser> loginWithEmail(String email, String password) async {
//
//  }
//
//  Future<AuthUser> signupWithEmail(String email, String password) async {
//
//  }
//  Future<AuthUser> editEmail(
//      String email, User user, String password) async {
//  }

//  Future<bool> resetPassword(String email) async {
//
//  }
}