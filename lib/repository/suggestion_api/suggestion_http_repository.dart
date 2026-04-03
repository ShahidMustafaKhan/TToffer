import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/repository/suggestion_api/suggestion_repository.dart';

import '../../../data/network/network_api_services.dart';
import '../../models/suggestion_model.dart';

class SuggestionHttpRepository implements SuggestionRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<SuggestionModel> getSuggestionApi(String? search) async {
    dynamic response = await _apiServices.getGetApiResponse(
        "${AppUrls.baseUrl + AppUrls.getSuggestion}?query=$search");
    return SuggestionModel.fromJson(response);
  }
}
