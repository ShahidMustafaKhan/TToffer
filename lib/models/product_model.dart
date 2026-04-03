import 'dart:convert';

import 'package:tt_offer/models/user_model.dart';

import 'inventory_model.dart';

class ProductModel {
  int? code;
  bool? status;
  String? message;
  Data? data;

  ProductModel({this.code, this.status, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? currentPage;
  List<Product>? productList;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.productList,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    // currentPage = json['current_page'];
    if (json['data'] != null) {
      productList = <Product>[];
      json['data'].forEach((v) {
        productList!.add(Product.fromJson(v));
      });
    }
    // firstPageUrl = json['first_page_url'];
    // from = json['from'];
    // lastPage = json['last_page'];
    // lastPageUrl = json['last_page_url'];
    // if (json['links'] != null) {
    //   links = <Links>[];
    //   json['links'].forEach((v) {
    //     links!.add(new Links.fromJson(v));
    //   });
    // }
    // nextPageUrl = json['next_page_url'];
    // path = json['path'];
    // perPage = json['per_page'];
    // prevPageUrl = json['prev_page_url'];
    // to = json['to'];
    // total = json['total'];
  }
}

class Product {
  int? id;
  int? userId;
  int? soldToUserId;
  UserModel? soldToUser;
  int? savedForLater;
  List<int>? reportedByUserId;
  String? title;
  String? slug;
  String? description;
  dynamic attributes;
  int? categoryId;
  int? subCategoryId;
  String? condition;
  String? makeAndModel;
  String? edition;
  String? authenticity;
  int? isUrgent;
  int? isArchived;
  int? isSold;
  int? isExpired;
  int? totalReview;
  int? reviewPercentage;
  double? averageRating;
  String? productType;
  int? fixPrice;
  int? minSalary;
  int? maxSalary;
  int? firmOnPrice;
  int? auctionInitialPrice;
  int? auctionFinalPrice;
  String? auctionStartingDate;
  String? auctionStartingTime;
  String? auctionEndingDate;
  String? auctionEndingDateTime;
  String? auctionEndingTime;
  int? notify;
  int? sellToUs;
  String? location;
  double? longitude;
  double? latitude;
  List? deliveryType;
  int? status;
  int? viewsCount;
  bool? isBoosted;
  bool? isProductExpired;
  UserModel? user;
  Category? category;
  SubCategory? subCategory;
  List<Photo>? video;
  UserWishlist? userWishlist;
  List<Photo>? photo;
  List<ProductReviews>? review;
  Inventory? inventory;
  List<ViewsSummary>? viewSummary;
  String? createdAt;
  int? qty;

  Product(
      {this.id,
      this.userId,
      this.soldToUserId,
      this.soldToUser,
      this.savedForLater,
      this.reportedByUserId,
      this.title,
      this.slug,
      this.description,
      this.attributes,
      this.categoryId,
      this.subCategoryId,
      this.condition,
      this.makeAndModel,
      this.edition,
      this.authenticity,
      this.isUrgent,
      this.isArchived,
      this.isSold,
      this.isExpired,
      this.totalReview,
      this.reviewPercentage,
      this.productType,
      this.fixPrice,
      this.maxSalary,
      this.minSalary,
      this.firmOnPrice,
      this.auctionInitialPrice,
      this.auctionFinalPrice,
      this.auctionStartingDate,
      this.auctionStartingTime,
      this.auctionEndingDate,
      this.auctionEndingDateTime,
      this.auctionEndingTime,
      this.notify,
      this.sellToUs,
      this.location,
      this.longitude,
      this.latitude,
      this.deliveryType,
      this.status,
      this.viewsCount,
      this.isBoosted,
      this.isProductExpired,
      this.user,
      this.category,
      this.subCategory,
      this.video,
      this.userWishlist,
      this.photo,
      this.createdAt,
      this.viewSummary,
      this.review,
      this.inventory,
      this.qty});

