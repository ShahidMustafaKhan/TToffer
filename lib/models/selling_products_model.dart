

import 'package:tt_offer/models/product_model.dart';

class SellingProductsModel {
  bool? status;
  SellingModel? data;
  String? message;

  SellingProductsModel({this.status, this.data, this.message});

  SellingProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SellingModel.fromJson(json['data']) : null;
    message = json['message'];
  }

}

class SellingModel {
  Selling? selling;
  Selling? buying;
  Selling? history;

  SellingModel({this.selling, this.buying, this.history});

  SellingModel.fromJson(Map<String, dynamic> json) {
    selling =
    json['selling'] != null ? Selling.fromJson(json['selling']) : null;
    buying =
    json['buying'] != null ? Selling.fromJson(json['buying']) : null;
    history =
    json['history'] != null ? Selling.fromJson(json['history']) : null;
  }

}

class Selling {
  List<Product>? data;

  Selling(
      {this.data,});

  Selling.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(Product.fromJson(v));
      });
    }
  }
}






