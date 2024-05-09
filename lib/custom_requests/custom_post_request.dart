import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';

class CustomPostRequest {
  static CustomPostRequest? customPostRequest; // Singleton instance

  factory CustomPostRequest() {
    customPostRequest ??= CustomPostRequest._internal();
    return customPostRequest!;
  }

  CustomPostRequest._internal(); // Private constructor

  Future httpPostRequest(
      {required String url, required Map body, bool? noTokenHeader}) async {
    final uri = AppUrls.baseUrl + url;

    log("body = $body");

    noTokenHeader ??= false;

    var headers;

    if (noTokenHeader == false) {
      String token = pref.getString(PrefKey.authorization)!;
      headers = {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
    } else {
      headers = {
        "Content-Type": "application/json",
        "accept": "application/json",
      };
    }
    try {
      log("Post Request Url $uri");

      http.Response response = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: json.encode(body),
      );
      log("Post Request status code ${response.statusCode}");
      log("Post Request Body ${response.body}");
      Map jsonn = jsonDecode(response.body);

      return jsonn;
    } catch (err) {
      log(err.toString());

      return null;
    }
  }
}
