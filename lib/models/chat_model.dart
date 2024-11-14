class ChatModel {
  bool success;
  Data? data;
  String message;

  ChatModel({
    required this.success,
    this.data,
    required this.message,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
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
  List<Conversation>? conversation;
  Participant? participant1;
  Participant? participant2;

  Data({
    this.conversation,
    this.participant1,
    this.participant2,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        conversation: json["conversation"] == null
            ? []
            : List<Conversation>.from(
                json["conversation"].map((x) => Conversation.fromJson(x))),
        participant1: Participant.fromJson(json["Participant1"]),
        participant2: Participant.fromJson(json["Participant2"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "conversation":
  //           List<dynamic>.from(conversation!.map((x) => x.toJson())),
  //       "Participant1": participant1.toJson(),
  //       "Participant2": participant2.toJson(),
  //     };
}

class Conversation {
  int? id;
  int? senderId;
  int? receiverId;
  int? buyerId;
  int? sellerId;
  String? message;
  dynamic file;
  dynamic fileName;
  dynamic fileType;
  String? status;
  String? conversationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? offerId;
  int? productId;
  Product? product;
  Offer? offer;

  Conversation({
    this.id,
    this.senderId,
    this.receiverId,
    this.buyerId,
    this.sellerId,
    this.message,
    this.file,
    this.fileName,
    this.fileType,
    this.status,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.offerId,
    this.productId,
    this.product,
    this.offer,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        buyerId: json["buyer_id"],
        sellerId: json["seller_id"],
        message: json["message"],
        file: json["file"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        status: json["status"],
        conversationId: json["conversation_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        offerId: json["offer_id"],
        productId: json["product_id"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "sender_id": senderId,
  //       "receiver_id": receiverId,
  //       "message": message,
  //       "file": file,
  //       "file_name": fileName,
  //       "file_type": fileType,
  //       "status": status,
  //       "conversation_id": conversationId,
  //       "created_at": createdAt?.toIso8601String(),
  //       "updated_at": updatedAt?.toIso8601String(),
  //       "deleted_at": deletedAt,
  //       "offer_id": offerId,
  //       "product_id": productId,
  //       "product": product?.toJson(),
  //       "offer": offer?.toJson(),
  //     };
}

class Offer {
  int? id;
  int? productId;
  int? sellerId;
  int? buyerId;
  int? offerPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;

  Offer({
    this.id,
    this.productId,
    this.sellerId,
    this.buyerId,
    this.offerPrice,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        productId: json["product_id"],
        sellerId: json["seller_id"],
        buyerId: json["buyer_id"],
        offerPrice: json["offer_price"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "seller_id": sellerId,
        "buyer_id": buyerId,
        "offer_price": offerPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
      };
}

class Product {
  int? id;
  int? userId;
  String? title;
  String? slug;
  String? description;
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
  dynamic auctionPrice;
  dynamic startingDate;
  dynamic startingTime;
  dynamic endingDate;
  dynamic endingTime;
  dynamic sellToUs;
  String? location;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isUrgent;
  String? totalReview;
  String? reviewPercentage;
  String? isArchived;
  String? isSold;
  dynamic soldToUserId;
  dynamic viewsCount;
  dynamic boosterStartDatetime;
  dynamic boosterEndDatetime;
  // Category? category;
  // SubCategory? subCategory;
  List<Photo>? photo;
  List<dynamic>? video;
  List<dynamic>? wishlist;

  Product({
    this.id,
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
    // this.category,
    // this.subCategory,
    this.photo,
    this.video,
    this.wishlist,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        authenticity: json["authenticity"],
        fixPrice: json["fix_price"],
        firmOnPrice: json["firm_on_price"],
        auctionPrice: json["auction_price"],
        startingDate: json["starting_date"],
        startingTime: json["starting_time"],
        endingDate: json["ending_date"],
        endingTime: json["ending_time"],

        location: json["location"],

        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),

        // category: Category.fromJson(json["category"]),
        // subCategory: SubCategory.fromJson(json["sub_category"]),
        photo: List<Photo>.from(json["photo"].map((x) => Photo.fromJson(x))),
        video: List<dynamic>.from(json["video"].map((x) => x)),
      );
}

// class Category {
//   int? id;
//   String? name;
//   String? slug;
//   String? color;
//   String? image;
//   int? status;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         id: json["id"],
//         name: json["name"],
//         slug: json["slug"],
//         color: json["color"],
//         image: json["image"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

// }

class Photo {
  // int id;
  // int productId;
  String? src;
  // DateTime createdAt;
  // DateTime updatedAt;

  Photo({
    //  this.id,
    //  this.productId,
    this.src,
    //  this.createdAt,
    //  this.updatedAt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        // id: json["id"],
        // productId: json["product_id"],
        src: json["src"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
      );
}

// class SubCategory {
//   int id;
//   int categoryId;
//   String name;

//   SubCategory({
//    this.id,
//    this.categoryId,
//    this.name,
//   });

// factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
//       id: json["id"],
//       categoryId: json["category_id"],
//       name: json["name"],
//     );

class Participant {
  int? id;
  String? name;
  String? src;
  String? provider;
  dynamic providerId;
  dynamic providerToken;
  String? code;
  DateTime? emailVerifiedAt;
  int? emailCode;
  dynamic phoneVerifiedAt;
  dynamic imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  dynamic shareAbleLink;
  String? img;
  int? status;
  String? location;
  dynamic customLink;
  int? isTrueYou;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalReview;
  int? reviewPercentage;

  Participant({
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
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["id"],
        name: json["name"],
        src: json["src"],
        provider: json["provider"],
        providerId: json["provider_id"],
        providerToken: json["provider_token"],
        code: json["code"],
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        emailCode: json["email_code"],
        phoneVerifiedAt: json["phone_verified_at"],
        imageVerifiedAt: json["image_verified_at"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        shareAbleLink: json["share_able_link"],
        img: json["img"],
        status: json["status"],
        location: json["location"],
        customLink: json["custom_link"],
        isTrueYou: json["is_true_you"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        totalReview: json["total_review"],
        reviewPercentage: json["review_percentage"],
      );
}
