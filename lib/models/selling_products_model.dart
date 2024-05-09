import 'dart:convert';

class SellingProductsModel {
  bool success;
  Data? data;
  String message;

  SellingProductsModel({
    required this.success,
    this.data,
    required this.message,
  });

  factory SellingProductsModel.fromJson(Map<String, dynamic> json) =>
      SellingProductsModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  // Map<String, dynamic> toJson() => {
  //       "success": success,
  //       "data": data!.toJson(),
  //       "message": message,
  //     };
}

class Data {
  List<Selling>? selling;
  List<Selling>? purchase;
  List<Selling>? archive;

  Data({
    this.selling,
    this.purchase,
    this.archive,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        selling: json["selling"] == null
            ? []
            : List<Selling>.from(
                json["selling"].map((x) => Selling.fromJson(x))),
        purchase: json["purchase"] == null
            ? []
            : List<Selling>.from(
                json["purchase"].map((x) => Selling.fromJson(x))),
        archive: json["archive"] == null
            ? []
            : List<Selling>.from(
                json["archive"].map((x) => Selling.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "selling": List<dynamic>.from(selling!.map((x) => x.toJson())),
  //       "purchase": List<dynamic>.from(purchase!.map((x) => x)),
  //       "archive": List<dynamic>.from(archive!.map((x) => x)),
  //     };
}

class Selling {
  dynamic id;
  dynamic userId;
  String title;
  String? slug;
  String description;
  dynamic categoryId;
  dynamic subCategoryId;
  String? condition;
  dynamic makeAndModel;
  dynamic mileage;
  dynamic color;
  dynamic brand;
  dynamic model;
  dynamic edition;
  dynamic authenticity;
  dynamic fixPrice;
  dynamic firmOnPrice;
  dynamic auctionPrice;
  dynamic startingDate;
  dynamic startingTime;
  dynamic endingDate;
  dynamic endingTime;
  dynamic sellToUs;
  dynamic location;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic isUrgent;
  dynamic totalReview;
  dynamic reviewPercentage;
  dynamic isArchived;
  dynamic isSold;
  dynamic soldToUserId;
  User? user;
  Category? category;
  SubCategory? subCategory;
  List<Photo>? photo;
  List<dynamic>? video;
  List<dynamic>? wishlist;

  Selling({
    required this.id,
    required this.userId,
    required this.title,
    required this.slug,
    required this.description,
    required this.categoryId,
    required this.subCategoryId,
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
    this.user,
    this.category,
    this.subCategory,
    this.photo,
    this.video,
    this.wishlist,
  });

  factory Selling.fromJson(Map<String, dynamic> json) => Selling(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"] ?? '',
        slug: json["slug"] ?? '',
        description: json["description"] ?? '',
        categoryId: json["category_id"] ?? '',
        subCategoryId: json["sub_category_id"] ?? '',
        condition: json["condition"] ?? '',
        makeAndModel: json["make_and_model"],
        mileage: json["mileage"] ?? '',
        color: json["color"] ?? '',
        brand: json["brand"],
        model: json["model"],
        edition: json["edition"],
        authenticity: json["authenticity"],
        fixPrice: json["fix_price"],
        firmOnPrice: json["firm_on_price"] ?? '',
        auctionPrice: json["auction_price"] ?? '',
        startingDate: json["starting_date"] ?? '',
        startingTime: json["starting_time"] ?? '',
        endingDate: json["ending_date"] ?? '',
        endingTime: json["ending_time"] ?? '',
        sellToUs: json["sell_to_us"] ?? '',
        location: json["location"] ?? '',
        status: json["status"] ?? '',
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
        isUrgent: json["is_urgent"] ?? '',
        totalReview: json["total_review"] ?? '',
        reviewPercentage: json["review_percentage"] ?? '',
        isArchived: json["is_archived"] ?? '',
        isSold: json["is_sold"] ?? '',
        soldToUserId: json["sold_to_user_id"] ?? '',
        user: User.fromJson(json["user"]),
        category: Category.fromJson(json["category"]),
        subCategory: SubCategory.fromJson(json["sub_category"]),
        photo: List<Photo>.from(json["photo"].map((x) => Photo.fromJson(x))),
        video: List<dynamic>.from(json["video"].map((x) => x)),
        wishlist: List<dynamic>.from(json["wishlist"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "slug": slug,
        "description": description,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "condition": condition,
        "make_and_model": makeAndModel,
        "mileage": mileage,
        "color": color,
        "brand": brand,
        "model": model,
        "edition": edition,
        "authenticity": authenticity,
        "fix_price": fixPrice,
        "firm_on_price": firmOnPrice,
        "auction_price": auctionPrice,
        "starting_date": startingDate,
        "starting_time": startingTime,
        "ending_date": endingDate,
        "ending_time": endingTime,
        "sell_to_us": sellToUs,
        "location": location,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "is_urgent": isUrgent,
        "total_review": totalReview,
        "review_percentage": reviewPercentage,
        "is_archived": isArchived,
        "is_sold": isSold,
        "sold_to_user_id": soldToUserId,
        "user": user!.toJson(),
        "category": category!.toJson(),
        "sub_category": subCategory!.toJson(),
        "photo": List<dynamic>.from(photo!.map((x) => x.toJson())),
        "video": List<dynamic>.from(video!.map((x) => x)),
        "wishlist": List<dynamic>.from(wishlist!.map((x) => x)),
      };
}

class Category {
  int id;
  String name;
  String slug;
  String color;
  String image;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        color: json["color"],
        image: json["image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "color": color,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Photo {
  int id;
  int productId;
  String src;
  DateTime createdAt;
  DateTime updatedAt;

  Photo({
    required this.id,
    required this.productId,
    required this.src,
    required this.createdAt,
    required this.updatedAt,
  });

  // String toRawJson() => json.encode(toJson());

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        productId: json["product_id"],
        src: json["src"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "src": src,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class SubCategory {
  int id;
  int categoryId;
  String name;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  // SubCategory copyWith({
  //   int? id,
  //   int? categoryId,
  //   String? name,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  // }) =>
  //     SubCategory(
  //       id: id ?? this.id,
  //       categoryId: categoryId ?? this.categoryId,
  //       name: name ?? this.name,
  //       createdAt: createdAt ?? this.createdAt,
  //       updatedAt: updatedAt ?? this.updatedAt,
  //     );
  //
  // factory SubCategory.fromRawJson(String str) =>
  //     SubCategory.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class User {
  int id;
  String name;
  String src;
  String provider;
  dynamic providerId;
  dynamic providerToken;
  String code;
  dynamic emailVerifiedAt;
  dynamic phoneVerifiedAt;
  dynamic imageVerifiedAt;
  String username;
  String email;
  dynamic phone;
  dynamic shareAbleLink;
  String img;
  int status;
  dynamic location;
  dynamic customLink;
  int isTrueYou;
  DateTime createdAt;
  DateTime updatedAt;
  int totalReview;
  int reviewPercentage;

  User({
    required this.id,
    required this.name,
    required this.src,
    required this.provider,
    required this.providerId,
    required this.providerToken,
    required this.code,
    required this.emailVerifiedAt,
    required this.phoneVerifiedAt,
    required this.imageVerifiedAt,
    required this.username,
    required this.email,
    required this.phone,
    required this.shareAbleLink,
    required this.img,
    required this.status,
    required this.location,
    required this.customLink,
    required this.isTrueYou,
    required this.createdAt,
    required this.updatedAt,
    required this.totalReview,
    required this.reviewPercentage,
  });

  // User copyWith({
  //   int? id,
  //   String? name,
  //   String? src,
  //   String? provider,
  //   dynamic providerId,
  //   dynamic providerToken,
  //   String? code,
  //   dynamic emailVerifiedAt,
  //   dynamic phoneVerifiedAt,
  //   dynamic imageVerifiedAt,
  //   String? username,
  //   String? email,
  //   dynamic phone,
  //   dynamic shareAbleLink,
  //   String? img,
  //   int? status,
  //   dynamic location,
  //   dynamic customLink,
  //   int? isTrueYou,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  //   int? totalReview,
  //   int? reviewPercentage,
  // }) =>
  //     User(
  //       id: id ?? this.id,
  //       name: name ?? this.name,
  //       src: src ?? this.src,
  //       provider: provider ?? this.provider,
  //       providerId: providerId ?? this.providerId,
  //       providerToken: providerToken ?? this.providerToken,
  //       code: code ?? this.code,
  //       emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
  //       phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
  //       imageVerifiedAt: imageVerifiedAt ?? this.imageVerifiedAt,
  //       username: username ?? this.username,
  //       email: email ?? this.email,
  //       phone: phone ?? this.phone,
  //       shareAbleLink: shareAbleLink ?? this.shareAbleLink,
  //       img: img ?? this.img,
  //       status: status ?? this.status,
  //       location: location ?? this.location,
  //       customLink: customLink ?? this.customLink,
  //       isTrueYou: isTrueYou ?? this.isTrueYou,
  //       createdAt: createdAt ?? this.createdAt,
  //       updatedAt: updatedAt ?? this.updatedAt,
  //       totalReview: totalReview ?? this.totalReview,
  //       reviewPercentage: reviewPercentage ?? this.reviewPercentage,
  //     );
  //
  // factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  //
  // String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        src: json["src"] ?? '',
        provider: json["provider"] ?? '',
        providerId: json["provider_id"] ?? '',
        providerToken: json["provider_token"] ?? '',
        code: json["code"] ?? '',
        emailVerifiedAt: json["email_verified_at"] ?? '',
        phoneVerifiedAt: json["phone_verified_at"] ?? '',
        imageVerifiedAt: json["image_verified_at"] ?? '',
        username: json["username"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        shareAbleLink: json["share_able_link"] ?? '',
        img: json["img"] ?? '',
        status: json["status"] ?? '',
        location: json["location"] ?? '',
        customLink: json["custom_link"] ?? '',
        isTrueYou: json["is_true_you"] ?? '',
        createdAt: DateTime.parse(json["created_at"] ?? ''),
        updatedAt: DateTime.parse(json["updated_at"] ?? ''),
        totalReview: json["total_review"] ?? '',
        reviewPercentage: json["review_percentage"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "src": src,
        "provider": provider,
        "provider_id": providerId,
        "provider_token": providerToken,
        "code": code,
        "email_verified_at": emailVerifiedAt,
        "phone_verified_at": phoneVerifiedAt,
        "image_verified_at": imageVerifiedAt,
        "username": username,
        "email": email,
        "phone": phone,
        "share_able_link": shareAbleLink,
        "img": img,
        "status": status,
        "location": location,
        "custom_link": customLink,
        "is_true_you": isTrueYou,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "total_review": totalReview,
        "review_percentage": reviewPercentage,
      };
}
