import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/models/notifications_model.dart';
import 'package:tt_offer/providers/notification_provider.dart';

class NotificationService {
  Future<void> notificationService({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(PrefKey.authorization);
      String? id = prefs.getString(PrefKey.userId);
      print('Authorization Token: $token');
      print('id: $id');

      var headers = {'Authorization': 'Bearer $token'};
      var dio = Dio();
      var response = await dio.get(
        'https://ttoffer.com/api/get/user/all/notifications/$id',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data; // Extracting data from the response

        // Assuming NotificationModel.fromJson expects a Map<String, dynamic>
        NotificationModel notificationModel =
            NotificationModel.fromJson(responseData);

        Provider.of<NotificationProvider>(context, listen: false)
            .getNotifications(notificationModel.data!);
      } else {
        print(response.statusMessage);
      }
    } catch (err) {
      print(err);
    }
  }
}
