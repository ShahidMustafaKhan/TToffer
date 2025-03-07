import 'package:tt_offer/config/app_urls.dart';
import '../../data/network/network_api_services.dart';


class OfferRepository {

  final _apiServices = NetworkApiService() ;


  Future<dynamic> makeOfferApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.makeOffer, data);
    return response;
  }

  Future<dynamic> acceptOfferApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.acceptOfferUrl, data);
    return response;
  }

  Future<dynamic> rejectOfferApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.rejectOfferUrl, data);
    return response;
  }

  Future<dynamic> customOfferApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.customOfferUrl, data);
    return response;
  }




}