import 'package:tt_offer/models/user_model.dart';

class BidsModel {
  bool? success;
  List<BidsData>? data;
  String? message;

  BidsModel({this.success, this.data, this.message});

  BidsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <BidsData>[];
      json['data'].forEach((v) {
        data!.add(BidsData.fromJson(v));
      });
    }
    message = json['message'];
  }


}

class BidsData {
  int? id;
  int? userId;
  int? productId;
  int? price;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  BidsData(
      {this.id,
        this.userId,
        this.productId,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.user});

  BidsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

}

class User {
  int? id;
  String? name;
  String? src;
  String? provider;
  String? providerId;
  String? providerToken;
  String? code;
  String? emailVerifiedAt;
  String? emailCode;
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
        this.emailCode,
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
    img = json['img'];
    json['review_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['src'] = this.src;
    data['provider'] = this.provider;
    data['provider_id'] = this.providerId;
    data['provider_token'] = this.providerToken;
    data['code'] = this.code;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['email_code'] = this.emailCode;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['image_verified_at'] = this.imageVerifiedAt;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['share_able_link'] = this.shareAbleLink;
    data['img'] = this.img;
    data['status'] = this.status;
    data['location'] = this.location;
    data['custom_link'] = this.customLink;
    data['is_true_you'] = this.isTrueYou;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_review'] = this.totalReview;
    data['review_percentage'] = this.reviewPercentage;
    return data;
  }
}
