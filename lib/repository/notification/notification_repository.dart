import 'package:tt_offer/config/app_urls.dart';
import '../../data/network/network_api_services.dart';


class NotificationRepository {

  final _apiServices = NetworkApiService() ;


  Future<dynamic> createNotification(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.sendNotificationUrl, data);
    return response;
  }





}