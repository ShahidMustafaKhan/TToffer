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
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class NotificationData {
  int? id;
  int? userId;
  String? text;
  String? type;
  int? typeId;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  NotificationData(
      {this.id,
        this.userId,
        this.text,
        this.type,
        this.typeId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['text'] = text;
    data['type'] = type;
    data['type_id'] = typeId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
