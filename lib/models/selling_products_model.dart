import 'dart:convert';

class SellingProductsModel {
  bool? success;
  Data? data;
  String? message;

  SellingProductsModel({this.success, this.data, this.message});

  SellingProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Selling>? selling;
  List<dynamic>? purchase;
  List<dynamic>? archive;

  Data({this.selling, this.purchase, this.archive});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['selling'] != null) {
      selling = <Selling>[];
      json['selling'].forEach((v) {
        selling!.add(Selling.fromJson(v));
      });
    }
    if (json['purchase'] != null) {
      purchase = <dynamic>[];
      json['purchase'].forEach((v) {
        purchase!.add(v);
      });
    }
    if (json['archive'] != null) {
      archive = <dynamic>[];
      json['archive'].forEach((v) {
        archive!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.selling != null) {
      data['selling'] = this.selling!.map((v) => v.toJson()).toList();
    }
    if (this.purchase != null) {
      data['purchase'] = this.purchase!.map((v) => v.toJson()).toList();
    }
    if (this.archive != null) {
      data['archive'] = this.archive!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Selling {
  int? id;
  int? userId;
  String? title;
  String? slug;
  String? description;
  String? attributes;
  int? categoryId;
  Null? subCategoryId;
  String? condition;
  Null? makeAndModel;
  Null? mileage;
  Null? color;
  Null? brand;
  Null? model;
  Null? edition;
  Null? authenticity;
  int? fixPrice;
  int? firmOnPrice;
  int? auctionPrice;
  String? startingDate;
  String? startingTime;
  String? endingDate;
  String? endingTime;
  Null? sellToUs;
  String? location;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isUrgent;
  int? totalReview;
  int? reviewPercentage;
  int? isArchived;
  int? isSold;
  Null? soldToUserId;
  String? viewsCount;
  String? boosterStartDatetime;
  String? boosterEndDatetime;
  User? user;
  Category? category;
  Null? subCategory;
  List<Photo>? photo;
  List<Null>? video;
  List<Wishlist>? wishlist;

  Selling(
      {this.id,
      this.userId,
      this.title,
      this.slug,
      this.description,
      this.attributes,
      this.categoryId,
      this.subCategoryId,
      this.condition,
      this.makeAndModel,
      this.mileage,
      this.color,
      this.brand,
      this.model,
      this.edition,
      this.authenticity,
      this.fixPrice,
      this.firmOnPrice,
      this.auctionPrice,
      this.startingDate,
      this.startingTime,
      this.endingDate,
      this.endingTime,
      this.sellToUs,
      this.location,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.isUrgent,
      this.totalReview,
      this.reviewPercentage,
      this.isArchived,
      this.isSold,
      this.soldToUserId,
      this.viewsCount,
      this.boosterStartDatetime,
      this.boosterEndDatetime,
      this.user,
      this.category,
      this.subCategory,
      this.photo,
      this.video,
      this.wishlist});

  Selling.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    attributes = json['attributes'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    condition = json['condition'];
    makeAndModel = json['make_and_model'];
    mileage = json['mileage'];
    color = json['color'];
    brand = json['brand'];
    model = json['model'];
    edition = json['edition'];
    authenticity = json['authenticity'];
    fixPrice = json['fix_price'];
    firmOnPrice = json['firm_on_price'];
    auctionPrice = json['auction_price'];
    startingDate = json['starting_date'];
    startingTime = json['starting_time'];
    endingDate = json['ending_date'];
    endingTime = json['ending_time'];
    sellToUs = json['sell_to_us'];
    location = json['location'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isUrgent = json['is_urgent'];
    totalReview = json['total_review'];
    reviewPercentage = json['review_percentage'];
    isArchived = json['is_archived'];
    isSold = json['is_sold'];
    soldToUserId = json['sold_to_user_id'];
    viewsCount = json['views_count'] ?? '0';
    boosterStartDatetime = json['booster_start_datetime'];
    boosterEndDatetime = json['booster_end_datetime'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    subCategory = json['sub_category'];
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    }
    // if (json['video'] != null) {
    //   video = <Null>[];
    //   json['video'].forEach((v) {
    //     video!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['wishlist'] != null) {
      wishlist = <Wishlist>[];
      json['wishlist'].forEach((v) {
        wishlist!.add(Wishlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['attributes'] = this.attributes;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['condition'] = this.condition;
    data['make_and_model'] = this.makeAndModel;
    data['mileage'] = this.mileage;
    data['color'] = this.color;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['edition'] = this.edition;
    data['authenticity'] = this.authenticity;
    data['fix_price'] = this.fixPrice;
    data['firm_on_price'] = this.firmOnPrice;
    data['auction_price'] = this.auctionPrice;
    data['starting_date'] = this.startingDate;
    data['starting_time'] = this.startingTime;
    data['ending_date'] = this.endingDate;
    data['ending_time'] = this.endingTime;
    data['sell_to_us'] = this.sellToUs;
    data['location'] = this.location;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_urgent'] = this.isUrgent;
    data['total_review'] = this.totalReview;
    data['review_percentage'] = this.reviewPercentage;
    data['is_archived'] = this.isArchived;
    data['is_sold'] = this.isSold;
    data['sold_to_user_id'] = this.soldToUserId;
    data['views_count'] = this.viewsCount;
    data['booster_start_datetime'] = this.boosterStartDatetime;
    data['booster_end_datetime'] = this.boosterEndDatetime;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['sub_category'] = this.subCategory;
    if (this.photo != null) {
      data['photo'] = this.photo!.map((v) => v.toJson()).toList();
    }
    // if (this.video != null) {
    //   data['video'] = this.video!.map((v) => v.toJson()).toList();
    // }
    if (this.wishlist != null) {
      data['wishlist'] = this.wishlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? src;
  String? provider;
  Null? providerId;
  Null? providerToken;
  Null? code;
  Null? emailVerifiedAt;
  Null? emailCode;
  Null? phoneVerifiedAt;
  Null? imageVerifiedAt;
  String? username;
  String? email;
  Null? phone;
  Null? shareAbleLink;
  Null? img;
  int? status;
  Null? location;
  Null? customLink;
  int? isTrueYou;
  String? createdAt;
  String? updatedAt;
  int? totalReview;
  int? reviewPercentage;

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

class Category {
  int? id;
  String? name;
  String? slug;
  String? color;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
      this.name,
      this.slug,
      this.color,
      this.image,
      this.status,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    color = json['color'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['color'] = this.color;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Photo {
  int? id;
  int? productId;
  String? src;
  String? createdAt;
  String? updatedAt;

  Photo({this.id, this.productId, this.src, this.createdAt, this.updatedAt});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    src = json['src'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['src'] = this.src;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Wishlist {
  int? id;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;

  Wishlist(
      {this.id, this.userId, this.productId, this.createdAt, this.updatedAt});

  Wishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
