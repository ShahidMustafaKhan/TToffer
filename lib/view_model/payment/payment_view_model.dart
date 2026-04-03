import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/repository/payment_api/payment_repository.dart';

import '../../data/response/api_response.dart';
import '../../models/payment_card_model.dart';



class PaymentViewModel with ChangeNotifier {

  PaymentRepository paymentRepository ;
  PaymentViewModel({required this.paymentRepository});

  bool _loading = false ;
  bool get loading => _loading ;


  setLoading(bool value){
    _loading = value ;
    notifyListeners();
  }

  bool _paymentLoading = false ;
  bool get paymentLoading => _paymentLoading ;


  setPaymentLoading(bool value){
    _paymentLoading = value ;
    notifyListeners();
  }

  bool _checkoutLoading = false ;
  bool get checkoutLoading => _checkoutLoading ;


  setCheckOutLoading(bool value){
    _checkoutLoading = value ;
    notifyListeners();
  }


  ApiResponse<List<PaymentCard>> paymentCardList = ApiResponse.loading();

  setPaymentCardsList(ApiResponse<List<PaymentCard>> response){
    paymentCardList = response ;
    notifyListeners();
  }

  ApiResponse<PaymentCard?> selectedPaymentCard = ApiResponse.notStarted();

  setSelectedPaymentCard(ApiResponse<PaymentCard?> response){
    selectedPaymentCard = response ;
    notifyListeners();
  }


  Future<void> sellFaster(
      {int? productId,
      int? userId,
      int? subscriptionId,
      dynamic chargeId, bool googlePay = false,

      bool save= false}) async {

    Map<String, dynamic> data = {
      'product_id': productId,
      'user_id': userId,
      'subscription_id': subscriptionId,
      "charge_id" : chargeId,
      "type" : googlePay ? 'google_pay' : 'stripe',
      if(googlePay == true)
        "google_pay_id" : chargeId,
    };

    try {
      setLoading(true);
      await paymentRepository.sellFasterApi(data);
      setLoading(false);
    }catch(e){
      setLoading(false);
      log("sell faster api ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<String?> createPaymentIntent() async {

    Map<String, dynamic> data = {
    };

    try {
      final response = await paymentRepository.createPaymentIntent(data);
      return response["data"]["client_secret"];
    }catch(e){
      log("create payment intent ${e.toString()}");
      throw AppException(e.toString());
    }

  }

  Future<dynamic> stripeChargePayment(
      {
        double? amount,
        String? paymentMethodId,
        int? productId,
        bool loading = false
      }
      ) async {

    Map<String, dynamic> data = {
      "amount" : amount,
      "payment_method_id" : paymentMethodId,
      "return_url" : "http://www.google.com",
      "currency" : "aed",
      "product_id" : productId,
    };

    try {
      if(loading == true){
      }
      final response = await paymentRepository.stripePaymentCharge(data);
      return response['data']['latest_charge'];
    }catch(e){
      log("stripe charge payment ${e.toString()}");
      throw AppException(e.toString());
    }

  }

  Future<void> googlePayPayment(
      {
        double? amount,
        String? token,
        String? lastFour,
        String? brand,
        int? userId,
        bool loading = false
      }
      ) async {

    Map<String, dynamic> data = {
      "amount" : amount,
      "token" : token,
      "last_four" : lastFour,
      "brand" : brand,
      "user_id" : userId,
    };

    try {
      await paymentRepository.googlePayment(data);
    }catch(e){
      log("google payment ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<void> addCard(
      {
        int? userId,
        String? paymentMethodId,
        String? brand,
      }
      ) async {

    Map<String, dynamic> data = {
      "user_id" : userId,
      "payment_method_id" : paymentMethodId,
      "brand" : brand,
    };

    try {
      await paymentRepository.addNewCard(data);
      await getAllCards(userId: userId);
    }catch(e){
      log("add card ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<void> getAllCards(
      {int? userId}
      ) async {

    Map<String, dynamic> data = {
      "user_id" : userId,
    };

    try {
      final response = await paymentRepository.getAllCard(data);
      setPaymentCardsList(ApiResponse.completed(response.data ?? []));
    }catch(e){
      setPaymentCardsList(ApiResponse.error(e.toString()));
    }
  }


  Future<void> getCardDetail(
      {
        int? userId,
        int? id,
      }
      ) async {

    Map<String, dynamic> data = {
      "user_id" : userId,
      "id" : id
    };

    try {
      setSelectedPaymentCard(ApiResponse.loading());
      setPaymentLoading(true);
      final response = await paymentRepository.getCardDetail(data);
      setSelectedPaymentCard(ApiResponse.completed(response.data));
      setPaymentLoading(false);
    }catch(e){
      setSelectedPaymentCard(ApiResponse.error(e.toString()));
      setPaymentLoading(false);
      throw AppException(e.toString());
    }

  }

  Future<PaymentCard?> getCardDetailSellFaster(
      {
        int? userId,
        int? id,
      }
      ) async {

    Map<String, dynamic> data = {
      "user_id" : userId,
      "id" : id
    };

    try {
      final response = await paymentRepository.getCardDetail(data);
      return response.data;
    }catch(e){
      throw AppException(e.toString());
    }

  }












}