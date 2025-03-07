import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/repository/bids_api/bids_repository.dart';

import '../../data/app_exceptions.dart';
import '../../data/response/api_response.dart';



class BidsViewModel with ChangeNotifier{

  BidsRepository bidsRepository ;
  BidsViewModel({required this.bidsRepository});

  bool _bidsLoading = false ;
  bool get bidsLoading => _bidsLoading ;


  ApiResponse<BidsModel> bidsList = ApiResponse.notStarted();

  setBidList(ApiResponse<BidsModel> response){
    bidsList = response ;
    notifyListeners();
  }

  setBidLoading(bool value){
    _bidsLoading = value;
    notifyListeners();
  }


  Future<void> getBids(int? productId) async {

    Map<String, dynamic> data = {'product_id': productId};

    try {
      setBidList(ApiResponse.loading());
      final response = await bidsRepository.getBidsApi(data);
      setBidList(ApiResponse.completed(response));
    }catch(e){
      setBidList(ApiResponse.error(e.toString()));
      log("get bid api ${e.toString()}");
    }

  }


  Future<void> placeBid(dynamic data) async {

    try {
      setBidLoading(true);
     await bidsRepository.placeBidsApi(data);
      setBidLoading(false);
    }catch(e){
      setBidLoading(false);
      throw AppException(e);
    }

  }


  Future<BidsData> getHighestBids(int productId) async {

    Map<String, dynamic> data = {'product_id': productId};

    try {
      final response = await bidsRepository.getHighestBidsApi(data);
      return response;
    }catch(e){
      throw AppException(e.toString());
    }

  }



}