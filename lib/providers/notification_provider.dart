import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/notifications_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationData> notifications = [];

  getNotifications(List<NotificationData> newNotifications) {
    notifications = newNotifications;
    notifyListeners();
  }
}
