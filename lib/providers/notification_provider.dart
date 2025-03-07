import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/notifications_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationData> notifications = [];

  bool unreadNotificationIndicator = false;
  int unreadNotificationCount = 0;


  getNotifications(List<NotificationData> newNotifications) {
    notifications = newNotifications;
    notifyListeners();
  }

  changeIndicatorStatus(bool value){
    unreadNotificationIndicator = value;
    if(value == false){
      setCountToZero();
    }
    else{
      incrementIndicatorCount();
    }
    notifyListeners();
  }

  incrementIndicatorCount(){
    unreadNotificationCount++;
  }

  setIndicatorCount(int value){
    if(value != 0){
      unreadNotificationIndicator = true;
    }
    else{
      unreadNotificationIndicator = false;
    }
    unreadNotificationCount = value;
    notifyListeners();
  }

  setCountToZero(){
    unreadNotificationCount= 0;
    notifyListeners();

  }








}
