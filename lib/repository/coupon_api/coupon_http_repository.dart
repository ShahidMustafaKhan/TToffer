import 'package:tt_offer/config/app_urls.dart';

import '../../../data/network/network_api_services.dart';
import '../../models/coupon_model.dart';
import 'coupon_repository.dart';

class CouponHttpRepository implements CouponRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<CouponModel> verifyCoupon(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.verifyCoupon, data);
    return CouponModel.fromJson(response);
  }
}
