import '../../models/notifications_model.dart';

abstract class NotificationRepository {
  Future<dynamic> createNotification(dynamic data);

  Future<NotificationModel> getNotification(int? userId);
}
