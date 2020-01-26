import 'dart:convert';

import 'package:http/http.dart';
import 'package:ocpua_app/API/APIManager.dart';
import 'package:ocpua_app/PODO/LocalError.dart';
import 'package:ocpua_app/resources/errors.dart';


class ResourcesAPI extends APIManager {
  final String DATA_JSON_ARRAY = "data";

  Future<dynamic> request(String resourceName, String query) async {
    //TODO:: ADD FCM_TOKEN
    Response response = await APIManager.post(resourceName,
        body: query, paramters: {"fcm_token": "TESTT"}).catchError((error) {
      throw AppErrors.en4;
    });
    var myData = json.decode(response.body);

    if (myData is Map && myData.containsKey("errorsNo")) {
      if (myData["errorsNo"] != 0) throw LocalError.fromJson(myData);
    }

    switch (resourceName) {
      default:
        return null;
    }
  }
}
