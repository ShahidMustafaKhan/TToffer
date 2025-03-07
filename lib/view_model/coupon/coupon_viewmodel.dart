import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/coupon_model.dart';
import 'package:tt_offer/repository/coupon_api/coupon_repository.dart';
import '../../../data/app_exceptions.dart';
import '../../../data/response/api_response.dart';

class CouponViewModel with ChangeNotifier {

  CouponRepository couponRepository ;
  CouponViewModel({required this.couponRepository});


  ApiResponse<Coupon> coupon = ApiResponse.notStarted();

  setCoupon(ApiResponse<Coupon> response){
    coupon = response ;
    notifyListeners();
  }


  Future<void> verifyCoupon(String? code) async {

    dynamic data = {
      "code" : code
    };

    setCoupon(ApiResponse.loading());
    try {
      final response = await couponRepository.verifyCoupon(data);
      setCoupon(ApiResponse.completed(response.data));

    } catch(e){
      setCoupon(ApiResponse.error(e.toString()));
      throw AppException(e.toString());
    }
  }







}