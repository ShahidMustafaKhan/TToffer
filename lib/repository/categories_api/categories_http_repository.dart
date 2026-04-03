import 'package:tt_offer/config/app_urls.dart';

import '../../data/network/network_api_services.dart';
import 'categories_repository.dart';

class CategoryHttpRepository implements CategoryRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<dynamic> categoryApi() async {
    dynamic response = await _apiServices
        .getPostApiResponse(AppUrls.baseUrl + AppUrls.categories, {});
    return response;
  }

  @override
  Future<dynamic> subCategoryApi() async {
    dynamic response = await _apiServices
        .getPostApiResponse(AppUrls.baseUrl + AppUrls.subCategories, {});
    return response;
  }
}
