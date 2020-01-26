import 'dart:convert';

import 'package:ocpua_app/provider/shared_prefrence_provider.dart';
import 'package:ocpua_app/resources/links.dart';
import 'package:ocpua_app/support/Auth/AuthMethod.dart';
import 'package:ocpua_app/support/Auth/User.dart';
import 'package:ocpua_app/support/Fly/fly.dart';
import 'package:ocpua_app/support/GraphClient/GrapghQlBuilder.dart';

class EmailLoginMethod implements AuthMethod {
  @override
  String serviceName = 'email';
  String _email;
  String _password;

  Node signupMutation;

  String signupLink = AppLinks.protocol +
      AppLinks.subDomain +
      "." +
      AppLinks.apiBaseLink +
      "/graphql";
  Fly fly;

  EmailLoginMethod(this._email, this._password) {
    // create the query
    fly = Fly(this.signupLink);
    signupMutation = Node(name: "mutation", cols: [
      Node(name: 'auth_user', args: {
        "type": "email",
        "credentials": {"email": this._email, "password": this._password},
      }, cols: [
        'jwtToken',
        'expire',
        'id',
      ])
    ]);
  }
  Future<void> saveUser(savedUser) async {
    final SharedPreferencesProvider sharedPrefs =
        SharedPreferencesProvider.instance();
    sharedPrefs.setUser(savedUser);
  }

  @override
  Future<AuthUser> auth() async {
    Map queryMap = {
      "operationName": null,
      "variables": {},
      "query": GraphQB(this.signupMutation).getQueryFor()
    };

     AuthUser user = await fly.request(query: queryMap, parser: AuthUser());
     saveUser(user);
     return user;
  }
}
