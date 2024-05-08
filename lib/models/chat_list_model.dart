import 'dart:convert';

class ChatListModel {
  bool success;
  List<ChatListData> data;
  String message;

  ChatListModel({
    required this.success,
    required this.data,
    required this.message,
  });

  ChatListModel copyWith({
    bool? success,
    List<ChatListData>? data,
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
        data: List<ChatListData>.from(
            json["data"].map((x) => ChatListData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ChatListData {
  int? id;
  int? senderId;
  int? receiverId;
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
  int? block;

  ChatListData({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.file,
    this.fileName,
    this.fileType,
    this.status,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.sender,
    this.receiver,
    this.userImage,
    this.block,
  });

  ChatListData copyWith({
    int? id,
    int? senderId,
    int? receiverId,
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
    String? userImage,
    int? block,
  }) =>
      ChatListData(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
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
        userImage: json["user_image"],
        block: json["block"],
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
      };
}

class Receiver {
  int? id;
  String? name;
  String? src;
  String? provider;
  dynamic providerId;
  dynamic providerToken;
  String? code;
  DateTime? emailVerifiedAt;
  int? emailCode;
  DateTime? phoneVerifiedAt;
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

  Receiver({
    required this.id,
    required this.name,
    required this.src,
    required this.provider,
    required this.providerId,
    required this.providerToken,
    required this.code,
    required this.emailVerifiedAt,
    required this.emailCode,
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

  Receiver copyWith({
    int? id,
    String? name,
    String? src,
    String? provider,
    dynamic providerId,
    dynamic providerToken,
    String? code,
    DateTime? emailVerifiedAt,
    int? emailCode,
    DateTime? phoneVerifiedAt,
    dynamic imageVerifiedAt,
    String? username,
    String? email,
    String? phone,
    dynamic shareAbleLink,
    String? img,
    int? status,
    String? location,
    dynamic customLink,
    int? isTrueYou,
    DateTime? createdAt,
    DateTime? updatedAt,
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
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        emailCode: emailCode ?? this.emailCode,
        phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
        imageVerifiedAt: imageVerifiedAt ?? this.imageVerifiedAt,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        shareAbleLink: shareAbleLink ?? this.shareAbleLink,
        img: img ?? this.img,
        status: status ?? this.status,
        location: location ?? this.location,
        customLink: customLink ?? this.customLink,
        isTrueYou: isTrueYou ?? this.isTrueYou,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
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
        emailVerifiedAt: json["email_verified_at"] == null
            ? null
            : DateTime.parse(json["email_verified_at"]),
        emailCode: json["email_code"],
        phoneVerifiedAt: json["phone_verified_at"] == null
            ? null
            : DateTime.parse(json["phone_verified_at"]),
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "src": src,
        "provider": provider,
        "provider_id": providerId,
        "provider_token": providerToken,
        "code": code,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "email_code": emailCode,
        "phone_verified_at": phoneVerifiedAt?.toIso8601String(),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_review": totalReview,
        "review_percentage": reviewPercentage,
      };
}
