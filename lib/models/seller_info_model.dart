class SellerInfoModel{
bool? success;
Data? data;
String? message;

SellerInfoModel({this.success, this.data, this.message});

SellerInfoModel.fromJson(Map<String, dynamic> json) {
success = json['success'];
data = json['data'] != null ? new Data.fromJson(json['data']) : null;
message = json['message'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['success'] = this.success;
if (this.data != null) {
data['data'] = this.data!.toJson();
}
data['message'] = this.message;
return data;
}
}

class Data {
  int? id;
  String? name;
  Null? userType;
  String? src;
  String? provider;
  Null? providerId;
  Null? providerToken;
  String? code;
  Null? emailVerifiedAt;
  Null? emailCode;
  Null? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  String? showContact;
  Null? shareAbleLink;
  Null? img;
  String? status;
  String? location;
  Null? customLink;
  String? isTrueYou;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  String? totalReview;
  String? reviewPercentage;
  List<Reviews>? reviews;
  List<Products>? products;

  Data(
      {this.id,
        this.name,
        this.userType,
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
        this.totalReview,
        this.reviewPercentage,
        this.reviews,
        this.products});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userType = json['user_type'];
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
    showContact = json['show_contact'];
    shareAbleLink = json['share_able_link'];
    img = json['img'];
    status = json['status'];
    location = json['location'];
    customLink = json['custom_link'];
    isTrueYou = json['is_true_you'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalReview = json['total_review'];
    reviewPercentage = json['review_percentage'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_type'] = this.userType;
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
    data['total_review'] = this.totalReview;
    data['review_percentage'] = this.reviewPercentage;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? id;
  String? toUser;
  String? fromUser;
  String? productId;
  String? comments;
  String? rating;
  String? createdAt;
  String? updatedAt;
  FromUesr? fromUesr;
  Product? product;

  Reviews(
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

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUser = json['to_user'];
    fromUser = json['from_user'];
    productId = json['product_id'];
    comments = json['comments'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fromUesr = json['from_uesr'] != null
        ? new FromUesr.fromJson(json['from_uesr'])
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

class FromUesr {
  int? id;
  String? name;

  FromUesr({this.id, this.name});

  FromUesr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Product {
  int? id;
  String? userId;
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
  String? productId;
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

class Products {
  int? id;
  String? userId;
  String? title;
  String? slug;
  String? description;
  String? attributes;
  String? categoryId;
  String? subCategoryId;
  String? condition;
  Null? makeAndModel;
  Null? mileage;
  Null? color;
  Null? brand;
  Null? model;
  Null? edition;
  Null? authenticity;
  String? fixPrice;
  String? firmOnPrice;
  String? auctionPrice;
  String? finalPrice;
  String? notify;
  String? startingDate;
  String? startingTime;
  String? endingDate;
  String? endingTime;
  Null? sellToUs;
  String? location;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? isUrgent;
  String? totalReview;
  String? reviewPercentage;
  String? isArchived;
  String? isSold;
  String? soldToUserId;
  Null? viewsCount;
  String? boosterStartDatetime;
  String? boosterEndDatetime;
  String? productType;
  bool? isProductExpired;
  User? user;
  Category? category;
  SubCategory? subCategory;
  List<ImagePath>? photo;
  List<Null>? wishlist;

  Products(
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
        this.finalPrice,
        this.notify,
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
        this.productType,
        this.isProductExpired,
        this.user,
        this.category,
        this.subCategory,
        this.photo,
        this.wishlist});

  Products.fromJson(Map<String, dynamic> json) {
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
    finalPrice = json['final_price'];
    notify = json['notify'];
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
    viewsCount = json['views_count'];
    boosterStartDatetime = json['booster_start_datetime'];
    boosterEndDatetime = json['booster_end_datetime'];
    productType = json['ProductType'];
    isProductExpired = json['IsProductExpired'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;
    if (json['photo'] != null) {
      photo = <ImagePath>[];
      json['photo'].forEach((v) {
        photo!.add(new ImagePath.fromJson(v));
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
    data['final_price'] = this.finalPrice;
    data['notify'] = this.notify;
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
    data['ProductType'] = this.productType;
    data['IsProductExpired'] = this.isProductExpired;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class User {
  int? id;
  String? name;
  Null? userType;
  String? src;
  String? provider;
  Null? providerId;
  Null? providerToken;
  String? code;
  Null? emailVerifiedAt;
  Null? emailCode;
  Null? phoneVerifiedAt;
  String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  String? showContact;
  Null? shareAbleLink;
  Null? img;
  String? status;
  String? location;
  Null? customLink;
  String? isTrueYou;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  String? totalReview;
  String? reviewPercentage;

  User(
      {this.id,
        this.name,
        this.userType,
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
        this.totalReview,
        this.reviewPercentage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userType = json['user_type'];
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
    showContact = json['show_contact'];
    shareAbleLink = json['share_able_link'];
    img = json['img'];
    status = json['status'];
    location = json['location'];
    customLink = json['custom_link'];
    isTrueYou = json['is_true_you'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalReview = json['total_review'];
    reviewPercentage = json['review_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_type'] = this.userType;
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
  String? status;
  String? imgSrc;
  Null? subTitle;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
        this.name,
        this.slug,
        this.color,
        this.image,
        this.status,
        this.imgSrc,
        this.subTitle,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    color = json['color'];
    image = json['image'];
    status = json['status'];
    imgSrc = json['ImgSrc'];
    subTitle = json['subTitle'];
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
    data['ImgSrc'] = this.imgSrc;
    data['subTitle'] = this.subTitle;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SubCategory {
  int? id;
  String? categoryId;
  String? name;
  Null? createdAt;
  Null? updatedAt;

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