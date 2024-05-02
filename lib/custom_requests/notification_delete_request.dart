import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/custom_get_request.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';

class NotificationDeleteRequest {
  Future notificationDeleteRequest({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString(PrefKey.userId);
      print('id: $id');

      var res = await CustomGetRequest()
          .httpGetRequest(url: 'delete/single/notification/$id');

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
