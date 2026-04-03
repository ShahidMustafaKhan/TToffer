import 'package:tt_offer/repository/suggestion_api/suggestion_repository.dart';

import '../../models/suggestion_model.dart';

class SuggestionMockRepository implements SuggestionRepository {
  @override
  Future<SuggestionModel> getSuggestionApi(String? search) async {
    // if (search!.contains("iphone")) {
    return SuggestionModel(data: [
      Data(
        name: 'iphone 14 pro',
        description: 'iphone 14 pro',
        type: 'product',
      )
    ]);
    // } else {
    //   dynamic response = {};
    //   return SuggestionModel.fromJson(response);
    // }
  }
}
