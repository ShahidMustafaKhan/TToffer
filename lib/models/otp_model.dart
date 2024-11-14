class OtpModel {
  dynamic status;
  String? msg;
  dynamic? otp;
  dynamic? data;

  OtpModel({this.status, this.msg, this.otp, this.data});

  OtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    otp = json['otp'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['otp'] = otp;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? src;
  String? provider;
  String? providerId;
  String? providerToken;
  String? code;
  String? emailVerifiedAt;
  int? emailCode;
  String? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  String? shareAbleLink;
  String? img;
  int? status;
  String? location;
  String? customLink;
  int? isTrueYou;
  String? createdAt;
  String? updatedAt;
  int? totalReview;
  int? reviewPercentage;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    src = json['src'];
    provider = json['provider'];
    providerId = json['provider_id'];
    providerToken = json['provider_token'];
    code = json['code'];
    emailVerifiedAt = json['email_verified_at'];
    emailCode = json['email_code'];
    phoneVerifiedAt = json['phone_verified_at'];
    imageVerifiedAt = json['image_verified_at'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    shareAbleLink = json['share_able_link'];
    img = json['img'];
    status = json['status'];
    location = json['location'];
    customLink = json['custom_link'];
    isTrueYou = json['is_true_you'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalReview = json['total_review'];
    reviewPercentage = json['review_percentage'];
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
