import 'package:tt_offer/config/app_urls.dart';

import '../../data/network/network_api_services.dart';
import '../../models/authentication_model.dart';
import 'auth_repository.dart';

class AuthHttpRepository implements AuthRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<AuthenticationModel> loginApiWithEmail(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.logInEmail, data);
    return AuthenticationModel.fromJson(response);
  }

  @override
  Future<AuthenticationModel> loginApiWithPhone(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.logInPhone, data);
    return AuthenticationModel.fromJson(response);
  }

  @override
  Future<AuthenticationModel> registerApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.registration, data);
    return AuthenticationModel.fromJson(response);
  }
}
