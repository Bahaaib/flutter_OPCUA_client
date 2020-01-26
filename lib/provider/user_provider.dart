import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ocpua_app/API/ResourcesAPI.dart';


class UserProvider {
  ///// Singleton
  static UserProvider _userProvider;

  static UserProvider instance() {
    if (_userProvider == null) {
      _userProvider = UserProvider._();
    }
    return _userProvider;
  }

  UserProvider._() {
    _resourcesAPI = ResourcesAPI();
  }

  //User _user;

  //User get currentUser => this._user;

  ResourcesAPI _resourcesAPI;

//  void _setUser(User user) {
//    this._user = user;
//  }

  /*
  * sends given user to the API and save it locally
  */
//  Future<User> createOrUpdateUser(User newUser, {bool save = true, bool image_update = false}) async {
//    QueryBuilder qb = QueryBuilder();
//
//    User u = await getUser(newUser.doc_id, 'doc_id');
//
//    qb.insert(newUser.toJson());
//    if(image_update && newUser.type==CodeStrings.performer){
//      qb.runnables(["performerimage:before"]);
//    }
//    if(u!=null){
//      qb.where("id", "=", newUser.id);
//    }
//    newUser.id = null;
//
//    User user = await _resourcesAPI.request(newUser.type, json.encode(qb.commit()));
//    if(user!=null){
//      user.type = newUser.type;
//    }
//    if (save) _setUser(user);
//    return user;
//  }
//
//  Future<User> getUser(String value, String column) async {
//    QueryBuilder qb = QueryBuilder();
//    qb.select([
//    ]).where(column, "=", value);
//    String qS = json.encode(qb.commit());
//    User req;
//    User per;
//    await Future.wait([
//      netFunc(() async {
//        req = await _resourcesAPI.request(CodeStrings.requester, qS);
//      }, showLoading: false),
//      netFunc(() async {
//        per = await _resourcesAPI.request(CodeStrings.performer, qS);
//      }, showLoading: false),
//    ]);
//    _user = per == null ? req : per;
//    if (_user != null) {
//      _user.type = per == null ? CodeStrings.requester : CodeStrings.performer;
//    }
//    _setUser(_user);
//    return _user;
//  }
//
//  Future<void> setUserPhoto(String id, File image) async {
//    //String url = await _resourcesAPI.uploadPhoto(id, image);
//  }
//
  dispose() {
    _userProvider = null;
  }
}
