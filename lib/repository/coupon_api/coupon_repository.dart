import 'package:tt_offer/config/app_urls.dart';

import '../../../data/network/network_api_services.dart';
import '../../models/coupon_model.dart';



class CouponRepository {

  final _apiServices = NetworkApiService() ;

  Future<CouponModel> verifyCoupon(dynamic data)async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.verifyCoupon, data);
    return CouponModel.fromJson(response) ;
  }

}