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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
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
  User? user;

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
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? fixPrice;
  String? firmOnPrice;
  String? finalPrice;
  int? userId;
  String? productType;
  bool? isProductExpired;
  List<int>? reportedByUserId;
  ImagePath? imagePath;
  User? user;

  Product(
      {this.id,
        this.title,
        this.fixPrice,
        this.firmOnPrice,
        this.finalPrice,
        this.userId,
        this.productType,
        this.isProductExpired,
        this.reportedByUserId,
        this.imagePath,
        this.user});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    fixPrice = json['fix_price'];
    firmOnPrice = json['firm_on_price'];
    finalPrice = json['final_price'];
    userId = json['user_id'];
    productType = json['ProductType'];
    isProductExpired = json['IsProductExpired'];
    if (json['reportedByUserId'] != null) {
      reportedByUserId = <int>[];
      json['reportedByUserId'].forEach((v) {
        reportedByUserId!.add(int.parse(v.toString()));
      });
    }

    imagePath = json['image_path'] != null
        ? new ImagePath.fromJson(json['image_path'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['fix_price'] = this.fixPrice;
    data['firm_on_price'] = this.firmOnPrice;
    data['final_price'] = this.finalPrice;
    data['user_id'] = this.userId;
    data['ProductType'] = this.productType;
    data['IsProductExpired'] = this.isProductExpired;
    if (this.reportedByUserId != null) {
      data['reportedByUserId'] = this.reportedByUserId;
    }
    if (this.imagePath != null) {
      data['image_path'] = this.imagePath!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class ImagePath {
  int? id;
  int? productId;
  String? src;
  String? createdAt;
  String? updatedAt;

  ImagePath(
      {this.id, this.productId, this.src, this.createdAt, this.updatedAt});

  ImagePath.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    src = json['src'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['src'] = this.src;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}



class User {
  int? id;
  String? name;
  Null? role;
  Null? userType;
  int? socialLogin;
  String? src;
  String? provider;
  Null? providerId;
  Null? providerToken;
  String? code;
  String? emailVerifiedAt;
  Null? emailCode;
  Null? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  int? showContact;
  Null? shareAbleLink;
  String? img;
  int? status;
  String? location;
  Null? customLink;
  int? isTrueYou;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  int? totalReview;
  int? reviewPercentage;

  User(
      {this.id,
        this.name,
        this.role,
        this.userType,
        this.socialLogin,
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
        this.showContact,
        this.shareAbleLink,
        this.img,
        this.status,
        this.location,
        this.customLink,
        this.isTrueYou,
        this.deviceToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.totalReview,
        this.reviewPercentage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    location = json['location'];
    totalReview = json['total_review'];
    reviewPercentage = json['review_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['user_type'] = this.userType;
    data['social_login'] = this.socialLogin;
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
    data['show_contact'] = this.showContact;
    data['share_able_link'] = this.shareAbleLink;
    data['img'] = this.img;
    data['status'] = this.status;
    data['location'] = this.location;
    data['custom_link'] = this.customLink;
    data['is_true_you'] = this.isTrueYou;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['total_review'] = this.totalReview;
    data['review_percentage'] = this.reviewPercentage;
    return data;
  }
}