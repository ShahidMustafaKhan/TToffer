import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/models/payment_card_model.dart';
import 'package:tt_offer/models/subscription_model.dart';

import '../../../data/network/network_api_services.dart';



class PaymentRepository {

  final _apiServices = NetworkApiService() ;

  Future<dynamic> sellFasterApi(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.sellFaster, data);
    return response ;
  }

  Future<dynamic> googlePayApi(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.googlePayPayment, data);
    return response ;
  }

  Future<dynamic> createPaymentIntent(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.paymentIntent, data);
    return response ;
  }

  Future<dynamic> stripePaymentCharge(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.paymentCharge, data);
    return response ;
  }

  Future<dynamic> googlePayment(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.googlePayment, data);
    return response ;
  }

  Future<dynamic> addNewCard(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addNewCard, data);
    return response ;
  }

  Future<PaymentCardsModel> getAllCard(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.getAllCard, data);
    return PaymentCardsModel.fromJson(response) ;
  }

  Future<PaymentCardDetailModel> getCardDetail(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.getCardDetail, data);
    return PaymentCardDetailModel.fromJson(response) ;
  }

  Future<SubscriptionModel> getAllSubscription()async{
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getAllSubscription);
    return SubscriptionModel.fromJson(response) ;
  }






}