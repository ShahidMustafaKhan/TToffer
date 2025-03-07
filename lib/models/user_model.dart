
import 'package:tt_offer/models/product_model.dart';

class ProfileModel {
  int? code;
  bool? status;
  String? message;
  UserModel? userModel;

  ProfileModel({this.code, this.status, this.message, this.userModel});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    userModel = json['data'] != null ? UserModel.fromJson(json['data']) : null;
  }

}



class UserModel {
  int? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? userType;
  String? role;
  int? socialLogin;
  String? provider;
  String? providerId;
  String? providerToken;
  String? code;
  String? emailVerifiedAt;
  int? emailCode;
  String? phoneVerifiedAt;
  String? imageVerifiedAt;
  int? showContact;
  String? shareAbleLink;
  String? img;
  String? src;
  String? location;
  String? customLink;
  int? status;
  int? followersCount;
  int? followingCount;
  int? sold;
  int? bought;
  int? mySold;
  int? myBought;
  String? isTrueYou;
  String? deviceToken;
  int? totalReview;
  double? reviewPercentage;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  bool? isUserFollowed;
  List<Product>? products;
  List<Reviews>? reviews;

  UserModel(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.phone,
        this.userType,
        this.role,
        this.socialLogin,
        this.followersCount,
        this.followingCount,
        this.bought,
        this.sold,
        this.mySold,
        this.myBought,
        this.provider,
        this.providerId,
        this.providerToken,
        this.code,
        this.emailVerifiedAt,
        this.emailCode,
        this.phoneVerifiedAt,
        this.imageVerifiedAt,
        this.showContact,
        this.shareAbleLink,
        this.img,
        this.src,
        this.location,
        this.customLink,
        this.status,
        this.isTrueYou,
        this.deviceToken,
        this.totalReview,
        this.reviewPercentage,
        this.isUserFollowed,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    userType = json['user_type'];
    role = json['role'];
    if(json['social_login'] is bool){
      if(json['social_login'] == true){
        socialLogin = 1;
      }
      else{
        socialLogin = 0;
      }
    }
    else{
      socialLogin = json['social_login'];
    }
    provider = json['provider'];
    providerId = json['provider_id'];
    providerToken = json['provider_token'];
    code = json['code'];
    emailVerifiedAt = json['email_verified_at'];
    emailCode = json['email_code'];
    phoneVerifiedAt = json['phone_verified_at'];
    imageVerifiedAt = json['image_verified_at'];
    showContact = json['show_contact'];
    shareAbleLink = json['share_able_link'];
    img = json['img'];
    src = json['src'];
    location = json['location'];
    customLink = json['custom_link'];
    status = json['status'];
    // isTrueYou = json['is_true_you'];
    deviceToken = json['device_token'];
    totalReview = json['total_review'];

    followersCount = json['followers_count'];
    followingCount = json['following_count'];


    sold = json['sold_product'];
    bought = json['bought_product'];
    mySold = json['sold'];
    myBought = json['bought'];

    isUserFollowed = json['is_followed'];

    dynamic tempReviewPercentage = json['review_percentage'];
    if(tempReviewPercentage!= null) {
      reviewPercentage = tempReviewPercentage.toDouble();
    }
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['products'] != null) {
      products = (json['products'] as List)
          .map((v) => Product.fromJson(v))
          .toList();
    }
    if (json['seller_reviews'] != null) {
      reviews = (json['seller_reviews'] as List)
          .map((v) => Reviews.fromJson(v))
          .toList();
    }

  }
}


class Reviews {
  int? id;
  int? rating;
  String? comment;
  Product? product;
  UserModel? user;

  Reviews({this.id, this.rating, this.comment, this.product, this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'] is String ? int.tryParse(json['rating']) : json['rating'];
    comment = json['comment'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    user = json['reviewer'] != null ? UserModel.fromJson(json['reviewer']) : null;
  }

}