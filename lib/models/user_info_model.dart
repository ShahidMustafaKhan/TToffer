class UserInfoModel {
  bool? success;
  Data? data;
  String? message;

  UserInfoModel({this.success, this.data, this.message});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      success = json['success'];
      data = json['data'] != null ? Data.fromJson(json['data']) : null;
      message = json['message'];
    } catch (e) {
      print("Error parsing UserInfoModel: $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
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
  String? emailCode;
  String? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  int? showContact;
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
  List<ProductsDataInfo>? products;
  List<ReviewsDataInfo>? reviews;

  Data({
    this.id,
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
    this.showContact,
    this.shareAbleLink,
    this.img,
    this.status,
    this.location,
    this.customLink,
    this.isTrueYou,
    this.createdAt,
    this.updatedAt,
    this.totalReview,
    this.reviewPercentage,
    this.products,
    this.reviews,
  });

  Data.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      src = json['src'];
      provider = json['provider'];
      providerId = json['provider_id'];
      providerToken = json['provider_token'];
      code = json['code'];
      emailVerifiedAt = json['email_verified_at'];
      phoneVerifiedAt = json['phone_verified_at'];
      imageVerifiedAt = json['image_verified_at'];
      username = json['username'];
      email = json['email'];
      phone = json['phone'];
      showContact = json['show_contact'];
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

      if (json['products'] != null) {
        products = (json['products'] as List)
            .map((v) => ProductsDataInfo.fromJson(v))
            .toList();
      }
      if (json['reviews'] != null) {
        reviews = (json['reviews'] as List)
            .map((v) => ReviewsDataInfo.fromJson(v))
            .toList();
      }
    } catch (e) {
      print("Error parsing Data: $e");
    }
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
    data['show_contact'] = showContact;
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

    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ProductsDataInfo {
  int? id;
  int? userId;
  String? title;
  String? slug;
  String? description;
  String? attributes;
  int? categoryId;
  int? subCategoryId;
  String? condition;
  String? makeAndModel;
  String? mileage;
  String? color;
  String? brand;
  String? model;
  String? edition;
  String? authenticity;
  String? fixPrice;
  String? firmOnPrice;
  String? auctionPrice;
  String? startingDate;
  String? startingTime;
  String? endingDate;
  String? endingTime;
  String? sellToUs;
  String? location;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isUrgent;
  int? totalReview;
  int? reviewPercentage;
  int? isArchived;
  int? isSold;
  String? soldToUserId;
  String? viewsCount;
  String? boosterStartDatetime;
  String? boosterEndDatetime;
  User? user;
  List<Photo>? photo;

  ProductsDataInfo(
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
        this.photo,
      });

  ProductsDataInfo.fromJson(Map<String, dynamic> json) {
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
    // sellToUs = json['sell_to_us'];
    // location = json['location'];
    // status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // isUrgent = json['is_urgent'];
    // totalReview = json['total_review'];
    // reviewPercentage = json['review_percentage'];
    // isArchived = json['is_archived'];
    // isSold = json['is_sold'];
    // soldToUserId = json['sold_to_user_id'];
    // viewsCount = json['views_count'];
    // boosterStartDatetime = json['booster_start_datetime'];
    // boosterEndDatetime = json['booster_end_datetime'];
    // user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(new Photo.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.photo != null) {
      data['photo'] = this.photo!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ReviewsDataInfo {
  int? id;
  int? toUser;
  int? fromUser;
  String? productId;
  String? comments;
  String? rating;
  String? createdAt;
  String? updatedAt;
  User? fromUesr;
  Product? product;

  ReviewsDataInfo(
      {this.id,
        this.toUser,
        this.fromUser,
        this.productId,
        this.comments,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.fromUesr,
        this.product});

  ReviewsDataInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUser = json['to_user'];
    fromUser = json['from_user'];
    productId = json['product_id'];
    comments = json['comments'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fromUesr = json['from_uesr'] != null
        ? new User.fromJson(json['from_uesr'])
        : null;
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['to_user'] = this.toUser;
    data['from_user'] = this.fromUser;
    data['product_id'] = this.productId;
    data['comments'] = this.comments;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.fromUesr != null) {
      data['from_uesr'] = this.fromUesr!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}


class Product {
  int? id;
  int? userId;
  String? title;
  String? slug;
  String? description;
  String? productType;
  bool? isProductExpired;
  ImagePath? imagePath;

  Product(
      {this.id,
        this.userId,
        this.title,
        this.slug,
        this.description,
        this.productType,
        this.isProductExpired,
        this.imagePath});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    productType = json['ProductType'];
    isProductExpired = json['IsProductExpired'];
    imagePath = json['image_path'] != null
        ? new ImagePath.fromJson(json['image_path'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['ProductType'] = this.productType;
    data['IsProductExpired'] = this.isProductExpired;
    if (this.imagePath != null) {
      data['image_path'] = this.imagePath!.toJson();
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

// class ReviewsDataInfo {
//   int? id;
//   String? toUser;
//   String? fromUser;
//   String? comments;
//   String? rating;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//
//
//   ReviewsDataInfo(
//       {
//         this.id,
//         this.toUser,
//         this.fromUser,
//         this.comments,
//         this.rating,
//         this.user,
//         this.createdAt,
//         this.updatedAt,
//       });
//
//   ReviewsDataInfo.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     toUser = json['to_user'];
//     fromUser = json['from_user'];
//     comments = json['comments'];
//     rating = json['rating'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['to_user'] = toUser;
//     data['from_user'] = fromUser;
//     data['comments'] = comments;
//     data['rating'] = rating;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     return data;
//   }
// }

class User {
  int? id;
  String? name;
  String? src;
  String? provider;
  String? code;
  String? emailVerifiedAt;
  int? emailCode;
  String? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  int? showContact;
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

  User(
      {this.id,
        this.name,
        this.src,
        this.provider,
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
        this.createdAt,
        this.updatedAt,
        this.totalReview,
        this.reviewPercentage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    src = json['src'];
    provider = json['provider'];
    code = json['code'];
    emailVerifiedAt = json['email_verified_at'];
    emailCode = json['email_code'];
    phoneVerifiedAt = json['phone_verified_at'];
    imageVerifiedAt = json['image_verified_at'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    showContact = json['show_contact'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['src'] = this.src;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class SubCategory {
  int? id;
  int? categoryId;
  String? name;
  String? createdAt;
  String? updatedAt;

  SubCategory(
      {this.id, this.categoryId, this.name, this.createdAt, this.updatedAt});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
