import 'package:tt_offer/models/product_model.dart';

class ProductDetailModel {
  int? code;
  bool? status;
  String? message;
  Product? product;

  ProductDetailModel({this.code, this.status, this.message, this.product});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    product = json['data'] != null ? Product.fromJson(json['data']) : null;
  }


}