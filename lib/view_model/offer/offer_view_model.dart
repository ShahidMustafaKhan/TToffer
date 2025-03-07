import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/models/bids_model.dart';

import '../../data/response/api_response.dart';
import '../../repository/offer_api/offer_repository.dart';


class OfferViewModel with ChangeNotifier {

  OfferRepository offerRepository ;
  OfferViewModel({required this.offerRepository});

  bool _offerLoading = false ;
  bool get offerLoading => _offerLoading ;

  bool _acceptOfferLoading = false ;
  bool get acceptOfferLoading => _acceptOfferLoading ;

  bool _rejectOfferLoading = false ;
  bool get rejectOfferLoading => _rejectOfferLoading ;

  bool _customOfferLoading = false ;
  bool get customOfferLoading => _customOfferLoading ;


  ApiResponse<BidsModel> bidsList = ApiResponse.notStarted();

  setBidList(ApiResponse<BidsModel> response){
    bidsList = response ;
    notifyListeners();
  }

  setOfferLoading(bool value){
    _offerLoading = value;
    notifyListeners();
  }

  setAcceptOfferLoading(bool value){
    _acceptOfferLoading = value;
    notifyListeners();
  }

  setRejectOfferLoading(bool value){
    _rejectOfferLoading = value;
    notifyListeners();
  }

  setCustomOfferLoading(bool value){
    _customOfferLoading = value;
    notifyListeners();
  }


  Future<void> makeOffer(int? productId, int? sellerId, int? buyerId, int? offerPrice) async {

    Map<String, dynamic> data = {
      "product_id": productId,
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "offer_price": offerPrice,
    };

    try {
      setOfferLoading(true);
      await offerRepository.makeOfferApi(data);
      setOfferLoading(false);
    }catch(e){
      setOfferLoading(false);
      log("make offer api ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<void> acceptOffer(int? productId, int? sellerId, int? buyerId, int? offerId) async {

    Map<String, dynamic> data = {
      "product_id": productId,
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "offer_id": offerId,
    };

    try {
      setAcceptOfferLoading(true);
      await offerRepository.acceptOfferApi(data);
      setAcceptOfferLoading(false);
    }catch(e){
      setAcceptOfferLoading(false);
      log("accept offer api  ${e.toString()}");
      throw AppException(e.toString());
    }

  }


  Future<void> rejectOffer(int? productId, int? sellerId, int? buyerId, int? offerId) async {

    Map<String, dynamic> data = {
      "product_id": productId,
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "offer_id": offerId,
    };

    try {
      setRejectOfferLoading(true);
      await offerRepository.rejectOfferApi(data);
      setRejectOfferLoading(false);
    }catch(e){
      setRejectOfferLoading(false);
      log("reject offer api  ${e.toString()}");
      throw AppException(e.toString());

    }

  }


  Future<void> customOffer(int? productId, int? sellerId, int? buyerId, int? offerId, int? customPrice) async {

    Map<String, dynamic> data = {
      "product_id": productId,
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "offer_id": offerId,
      "custom_price": customPrice,
    };

    try {
      setCustomOfferLoading(true);
      await offerRepository.customOfferApi(data);
      setCustomOfferLoading(false);
    }catch(e){
      setCustomOfferLoading(false);
      log("custom offer api  ${e.toString()}");
      throw AppException(e.toString());

    }

  }






}