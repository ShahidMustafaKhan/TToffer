import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/saved_model.dart';
import 'package:tt_offer/models/wishlist_model.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/post_product_model.dart';
import '../../../models/user_model.dart';
import '../../models/suggestion_model.dart';


class SuggestionRepository {

  final _apiServices = NetworkApiService() ;


  Future<SuggestionModel> getSuggestionApi(String? search) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.getSuggestion}?query=$search");
    return SuggestionModel.fromJson(response);
  }



}