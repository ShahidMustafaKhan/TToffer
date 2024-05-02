import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';

class CustomGetRequest {
  Future httpGetRequest({required String url}) async {
    final uri = AppUrls.baseUrl + url;
    try {
      log("Get Request Url $uri");
      String token = pref.getString(PrefKey.authorization)!;

      var headers = {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer $token"
      };
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: headers,
      );
      log("Get Request status code ${response.statusCode}");
      log("Get Request Body ${response.body}");
      Map jsonn = jsonDecode(response.body);

      // Map jsonDecoded = json.decode(response.body);
      // log("jsonDecoded = $jsonDecoded");
      return jsonn;
    } catch (err) {
      log(err.toString());

      return null;
    }
  }
}