  Product.copy(Product original)
      : id = original.id,
        userId = original.userId,
        soldToUserId = original.soldToUserId,
        soldToUser = original.soldToUser,
        savedForLater = original.savedForLater,
        reportedByUserId = original.reportedByUserId,
        title = original.title,
        slug = original.slug,
        description = original.description,
        attributes = original.attributes,
        categoryId = original.categoryId,
        subCategoryId = original.subCategoryId,
        condition = original.condition,
        makeAndModel = original.makeAndModel,
        edition = original.edition,
        authenticity = original.authenticity,
        isUrgent = original.isUrgent,
        isArchived = original.isArchived,
        isSold = original.isSold,
        isExpired = original.isExpired,
        totalReview = original.totalReview,
        reviewPercentage = original.reviewPercentage,
        productType = original.productType,
        fixPrice = original.fixPrice,
        maxSalary = original.maxSalary,
        minSalary = original.minSalary,
        firmOnPrice = original.firmOnPrice,
        auctionInitialPrice = original.auctionInitialPrice,
        auctionFinalPrice = original.auctionFinalPrice,
        auctionStartingDate = original.auctionStartingDate,
        auctionStartingTime = original.auctionStartingTime,
        auctionEndingDate = original.auctionEndingDate,
        auctionEndingDateTime = original.auctionEndingDateTime,
        auctionEndingTime = original.auctionEndingTime,
        notify = original.notify,
        sellToUs = original.sellToUs,
        location = original.location,
        longitude = original.longitude,
        latitude = original.latitude,
        deliveryType = original.deliveryType,
        status = original.status,
        viewsCount = original.viewsCount,
        isProductExpired = original.isProductExpired,
        isBoosted = original.isBoosted,
        user = original.user,
        category = original.category,
        subCategory = original.subCategory,
        video = original.video,
        userWishlist = original.userWishlist,
        inventory = original.inventory,
        viewSummary = original.viewSummary,
        qty = original.qty,
        photo =
            original.photo != null ? List<Photo>.from(original.photo!) : null,
        createdAt = original.createdAt,
        review = original.review;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    savedForLater = json['save_for_later'];
    soldToUserId = json['sold_to_user_id'];
    soldToUser = json['sold_to_user'] != null
        ? UserModel.fromJson(json['sold_to_user'])
        : null;
    if (json['reported_by_user_id'] != null) {
      reportedByUserId = <int>[];
      json['reported_by_user_id'].forEach((v) {
        if (v != null) {
          reportedByUserId!.add(v);
        }
      });
    }
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    attributes = json['attributes'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    condition = json['condition'];
    makeAndModel = json['make_and_model'];
    edition = json['edition'];
    authenticity = json['authenticity'];
    isUrgent = json['is_urgent'];
    isArchived = json['is_archived'];
    isSold = json['is_sold'];
    isExpired = json['is_expired'];
    totalReview = json['total_review'];
    isBoosted = json['is_boosted'];
    dynamic tempReviewPercentage = json['review_percentage'];
    if (tempReviewPercentage != null) {
      if (tempReviewPercentage is double) {
        reviewPercentage = tempReviewPercentage.floor();
      } else if (tempReviewPercentage is String) {
        reviewPercentage = int.parse(tempReviewPercentage);
      } else {
        reviewPercentage = tempReviewPercentage;
      }
    }
    productType = json['product_type'];

    dynamic tempFixPrice = json['fix_price'];
    if (tempFixPrice is double) {
      fixPrice = tempFixPrice.floor();
    } else if (tempFixPrice is String) {
      fixPrice = int.parse(tempFixPrice);
    } else {
      fixPrice = tempFixPrice;
    }

    dynamic tempMinSalary = json['min_salary'];
    if (tempMinSalary != null) {
      if (tempMinSalary is double) {
        minSalary = tempMinSalary.floor();
      } else if (tempMinSalary is String) {
        minSalary = int.parse(tempMinSalary.split('.')[0]);
      }
    }
    dynamic tempMaxSalary = json['max_salary'];
    if (tempMaxSalary != null) {
      if (tempMaxSalary is double) {
        maxSalary = tempMaxSalary.floor();
      } else if (tempMaxSalary is String) {
        maxSalary = int.parse(tempMaxSalary.split('.')[0]);
      }
    }

    firmOnPrice = json['firm_on_price'];
    dynamic tempAuctionInitialPrice = json['auction_initial_price'];
    dynamic tempAuctionFinalPrice = json['auction_final_price'];
    if (tempAuctionInitialPrice != null) {
      auctionInitialPrice = tempAuctionInitialPrice.floor();
    }
    if (tempAuctionFinalPrice != null) {
      auctionFinalPrice = tempAuctionFinalPrice.floor();
    }

    dynamic tempAverageRating = json['average_rating'];
    if (tempAverageRating != null) {
      if (tempAverageRating is String) {
        averageRating = double.parse(tempAverageRating);
      } else {
        averageRating = tempAverageRating.toDouble();
      }
    }

    auctionStartingDate = json['auction_starting_date'];
    auctionStartingTime = json['auction_starting_time'];
    auctionEndingDate = json['auction_ending_date'];
    auctionEndingDateTime = json['auction_end_date_time'];
    auctionEndingTime = json['auction_ending_time'];
    notify = json['notify'];
    sellToUs = json['sell_to_us'];
    location = json['location'];
    qty = json['quantity'];
    // longitude = json['longitude'];
    // latitude = json['latitude'];

    dynamic deliveryTempType = json['delivery_type'];

    if (deliveryTempType is String) {
      deliveryType = jsonDecode(json['delivery_type']) ?? [];
    } else {
      deliveryType = json['delivery_type'] ?? [];
    }
    status = json['status'];
    viewsCount = json['views_count'];
    isProductExpired = json['IsProductExpired'];
    if (json['reportedByUserId'] != null) {
      reportedByUserId = <int>[];
      json['reportedByUserId'].forEach((v) {
        reportedByUserId!.add(json[v]);
      });
    }
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    subCategory = json['sub_category'] != null
        ? SubCategory.fromJson(json['sub_category'])
        : null;

    if (json['video'] != null) {
      video = <Photo>[];
      json['video'].forEach((v) {
        video!.add(Photo.fromJson(v));
      });
    }
    userWishlist = json['user_wishlist'] != null
        ? UserWishlist.fromJson(json['user_wishlist'])
        : null;

    if (json['reviews'] != null) {
      review = <ProductReviews>[];
      json['reviews'].forEach((v) {
        review!.add(ProductReviews.fromJson(v));
      });
    }

    if (json['photo'] != null) {
      photo = <Photo>[];
      if (json['photo'] is List) {
        json['photo'].forEach((v) {
          photo!.add(Photo.fromJson(v));
        });
      } else {
        photo!.add(Photo.fromJson(json['photo']));
      }
    } else if (json['photos'] != null) {
      photo = <Photo>[];
      if (json['photos'] is List) {
        json['photos'].forEach((v) {
          photo!.add(Photo.fromJson(v));
        });
      } else {
        photo!.add(Photo.fromJson(json['photos']));
      }
    }

    inventory = json['inventory'] != null
        ? Inventory.fromJson(json['inventory'])
        : null;

    createdAt = json['created_at'];

    if (json['views_summary'] != null) {
      viewSummary = <ViewsSummary>[];
      json['views_summary'].forEach((v) {
        viewSummary!.add(ViewsSummary.fromJson(v));
      });
    }
  }
}

class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class SubCategory {
  int? id;
  int? categoryId;
  String? name;

