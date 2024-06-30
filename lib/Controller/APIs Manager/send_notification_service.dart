import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';

class SendNotification {
  static Future<bool> sendNotification({
    required BuildContext context,
    required int userId,
    required String text,
    required String type,
    required int typeId,
    required String status,
  }) async {
    try {
      Map body = {
        "user_id": userId,
        "text": text,
        "type": type,
        "type_id": typeId,
        "status": status,
      };
      var responce = await customPostRequest.httpPostRequest(
          url: AppUrls.sendNotificationUrl, body: body);

      if (responce["message"] != null &&
          responce["message"] == "Notification Created Successfully.") {
        showSnackBar(context, 'Notification Created Successfully');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
