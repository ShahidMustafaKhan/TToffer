import '../../models/coupon_model.dart';
import 'coupon_repository.dart';

class CouponMockRepository implements CouponRepository {
  @override
  Future<CouponModel> verifyCoupon(dynamic data) async {
    await Future.delayed(const Duration(seconds: 2));
    if (data["code"] == 13579) {
      return CouponModel(
          data:
              Coupon(discountType: "percentage", value: 10000, type: "coupon"));
    } else {
      throw Exception("Invalid Coupon");
    }
  }
}
