class CouponModel {
  int? code;
  String? message;
  Coupon? data;

  CouponModel({this.code, this.message, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Coupon.fromJson(json['data']) : null;
  }

}

class Coupon {
  String? type;
  double? value;
  String? discountType;

  Coupon({this.type, this.value, this.discountType});

  Coupon.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    dynamic temp = json['value'] ?? json['balance'];
    value = temp.toDouble();
    discountType = json['discount_type'];
  }

}