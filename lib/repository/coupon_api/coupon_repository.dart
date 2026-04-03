import '../../models/coupon_model.dart';

abstract class CouponRepository {
  Future<CouponModel> verifyCoupon(dynamic data);
}
