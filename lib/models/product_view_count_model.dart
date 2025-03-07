import 'package:tt_offer/models/user_model.dart';

class ProductViewCountModel {
  int? code;
  bool? status;
  String? message;
  ProductView? data;

  ProductViewCountModel({this.code, this.status, this.message, this.data});

  ProductViewCountModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProductView.fromJson(json['data']) : null;
  }

}

class ProductView {
  int? totalViews;
  List<UserModel>? viewers;

  ProductView({this.totalViews, this.viewers});

  ProductView.fromJson(Map<String, dynamic> json) {
    totalViews = json['total_views'];
    if (json['viewers'] != null) {
      viewers = <UserModel>[];
      json['viewers'].forEach((v) {
        viewers!.add(UserModel.fromJson(v));
      });
    }
  }

}
