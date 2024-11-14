import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class SendNotification {
  static Future<bool> sendNotification({
    required BuildContext context,
    required int userId,
    required String text,
    required String type,
    required String sellerId,
    required String buyerId,
    required String typeId,
    required String status,
    String? productId
  }) async {
    try {
      Map body = {
        "user_id": userId,
        "text": text,
        "type": type,
        "seller_id": sellerId,
        "buyer_id": buyerId,
        "type_id": typeId,
        "status": status,
        if(productId != null)
          "product_id": productId

      };
      var responce = await customPostRequest.httpPostRequest(
          url: AppUrls.sendNotificationUrl, body: body);

      if (responce["message"] != null &&
          responce["message"] == "Notification Created Successfully.") {
        showSnackBar(context, 'Notification Created Successfully', error : false);

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


class SendPushNotification {
  static Future<String> getAccessToken() async {
    // Load the service account key JSON file
    final serviceAccount = json.decode(await rootBundle.loadString('assets/service-account.json'));

    // Define the scope
    final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Create client using the service account
    final client = http.Client();
    final authClient = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(serviceAccount),
      _scopes,
    );

    // Return the access token
    return authClient.credentials.accessToken.data;
  }

  static Future<void> sendFCMNotification(String accessToken, String deviceToken) async {
    const url = 'https://fcm.googleapis.com/v1/projects/ttoffer-427813/messages:send';

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "message": {
        "token": "ciudihz8R9q0P_RKDnYM12:APA91bE9QYkFf4sc4sh6I_-gM3qwyWxtEpw-qi2ntL0lbFSP2nGflwckOJ4KEKtzYz1XmSAtlDacPb1eeZYsI8ChcHiZQLB0MS3hhtQGxfRBuNZHxJF17mvLxyaVbdjoOukuN3SY6L5D",
        "notification": {
          "body": "This is an FCM notification message!",
          "title": "FCM Message",
        },
      },
    });

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('FCM notification sent successfully');
    } else {
      print('Failed to send FCM notification: ${response.body}');
    }
  }



}