import 'dart:convert';

class ChatModel {
  bool success;
  ChatData data;
  String message;

  ChatModel({
    required this.success,
    required this.data,
    required this.message,
  });

  ChatModel copyWith({
    bool? success,
    ChatData? data,
    String? message,
  }) =>
      ChatModel(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory ChatModel.fromRawJson(String str) =>
      ChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        success: json["success"],
        data: ChatData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class ChatData {
  List<Conversation> conversation;
  Participant participant1;
  Participant participant2;

  ChatData({
    required this.conversation,
    required this.participant1,
    required this.participant2,
  });

  ChatData copyWith({
    List<Conversation>? conversation,
    Participant? participant1,
    Participant? participant2,
  }) =>
      ChatData(
        conversation: conversation ?? this.conversation,
        participant1: participant1 ?? this.participant1,
        participant2: participant2 ?? this.participant2,
      );

  factory ChatData.fromRawJson(String str) =>
      ChatData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        conversation: List<Conversation>.from(
            json["conversation"].map((x) => Conversation.fromJson(x))),
        participant1: Participant.fromJson(json["Participant1"]),
        participant2: Participant.fromJson(json["Participant2"]),
      );

  Map<String, dynamic> toJson() => {
        "conversation": List<dynamic>.from(conversation.map((x) => x.toJson())),
        "Participant1": participant1.toJson(),
        "Participant2": participant2.toJson(),
      };
}

class Conversation {
  int? id;
  int? senderId;
  int? receiverId;
  String? message;
  String? file;
  String? fileName;
  String? fileType;
  // Status status;
  String? conversationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Conversation({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.file,
    this.fileName,
    this.fileType,
    // this.status,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Conversation copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    String? message,
    String? file,
    String? fileName,
    String? fileType,
    // Status? status,
    String? conversationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) =>
      Conversation(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        message: message ?? this.message,
        file: file ?? this.file,
        fileName: fileName ?? this.fileName,
        fileType: fileType ?? this.fileType,
        // status: status ?? this.status,
        conversationId: conversationId ?? this.conversationId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory Conversation.fromRawJson(String str) =>
      Conversation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        file: json["file"],
        fileName: json["file_name"],
        fileType: json["file_type"],
        // status: statusValues.map[json["status"]]!,
        conversationId: json["conversation_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "file": file,
        "file_name": fileName,
        "file_type": fileType,
        // "status": statusValues.reverse[status],
        "conversation_id": conversationId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

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

  Participant copyWith({
    int? id,
    String? name,
    String? src,
    String? provider,
    dynamic providerId,
    dynamic providerToken,
    String? code,
    DateTime? emailVerifiedAt,
    int? emailCode,
    dynamic phoneVerifiedAt,
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
      Participant(
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

  factory Participant.fromRawJson(String str) =>
      Participant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_review": totalReview,
        "review_percentage": reviewPercentage,
      };
}

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
