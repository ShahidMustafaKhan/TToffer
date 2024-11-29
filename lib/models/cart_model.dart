import 'package:tt_offer/models/user_model.dart';

import '../../../models/product_model.dart';


class CartModel {
  int? code;
  bool? success;
  String? message;
  List<Data>? data;

  CartModel({this.code, this.success, this.message, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

}

class Data {
  int? id;
  int? userId;
  int? productId;
  int? qty;
  String? createdAt;
  String? updatedAt;
  Product? product;
  UserModel? user;

  Data(
      {this.id,
        this.userId,
        this.productId,
        this.qty,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    qty = json['qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

}





