import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/repository/notification/notification_repository.dart';

import '../../config/app_urls.dart';
import '../../config/keys/pref_keys.dart';
import '../../main.dart';
import '../../models/notifications_model.dart';

class NotificationViewModel with ChangeNotifier {
  NotificationRepository notificationRepository;
  NotificationViewModel({required this.notificationRepository});

  List<NotificationData> notifications = [];

  bool unreadNotificationIndicator = false;
  int unreadNotificationCount = 0;

  getNotifications() async {
    notificationRepository
        .getNotification(int.tryParse(pref.getString(PrefKey.userId) ?? ''))
        .then((value) {
      notifications = value.data!;
      notifyListeners();
    });
  }

  void checkForUnreadMessage(
      List<NotificationData>? data, BuildContext context) {
    if (data == null) return;

    changeIndicatorStatus(false); // Reset indicator to false

    for (var notification in data) {
      if (notification.status == 'unread') {
        changeIndicatorStatus(true);
        // if(notification.type == 'conversation'){
        //   changeChatStatus(context: context, notificationData: notification);
        // }
        // changeStatus(context: context, id: notification.id.toString());
      }
    }
  }

  void changeAllNotificationStatus(
      List<NotificationData>? data, BuildContext context) {
    if (data == null) return;

    changeIndicatorStatus(false); // Reset indicator to false

    for (var notification in data) {
      if (notification.status == 'unread') {
        changeStatus(context: context, id: notification.id.toString());
      }
    }
  }

  Future<void> changeStatus(
      {required BuildContext context, required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(PrefKey.authorization);

      var headers = {'Authorization': 'Bearer $token'};
      var dio = Dio();
      var response = await dio.get(
        '${AppUrls.baseUrl}change/notification/status/$id',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (err) {
      print(err);
    }
  }

  changeIndicatorStatus(bool value) {
    unreadNotificationIndicator = value;
    if (value == false) {
      setCountToZero();
    } else {
      incrementIndicatorCount();
    }
    notifyListeners();
  }

  incrementIndicatorCount() {
    unreadNotificationCount++;
  }

  setIndicatorCount(int value) {
    if (value != 0) {
      unreadNotificationIndicator = true;
    } else {
      unreadNotificationIndicator = false;
    }
    unreadNotificationCount = value;
    notifyListeners();
  }

  setCountToZero() {
    unreadNotificationCount = 0;
    notifyListeners();
  }

  Future<void> createNotification(
      {int? productId,
      int? sellerId,
      int? buyerId,
      int? userId,
      String? type,
      String? typeId,
      String? comment}) async {
    dynamic data = {
      "user_id": userId,
      "text": comment,
      "type": type,
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "type_id": typeId,
      "product_id": productId
    };

    try {
      notificationRepository.createNotification(data);
      log("notification creation Successful");
    } catch (e) {
      log("notification ${e.toString()}");
      log("notification ${e.toString()}");
    }
  }
}
