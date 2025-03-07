import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/repository/notification/notification_repository.dart';



class NotificationViewModel with ChangeNotifier {

  NotificationRepository notificationRepository ;
  NotificationViewModel({required this.notificationRepository});



  Future<void> createNotification({int? productId, int? sellerId, int? buyerId, int? userId, String? type, String? typeId, String? comment}) async {

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

    }catch(e){
      log("notification ${e.toString()}");
      log("notification ${e.toString()}");
    }

  }






}