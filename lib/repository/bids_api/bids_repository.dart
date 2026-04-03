import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/bids_model.dart';

import '../../data/network/network_api_services.dart';

class BidsRepository {

  final _apiServices = NetworkApiService() ;

  Future<BidsModel> getBidsApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.getPlaceBids, data);
    return BidsModel.fromJson(response) ;
  }

  Future<dynamic> placeBidsApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.placeBid, data);
    return response;
  }


  Future<BidsData> getHighestBidsApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.highestBid, data);
    return BidsData.fromJson(response['data']);
  }


}