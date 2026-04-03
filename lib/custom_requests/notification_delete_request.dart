
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';

class NotificationDeleteRequest {
  Future<bool> notificationDeleteRequest(
      {required BuildContext context, int? notificationId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString(PrefKey.userId);
      print('id: $id');

      var response = await CustomGetRequest()
          .httpGetRequest(url: 'delete/single/notification/$notificationId');

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

  Future deleteAllNotificationRequest(
      {required BuildContext context, required List<int> notifications}) async {
    try {
      Map body = {'ids': notifications};

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'delete/notifications', body: body);

      if (res) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);

      return false;
    }
  }
}
