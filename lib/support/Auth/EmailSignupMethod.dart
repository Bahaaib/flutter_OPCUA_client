import 'dart:convert';

import 'package:ocpua_app/resources/links.dart';
import 'package:ocpua_app/support/Auth/AuthMethod.dart';
import 'package:ocpua_app/support/Auth/User.dart';
import 'package:ocpua_app/support/Fly/fly.dart';
import 'package:ocpua_app/support/GraphClient/GrapghQlBuilder.dart';


class EmailSignupMethod implements AuthMethod {
  @override
  String serviceName = 'email';
  String _email;
  String _password;
  String _confirmPassword;

  Node signupMutation;

  String signupLink = AppLinks.protocol +
      AppLinks.subDomain +
      "." +
      AppLinks.apiBaseLink +
      "/graphql";
  Fly fly;

  EmailSignupMethod(this._email, this._password, this._confirmPassword) {
    // create the query
    fly = Fly(this.signupLink);
    signupMutation = Node(
      name: 'create_auth_user',
      args: {
        "type": "email",
        "credentials": {
          "email": this._email,
          "password": this._password,
          "password_confirmation": this._confirmPassword
        },
      },
    );
  }

  @override
  Future<AuthUser> auth() async {
    final result = await fly.mutation([this.signupMutation]);
    return AuthUser();
  }
}
