import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/repository/google_auth/authentication.dart';

import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import '../../models/authentication_model.dart';
import '../../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepository {

  final _apiServices = NetworkApiService() ;

  Future<AuthenticationModel> loginApiWithEmail(dynamic data )async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.logInEmail, data);
    return AuthenticationModel.fromJson(response) ;
  }

  Future<AuthenticationModel> loginApiWithPhone(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.logInPhone, data);
    return AuthenticationModel.fromJson(response) ;
  }

  Future<AuthenticationModel> registerApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.registration, data);
    return AuthenticationModel.fromJson(response) ;
  }


}