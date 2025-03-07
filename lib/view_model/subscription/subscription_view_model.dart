import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/models/subscription_model.dart';
import 'package:tt_offer/repository/payment_api/payment_repository.dart';

import '../../data/response/api_response.dart';



class SubscriptionViewModel with ChangeNotifier {

  PaymentRepository paymentRepository ;
  SubscriptionViewModel({required this.paymentRepository});

  ApiResponse<List<Subscription>> subscriptionsList = ApiResponse.loading();

  setSubscriptionsList(ApiResponse<List<Subscription>> response){
    subscriptionsList = response ;
    notifyListeners();
  }


  Future<void> getAllSubscriptionsPlan() async {
    try {
      final response = await paymentRepository.getAllSubscription();
      setSubscriptionsList(ApiResponse.completed(response.data ?? []));
    }catch(e){
      setSubscriptionsList(ApiResponse.error(e.toString()));
      log("subscription api ${e.toString()}");
    }}







}