import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' show Client, Response;
import 'package:http_middleware/http_middleware.dart';
import 'package:http_logger/http_logger.dart';
import 'package:ocpua_app/PODO/LocalError.dart';
import 'package:ocpua_app/resources/errors.dart';



class APIManager {
  static final baseUrl = "134.209.243.56";
  //static Client client = Client();
  static HttpClientWithMiddleware client;

  static Future<Response> get(String path, {Map<String, String> body}) async {
    var uri = Uri.http(baseUrl, "/api/" + path, body);
    print(uri.toString());
    final response = await client.get(uri);
    return _handleResponse(response);
  }

  static Future<Response> post(String path, {String body, Map<String,String> paramters}) async {
    Uri uri = Uri.http(baseUrl, "/api/" + path, paramters);
    if(client == null){
      client = HttpClientWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);
    }
    final response = await client.post(uri,
        body: body,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        }).timeout(Duration(minutes: 5),onTimeout: ()=>throw AppErrors.en14);
    return response;
  }

  static Response _handleResponse(Response response) {
    if (response.statusCode != 200) {
      throw LocalError(0,"Network Error", response.body,"NETWORK");
    }
    print(response.body.toString());
    return response;
  }
}
