import 'dart:convert';

import 'package:ocpua_app/support/Fly/fly.dart';

class AuthUser implements Parser<AuthUser> {
  String credintials;
  String expire;
  String token;
  String id;

  AuthUser({this.token, Map<String, String> credintials}) {
    this.credintials = jsonEncode(credintials);
  }

  AuthUser.cached(String token,String id,String expire , String credentials){
    this.token = token;
    this.id = id;
    this.expire = expire;
    this.credintials = credentials;

    print("Expire is $expire");

    //return this;
  }

  @override
  dynamicParse(data) {
    // TODO: implement dynamicParse
    return null;
  }

  @override
  AuthUser parse(data) {
    Map parsingData = data;
    if (parsingData.containsKey('auth_user')) {
      this.expire = data['auth_user']['expire'];
      this.token = data['auth_user']['jwtToken'];
      this.id = data['auth_user']['id'];
    } else {
      this.expire = data['create_auth_user']['expire'];
      this.token = data['create_auth_user']['jwtToken'];
      this.id = data['create_auth_user']['id'];
    }
    return this;
  }

  @override
  List<String> querys;
}
