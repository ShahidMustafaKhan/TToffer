import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/payment_card_model.dart';
import 'package:tt_offer/models/subscription_model.dart';
import 'package:tt_offer/repository/payment_api/payment_repository.dart';

import '../../../data/network/network_api_services.dart';

class PaymentHttpRepository implements PaymentRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<dynamic> sellFasterApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.sellFaster, data);
    return response;
  }

  @override
  Future<dynamic> googlePayApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.googlePayPayment, data);
    return response;
  }

  @override
  Future<dynamic> createPaymentIntent(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.paymentIntent, data);
    return response;
  }

  @override
  Future<dynamic> stripePaymentCharge(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.paymentCharge, data);
    return response;
  }

  @override
  Future<dynamic> googlePayment(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.googlePayment, data);
    return response;
  }

  @override
  Future<dynamic> addNewCard(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addNewCard, data);
    return response;
  }

  @override
  Future<PaymentCardsModel> getAllCard(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getAllCard, data);
    return PaymentCardsModel.fromJson(response);
  }

  @override
  Future<PaymentCardDetailModel> getCardDetail(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getCardDetail, data);
    return PaymentCardDetailModel.fromJson(response);
  }

  @override
  Future<SubscriptionModel> getAllSubscription() async {
    dynamic response = await _apiServices
        .getGetApiResponse(AppUrls.baseUrl + AppUrls.getAllSubscription);
    return SubscriptionModel.fromJson(response);
  }
}
