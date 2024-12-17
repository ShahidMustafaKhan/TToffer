import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../view_model/notification/notification_view_model.dart';

class SendNotification {
  static Future<void> sendNotification({
    required BuildContext context,
    required int? userId,
    required String text,
    required String type,
    required int? sellerId,
    required int? buyerId,
    required String typeId,
    required int? productId
  }) async {
    try {

      NotificationViewModel notificationViewModel = Provider.of<NotificationViewModel>(context, listen: false);

      await notificationViewModel.createNotification(
          userId: userId,
          comment: text,
          type: type,
          sellerId: sellerId,
          buyerId: buyerId,
          typeId: typeId,
          productId: productId
      );


    } catch (e) {

      log(e.toString());
    }
  }
}


