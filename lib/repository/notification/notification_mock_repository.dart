import 'package:tt_offer/mock/product_mock_data.dart';
import 'package:tt_offer/repository/notification/notification_repository.dart';

import '../../data/network/network_api_services.dart';
import '../../models/notifications_model.dart';

class NotificationMockRepository implements NotificationRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<dynamic> createNotification(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<NotificationModel> getNotification(int? userId) async {
    return NotificationModel(
      data: [
        NotificationData(
          user: getMockProductById(2).user,
          product: getMockProductById(2),
          id: 1,
          status: 'unread',
          type: 'conversation',
          typeId: "123456",
          text: "New Message Received",
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          userId: getMockProductById(2).userId,
        ),
        NotificationData(
          user: getMockProductById(3).user,
          product: getMockProductById(3),
          id: 1,
          status: 'unread',
          type: 'conversation',
          typeId: "123456",
          text: "New Message Received",
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          userId: getMockProductById(3).userId,
        )
      ],
    );
  }
}
