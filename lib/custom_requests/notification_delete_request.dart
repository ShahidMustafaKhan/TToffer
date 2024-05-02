import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';

class NotificationDeleteRequest {
  Future<bool> notificationDeleteRequest(
      {required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString(PrefKey.userId);
      print('id: $id');

      var response = await CustomGetRequest()
          .httpGetRequest(url: 'delete/single/notification/$id');

      // Check the structure of the response and handle accordingly
      if (response is Map<String, dynamic> && response.containsKey('success')) {
        bool success = response[
            'success']; // Assuming 'success' is a key indicating the result
        if (success) {
          return true;
        } else {
          return false;
        }
      } else {
        // Handle unexpected response structure
        print('Unexpected response format: $response');
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
