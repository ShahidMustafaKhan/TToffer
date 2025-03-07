import 'package:tt_offer/config/app_urls.dart';
import '../../data/network/network_api_services.dart';


class CategoryRepository {

  final _apiServices = NetworkApiService() ;


  Future<dynamic> categoryApi() async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.categories, {});
    return response;
  }

  Future<dynamic> subCategoryApi() async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.subCategories, {});
    return response;
  }



}