import 'package:tt_offer/config/app_urls.dart';

import '../../../data/network/network_api_services.dart';



class VerificationRepository {

  final _apiServices = NetworkApiService() ;

  Future<dynamic> verifyEmail(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.verifyEmail, data);
    return response ;
  }

  Future<dynamic> verifyEmailOtp(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.verifyEmailCode, data);
    return response;
  }

  Future<dynamic> forgetPasswordEmailVerification(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.forgotPasswordEmail, data);
    return response ;
  }

  Future<dynamic> forgetPasswordEmailOtpVerification(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.verifyForgotPasswordEmail, data);
    return response;
  }

  Future<dynamic> resetPassword(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.resetPassword, data);
    return response;
  }







}