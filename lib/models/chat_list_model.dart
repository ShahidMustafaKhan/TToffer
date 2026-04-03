import 'dart:convert';
import 'package:tt_offer/models/user_model.dart';

import '../../../models/product_model.dart';

class ChatListModel {
  ConversationList data;
  String message;

  ChatListModel({
    required this.data,
    required this.message,
  });

  ChatListModel copyWith({
    bool? success,
    ConversationList? data,
    String? message,
  }) =>
      ChatListModel(
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory ChatListModel.fromRawJson(String str) =>
      ChatListModel.fromJson(json.decode(str));


  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
    data: ConversationList.fromJson(json["data"]),
    message: json["message"],
  );


}


class ConversationList {
  List<Conversation> buyerChats;
  List<Conversation> sellerChats;

  ConversationList({
    required this.buyerChats,
    required this.sellerChats,
  });

  ConversationList copyWith({
    List<Conversation>? buyerChats,
    List<Conversation>? sellerChats,
  }) =>
      ConversationList(
        buyerChats: buyerChats ?? this.buyerChats,
        sellerChats: sellerChats ?? this.sellerChats,
      );

  factory ConversationList.fromRawJson(String str) =>
      ConversationList.fromJson(json.decode(str));


  factory ConversationList.fromJson(Map<String, dynamic> json) => ConversationList(
    buyerChats: json.containsKey("buyer_chats")
        ? List<Conversation>.from(json["buyer_chats"].map((x) => Conversation.fromJson(x)))
        : [],
    sellerChats: json.containsKey("seller_chats")
        ? List<Conversation>.from(json["seller_chats"].map((x) => Conversation.fromJson(x)))
        : [],
  );


}

class Conversation {
  int? id;
  int? senderId;
  int? receiverId;
  int? buyerId;
  int? sellerId;
  String? message;
  String? file;
  String? fileName;
  String? fileType;
  String? status;
  String? conversationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  UserModel? sender;
  UserModel? receiver;
  String? userImage;
  int? productId;
  int? unReadMsgsCount;
  int? block;
  int? offerId;
  Product? product;
  Offer? offer;
  ImagePath? imagePath;



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
    this.offer,

  });

  Conversation copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    int? buyerId,
    int? sellerId,
    String? message,
    String? file,
    String? fileName,
    String? fileType,
    String? status,
    String? conversationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    UserModel? sender,
    UserModel? receiver,
    int? productId,
    String? userImage,
    ImagePath? imagePath,
    Product? product,
    int? block,
    Offer? offer
  }) =>
      Conversation(
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
        offer: offer ?? this.offer,

      );

  factory Conversation.fromRawJson(String str) =>
      Conversation.fromJson(json.decode(str));


  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],

        senderId: json["sender_id"] is String ? int.tryParse(json["sender_id"]) : json["sender_id"] ,
        receiverId: json["receiver_id"] is String ? int.tryParse(json["receiver_id"]) : json["receiver_id"] ,
        sellerId: json["seller_id"] is String ? int.tryParse(json["seller_id"]) : json["seller_id"] ,
        buyerId: json["buyer_id"] is String ? int.tryParse(json["buyer_id"]) : json["buyer_id"] ,
        message: json["message"],
        file: json["file"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        status: json["status"],
        conversationId: json["conversation_id"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        sender: json['sender'] != null ? UserModel.fromJson(json["sender"]) : null,
        receiver: json['receiver'] != null ? UserModel.fromJson(json["receiver"]) : null,
        productId: json["product_id"],
        product : json['product'] != null ? Product.fromJson(json['product']) : null,

       userImage: json["user_image"],
        unReadMsgsCount: json["unread_message_count"],
        block: json["block"],
        imagePath: json['image_path'] != null
            ? ImagePath.fromJson(json['image_path'])
            : null,
        offer: json["offer"] == null ? null : Offer.fromJson(json["offer"]),


  );
}

class ImagePath {
  int? id;
  int? productId;
  String? src;

  ImagePath({this.id, this.productId, this.src});

  ImagePath.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    src = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['url'] = src;
    return data;
  }
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


