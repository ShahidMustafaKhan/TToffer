import 'package:tt_offer/config/app_urls.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/product_model.dart';
import '../../models/chat_list_model.dart';
import '../../models/selling_products_model.dart';


class SellingRepository {

  final _apiServices = NetworkApiService() ;

  Future<SellingProductsModel> getSellingProducts() async {
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.sellingScreen);
    return SellingProductsModel.fromJson(response) ;
  }

  Future<dynamic> markSold(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.markProductSold, data);
    return response;
  }







}