import '../../models/suggestion_model.dart';

abstract class SuggestionRepository {
  Future<SuggestionModel> getSuggestionApi(String? search);
}
