class ChatModel {
  bool? success;
  List<ChatData>? data;
  String? message;

  ChatModel({this.success, this.data, this.message});

  ChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != dynamic) {
      data = <ChatData>[];
      json['data'].forEach((v) {
        data!.add(ChatData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != dynamic) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class ChatData {
  int? id;
  int? senderId;
  int? receiverId;
  String? message;
  String? file;
  String? fileName;
  String? fileType;
  String? status;
  String? conversationId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Sender? sender;
  Receiver? receiver;
  String? userImage;
  int? block;

  ChatData(
      {this.id,
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
      this.block});

  ChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    file = json['file'];
    fileName = json['file_name'];
    fileType = json['file_type'];
    status = json['status'];
    conversationId = json['conversation_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null;
    userImage = json['user_image'];
    block = json['block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['message'] = message;
    data['file'] = file;
    data['file_name'] = fileName;
    data['file_type'] = fileType;
    data['status'] = status;
    data['conversation_id'] = conversationId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    data['user_image'] = userImage;
    data['block'] = block;
    return data;
  }
}

class Sender {
  int? id;
  String? name;
  String? src;
  String? provider;
  dynamic providerId;
  dynamic providerToken;
  String? code;
  String? emailVerifiedAt;
  int? emailCode;
  String? phoneVerifiedAt;
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
  String? createdAt;
  String? updatedAt;
  int? totalReview;
  int? reviewPercentage;

  Sender(
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

  Sender.fromJson(Map<String, dynamic> json) {
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

class Receiver {
  int? id;
  String? name;
  String? src;
  String? provider;
  dynamic providerId;
  dynamic providerToken;
  String? code;
  String? emailVerifiedAt;
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
  String? createdAt;
  String? updatedAt;
  int? totalReview;
  int? reviewPercentage;

  Receiver(
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

  Receiver.fromJson(Map<String, dynamic> json) {
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
