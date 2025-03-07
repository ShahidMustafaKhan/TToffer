import 'package:tt_offer/models/product_model.dart';
import 'package:tt_offer/models/user_model.dart';

class WishListModel {
  int? code;
  bool? status;
  String? message;
  List<WishList>? data;

  WishListModel({this.code, this.status, this.message, this.data});

  WishListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WishList>[];
      json['data'].forEach((v) {
        data!.add(WishList.fromJson(v));
      });
    }
  }

}

class WishList {
  int? id;
  int? userId;
  int? productId;
  String? createdAt;
  UserModel? user;
  Product? product;

  WishList({this.id, this.userId, this.productId, this.user, this.product});

  WishList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

}



