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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['src'] = src;
    data['provider'] = provider;
    data['provider_id'] = providerId;
    data['provider_token'] = providerToken;
    data['code'] = code;
    data['email_verified_at'] = emailVerifiedAt;
    data['email_code'] = emailCode;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['image_verified_at'] = imageVerifiedAt;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['share_able_link'] = shareAbleLink;
    data['img'] = img;
    data['status'] = status;
    data['location'] = location;
    data['custom_link'] = customLink;
    data['is_true_you'] = isTrueYou;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_review'] = totalReview;
    data['review_percentage'] = reviewPercentage;
    return data;
  }
}
