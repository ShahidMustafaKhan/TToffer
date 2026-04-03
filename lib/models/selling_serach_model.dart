class SellingSearchModel {
  bool? success;
  List<SearchData>? data;
  String? message;

  SellingSearchModel({this.success, this.data, this.message});

  SellingSearchModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class SearchData {
  int? id;
  int? userId;
  String? title;
  String? slug;
  String? description;
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
  int? fixPrice;
  int? firmOnPrice;
  int? auctionPrice;
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
  int? soldToUserId;
  int? viewsCount;
  String? boosterStartDatetime;
  String? boosterEndDatetime;
  User? user;
  Category? category;
  SubCategory? subCategory;
  List<Photo>? photo;
  List<void>? video;
  List<void>? wishlist;

  SearchData(
      {this.id,
        this.userId,
        this.title,
        this.slug,
        this.description,
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

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
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
    viewsCount = json['views_count'];
    boosterStartDatetime = json['booster_start_datetime'];
    boosterEndDatetime = json['booster_end_datetime'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? SubCategory.fromJson(json['sub_category'])
        : null;
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
    // if (json['wishlist'] != null) {
    //   wishlist = <Null>[];
    //   json['wishlist'].forEach((v) {
    //     wishlist!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['condition'] = condition;
    data['make_and_model'] = makeAndModel;
    data['mileage'] = mileage;
    data['color'] = color;
    data['brand'] = brand;
    data['model'] = model;
    data['edition'] = edition;
    data['authenticity'] = authenticity;
    data['fix_price'] = fixPrice;
    data['firm_on_price'] = firmOnPrice;
    data['auction_price'] = auctionPrice;
    data['starting_date'] = startingDate;
    data['starting_time'] = startingTime;
    data['ending_date'] = endingDate;
    data['ending_time'] = endingTime;
    data['sell_to_us'] = sellToUs;
    data['location'] = location;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_urgent'] = isUrgent;
    data['total_review'] = totalReview;
    data['review_percentage'] = reviewPercentage;
    data['is_archived'] = isArchived;
    data['is_sold'] = isSold;
    data['sold_to_user_id'] = soldToUserId;
    data['views_count'] = viewsCount;
    data['booster_start_datetime'] = boosterStartDatetime;
    data['booster_end_datetime'] = boosterEndDatetime;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (subCategory != null) {
      data['sub_category'] = subCategory!.toJson();
    }
    if (photo != null) {
      data['photo'] = photo!.map((v) => v.toJson()).toList();
    }
    // if (this.video != null) {
    //   data['video'] = this.video!.map((v) => v.toJson()).toList();
    // }
    // if (this.wishlist != null) {
    //   data['wishlist'] = this.wishlist!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? src;
  String? provider;
  int? providerId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['color'] = color;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['src'] = src;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
