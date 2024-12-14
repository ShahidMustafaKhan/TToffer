import 'package:tt_offer/models/product_model.dart';
import 'package:tt_offer/models/user_model.dart';

class NotificationModel {
  bool? success;
  List<NotificationData>? data;
  String? message;

  NotificationModel({this.success, this.data, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    message = json['message'];
  }

}

class NotificationData {
  int? id;
  int? userId;
  dynamic text;
  dynamic type;
  dynamic typeId;
  int? sellerId;
  int? fromUserId;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  UserModel? user;
  Product? product;


  NotificationData(
      {this.id,
        this.userId,
        this.sellerId,
        this.fromUserId,
        this.text,
        this.type,
        this.typeId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user,
        this.product,
      });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    fromUserId = json['from_user_id'];
    text = json['text'];
    type = json['type'];
    typeId = json['type_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

}