  SubCategory({this.id, this.categoryId, this.name});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['name'] = name;
    return data;
  }
}

class ImagePath {
  int? productId;
  String? url;

  ImagePath({this.productId, this.url});

  ImagePath.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['url'] = url;
    return data;
  }
}

class UserWishlist {
  int? id;
  int? userId;
  int? productId;

  UserWishlist({this.id, this.userId, this.productId});

  UserWishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['product_id'] = productId;
    return data;
  }
}

class Photo {
  int? id;
  int? productId;
  String? url;
  String? createdAt;
  String? updatedAt;

  Photo({this.id, this.productId, this.url, this.createdAt, this.updatedAt});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['url'] = url;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}

class ProductReviews {
  int? id;
  int? reviewerId;
  int? sellerId;
  int? productId;
  int? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;
  UserModel? reviewer;

  ProductReviews(
      {this.id,
      this.reviewerId,
      this.sellerId,
      this.productId,
      this.rating,
      this.comment,
      this.reviewer,
      this.createdAt,
      this.updatedAt});

  ProductReviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewerId = json['reviewer_id'];
    sellerId = json['seller_id'];
    productId = json['product_id'];
    rating = json['rating'];
    comment = json['comment'];
    reviewer =
        json['reviewer'] != null ? UserModel.fromJson(json['reviewer']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class ViewsSummary {
  String? month;
  int? views;

  ViewsSummary({this.month, this.views});

  ViewsSummary.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['views'] = views;
    return data;
  }
}
