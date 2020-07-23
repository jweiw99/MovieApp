import 'dart:convert';

// external package
import 'package:http/http.dart' as http;

class HttpRequest {
  HttpRequest(this._url);

  final String _url;

  Future<dynamic> getData(String param) async {
    try {
      http.Response response =
          await http.get(_url + param, headers: {"Accept": "application/json"});

      // if success
      if ([200, 201].contains(response.statusCode)) {
        final responseData = json.decode(response.body);
        return responseData;
      }
      return null;
    } on Error catch (e) {
      //print("Error");
      return null;
    }
  }
}
