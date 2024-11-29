import 'package:tt_offer/models/product_model.dart';

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class NotificationData {
  int? id;
  int? userId;
  dynamic text;
  dynamic type;
  dynamic typeId;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  User? user;
  Product? product;


  NotificationData(
      {this.id,
        this.userId,
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
    text = json['text'];
    type = json['type'];
    typeId = json['type_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['type'] = this.type;
    data['type_id'] = this.typeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }

    return data;
  }
}

class User {
  int? id;
  String? name;
  String? src;
  String? provider;
  int? providerId;
  int? providerToken;
  String? code;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  String? shareAbleLink;
  String? img;
  String? status;
  String? location;
  String? customLink;
  String? isTrueYou;
  String? createdAt;
  String? updatedAt;
  String? totalReview;
  String? reviewPercentage;

  User(
      {this.id,
        this.name,
        this.src,
        this.provider,
        this.providerId,
        this.providerToken,
        this.code,
        this.emailVerifiedAt,
        this.phoneVerifiedAt,
        this.imageVerifiedAt,
        this.username,
        this.email,
        this.phone,
        this.shareAbleLink,
        this.img,
        this.status,
        this.location,
        this.customLink,
        this.isTrueYou,
        this.createdAt,
        this.updatedAt,
        this.totalReview,
        this.reviewPercentage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    src = json['src'];

    img = json['img'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['src'] = this.src;

    data['img'] = this.img;

    data['location'] = this.location;

    return data;
  }
}


