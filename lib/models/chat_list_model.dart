import 'dart:convert';

class ChatListModel {
  bool success;
  ChatListDataList data;
  String message;

  ChatListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  ChatListModel copyWith({
    bool? success,
    ChatListDataList? data,
    String? message,
  }) =>
      ChatListModel(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory ChatListModel.fromRawJson(String str) =>
      ChatListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
    success: json["success"],
    data: ChatListDataList.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}


class ChatListDataList {
  List<ChatListData> buyerChats;
  List<ChatListData> sellerChats;

  ChatListDataList({
    required this.buyerChats,
    required this.sellerChats,
  });

  ChatListDataList copyWith({
    List<ChatListData>? buyerChats,
    List<ChatListData>? sellerChats,
  }) =>
      ChatListDataList(
        buyerChats: buyerChats ?? this.buyerChats,
        sellerChats: sellerChats ?? this.sellerChats,
      );

  factory ChatListDataList.fromRawJson(String str) =>
      ChatListDataList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatListDataList.fromJson(Map<String, dynamic> json) => ChatListDataList(
    buyerChats: json.containsKey("buyer_chats")
        ? List<ChatListData>.from(json["buyer_chats"].map((x) => ChatListData.fromJson(x)))
        : [],
    sellerChats: json.containsKey("seller_chats")
        ? List<ChatListData>.from(json["seller_chats"].map((x) => ChatListData.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "buyer_chats": List<dynamic>.from(buyerChats.map((x) => x.toJson())),
    "seller_chats": List<dynamic>.from(sellerChats.map((x) => x.toJson())),
  };
}

class ChatListData {
  int? id;
  String? senderId;
  String? receiverId;
  String? buyerId;
  String? sellerId;
  String? message;
  String? file;
  String? fileName;
  String? fileType;
  String? status;
  String? conversationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Receiver? sender;
  Receiver? receiver;
  String? userImage;
  int? productId;
  int? unReadMsgsCount;
  int? block;
  Product? product;
  ImagePath? imagePath;



  ChatListData({
    this.id,
    this.senderId,
    this.receiverId,
    this.buyerId,
    this.sellerId,
    this.message,
    this.file,
    this.fileName,
    this.fileType,
    this.unReadMsgsCount,
    this.status,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.sender,
    this.receiver,
    this.productId,
    this.product,
    this.imagePath,
    this.userImage,
    this.block,
  });

  ChatListData copyWith({
    int? id,
    String? senderId,
    String? receiverId,
    String? buyerId,
    String? sellerId,
    String? message,
    String? file,
    String? fileName,
    String? fileType,
    String? status,
    String? conversationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    Receiver? sender,
    Receiver? receiver,
    int? productId,
    String? userImage,
    ImagePath? imagePath,
    Product? product,
    int? block,
  }) =>
      ChatListData(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        sellerId: sellerId ?? this.sellerId,
        buyerId: buyerId ?? this.buyerId,
        message: message ?? this.message,
        file: file ?? this.file,
        fileName: fileName ?? this.fileName,
        fileType: fileType ?? this.fileType,
        status: status ?? this.status,
        conversationId: conversationId ?? this.conversationId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
        productId: productId ?? this.productId,
        product: product ?? this.product,
        imagePath: imagePath ?? this.imagePath,
        userImage: userImage ?? this.userImage,
        block: block ?? this.block,

      );

  factory ChatListData.fromRawJson(String str) =>
      ChatListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatListData.fromJson(Map<String, dynamic> json) => ChatListData(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        sellerId: json["seller_id"],
        buyerId: json["buyer_id"],
        message: json["message"],
        file: json["file"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        status: json["status"],
        conversationId: json["conversation_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        sender: Receiver.fromJson(json["sender"]),
        receiver: Receiver.fromJson(json["receiver"]),
        productId: json["product_id"],
        product : json['product'] != null ? Product.fromJson(json['product']) : null,

         userImage: json["user_image"],
        unReadMsgsCount: json["unread_message_count"],
        block: json["block"],
        imagePath: json['image_path'] != null
            ? new ImagePath.fromJson(json['image_path'])
            : null,

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "file": file,
        "file_name": fileName,
        "file_type": fileType,
        "status": status,
        "conversation_id": conversationId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "sender": sender!.toJson(),
        "receiver": receiver!.toJson(),
        "user_image": userImage,
        "block": block,
         'product': product!.toJson(),
        "unread_message_count": unReadMsgsCount,
        'image_path' : imagePath!.toJson()

};
}

class ImagePath {
  int? id;
  int? productId;
  String? src;

  ImagePath({this.id, this.productId, this.src});

  ImagePath.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['src'] = this.src;
    return data;
  }
}


class Receiver {
  int? id;
  String? name;
  String? src;
  String? provider;
  String? providerId;
  String? providerToken;
  String? code;
  DateTime? emailVerifiedAt;
  int? emailCode;
  DateTime? phoneVerifiedAt;
  // String? imageVerifiedAt;
  String? username;
  String? email;
  String? phone;
  String? shareAbleLink;
  String? img;
  int? status;
  String? location;
  String? customLink;
  int? isTrueYou;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? totalReview;
  int? reviewPercentage;

  Receiver({
    required this.id,
    required this.name,
    required this.src,
    required this.provider,
    required this.providerId,
    required this.providerToken,
    required this.code,
    // required this.emailVerifiedAt,
    required this.emailCode,
    // required this.phoneVerifiedAt,
    // required this.imageVerifiedAt,
    required this.username,
    required this.email,
    required this.phone,
    required this.shareAbleLink,
    required this.img,
    required this.status,
    required this.location,
    required this.customLink,
    required this.isTrueYou,
    // required this.createdAt,
    // required this.updatedAt,
    required this.totalReview,
    required this.reviewPercentage,
  });

  Receiver copyWith({
    int? id,
    String? name,
    String? src,
    String? provider,
    String? providerId,
    String? providerToken,
    String? code,
    // DateTime? emailVerifiedAt,
    int? emailCode,
    // DateTime? phoneVerifiedAt,
    // String? imageVerifiedAt,
    String? username,
    String? email,
    String? phone,
    String? shareAbleLink,
    String? img,
    int? status,
    String? location,
    String? customLink,
    int? isTrueYou,
    // DateTime? createdAt,
    // DateTime? updatedAt,
    int? totalReview,
    int? reviewPercentage,
  }) =>
      Receiver(
        id: id ?? this.id,
        name: name ?? this.name,
        src: src ?? this.src,
        provider: provider ?? this.provider,
        providerId: providerId ?? this.providerId,
        providerToken: providerToken ?? this.providerToken,
        code: code ?? this.code,
        // emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        emailCode: emailCode ?? this.emailCode,
        // phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
        // imageVerifiedAt: imageVerifiedAt ?? this.imageVerifiedAt,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        shareAbleLink: shareAbleLink ?? this.shareAbleLink,
        img: img ?? this.img,
        status: status ?? this.status,
        location: location ?? this.location,
        customLink: customLink ?? this.customLink,
        isTrueYou: isTrueYou ?? this.isTrueYou,
        // createdAt: createdAt ?? this.createdAt,
        // updatedAt: updatedAt ?? this.updatedAt,
        totalReview: totalReview ?? this.totalReview,
        reviewPercentage: reviewPercentage ?? this.reviewPercentage,
      );

  factory Receiver.fromRawJson(String str) =>
      Receiver.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        id: json["id"],
        name: json["name"],
        src: json["src"],
        provider: json["provider"],
        providerId: json["provider_id"],
        providerToken: json["provider_token"],
        code: json["code"],
        // emailVerifiedAt: json["email_verified_at"] == null
        //     ? null
        //     : DateTime.parse(json["email_verified_at"]),
        emailCode: json["email_code"],
        // phoneVerifiedAt: json["phone_verified_at"] == null
        //     ? null
        //     : DateTime.parse(json["phone_verified_at"]),
        // imageVerifiedAt: json["image_verified_at"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        shareAbleLink: json["share_able_link"],
        img: json["img"],
        status: json["status"],
        location: json["location"],
        customLink: json["custom_link"],
        isTrueYou: json["is_true_you"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        totalReview: json["total_review"],
        reviewPercentage: json["review_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "src": src,
        "provider": provider,
        "provider_id": providerId,
        "provider_token": providerToken,
        "code": code,
        // "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "email_code": emailCode,
        // "phone_verified_at": phoneVerifiedAt?.toIso8601String(),
        // "image_verified_at": imageVerifiedAt,
        "username": username,
        "email": email,
        "phone": phone,
        "share_able_link": shareAbleLink,
        "img": img,
        "status": status,
        "location": location,
        "custom_link": customLink,
        "is_true_you": isTrueYou,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt?.toIso8601String(),
        "total_review": totalReview,
        "review_percentage": reviewPercentage,
      };
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
  List<Photo>? photo;


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
        this.photo,
        });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    edition = json['edition'];
    authenticity = json['authenticity'];
    fixPrice = json['fix_price'];
    firmOnPrice = json['firm_on_price'];
    auctionPrice = json['auction_price'];
    finalPrice = json['final_price'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    if (this.photo != null) {
      data['photo'] = this.photo!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}


class Photo {
  int? id;
  String? productId;
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