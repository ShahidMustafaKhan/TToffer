import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/repository/notification/notification_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../models/notifications_model.dart';

class NotificationHttpRepository implements NotificationRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<dynamic> createNotification(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.sendNotificationUrl, data);
    return response;
  }

  @override
  Future<NotificationModel> getNotification(int? userId) async {
    dynamic response = await _apiServices.getGetApiResponse(
        "${AppUrls.baseUrl}get/user/all/notifications/$userId");
    return NotificationModel.fromJson(response);
  }
}
