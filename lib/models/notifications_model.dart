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
    if (this.product != null) {
      data['product'] = this.product!.toJson();
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

class Product {
  int? id;
  int? userId;
  String? title;
  String? slug;
  String? description;
  String? attributes;
  String? categoryId;
  String? subCategoryId;
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
  String? finalPrice;
  String? notify;
  String? startingDate;
  String? startingTime;
  String? endingDate;
  String? endingTime;
  String? sellToUs;
  String? location;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? isUrgent;
  String? totalReview;
  String? reviewPercentage;
  String? isArchived;
  String? isSold;
  String? soldToUserId;
  String? viewsCount;
  String? boosterStartDatetime;
  String? boosterEndDatetime;
  String? productType;
  bool? isProductExpired;
  ImagePath? imagePath;

  Product(
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
        this.deletedAt,
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
        this.imagePath});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    authenticity = json['authenticity'];
    fixPrice = json['fix_price'];
    firmOnPrice = json['firm_on_price'];
    auctionPrice = json['auction_price'];
    finalPrice = json['final_price'];
    productType = json['ProductType'];
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
    data['deleted_at'] = this.deletedAt;
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
