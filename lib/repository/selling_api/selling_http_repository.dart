import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/repository/selling_api/selling_repository.dart';

import '../../../data/network/network_api_services.dart';
import '../../models/selling_products_model.dart';

class SellingHttpRepository extends SellingRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<SellingProductsModel> getSellingProducts() async {
    dynamic response = await _apiServices
        .getGetApiResponse(AppUrls.baseUrl + AppUrls.sellingScreen);
    return SellingProductsModel.fromJson(response);
  }

  @override
  Future<dynamic> markSold(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.markProductSold, data);
    return response;
  }
}
