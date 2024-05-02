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

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "message": message,
      };
}

class Data {
  List<Selling> selling;
  List<dynamic> purchase;
  List<dynamic> archive;

  Data({
    required this.selling,
    required this.purchase,
    required this.archive,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        selling:
            List<Selling>.from(json["selling"].map((x) => Selling.fromJson(x))),
        purchase: List<dynamic>.from(json["purchase"].map((x) => x)),
        archive: List<dynamic>.from(json["archive"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "selling": List<dynamic>.from(selling.map((x) => x.toJson())),
        "purchase": List<dynamic>.from(purchase.map((x) => x)),
        "archive": List<dynamic>.from(archive.map((x) => x)),
      };
}

class Selling {
  int id;
  int userId;
  String title;
  String? slug;
  String description;
  int categoryId;
  int subCategoryId;
  String condition;
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
  dynamic sellToUs;
  String? location;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  int? isUrgent;
  int? totalReview;
  int? reviewPercentage;
  int? isArchived;
  int? isSold;
  dynamic soldToUserId;

  Selling({
    required this.id,
    required this.userId,
    required this.title,
    this.slug,
    required this.description,
    required this.categoryId,
    required this.subCategoryId,
    required this.condition,
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
    required this.startingDate,
    required this.startingTime,
    required this.endingDate,
    required this.endingTime,
    required this.sellToUs,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isUrgent,
    required this.totalReview,
    required this.reviewPercentage,
    required this.isArchived,
    required this.isSold,
    required this.soldToUserId,
  });

  factory Selling.fromJson(Map<String, dynamic> json) => Selling(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        condition: json["condition"],
        makeAndModel: json["make_and_model"],
        mileage: json["mileage"],
        color: json["color"],
        brand: json["brand"],
        model: json["model"],
        edition: json["edition"],
        authenticity: json["authenticity"],
        fixPrice: json["fix_price"],
        firmOnPrice: json["firm_on_price"],
        auctionPrice: json["auction_price"],
        startingDate: json["starting_date"],
        startingTime: json["starting_time"],
        endingDate: json["ending_date"],
        endingTime: json["ending_time"],
        sellToUs: json["sell_to_us"],
        location: json["location"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isUrgent: json["is_urgent"],
        totalReview: json["total_review"],
        reviewPercentage: json["review_percentage"],
        isArchived: json["is_archived"],
        isSold: json["is_sold"],
        soldToUserId: json["sold_to_user_id"],
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
        // "starting_date": startingDate?.toIso8601String(),
        "starting_time": startingTime,
        // "ending_date": endingDate?.toIso8601String(),
        "ending_time": endingTime,
        "sell_to_us": sellToUs,
        "location": location,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_urgent": isUrgent,
        "total_review": totalReview,
        "review_percentage": reviewPercentage,
        "is_archived": isArchived,
        "is_sold": isSold,
        "sold_to_user_id": soldToUserId,
      };
}
