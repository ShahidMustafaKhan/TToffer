import 'dart:convert';

class NotificationsModel {
  bool success;
  List<Datum>? data;
  String message;

  NotificationsModel({
    required this.success,
    required this.data,
    required this.message,
  });

  NotificationsModel copyWith({
    bool? success,
    List<Datum>? data,
    String? message,
  }) =>
      NotificationsModel(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory NotificationsModel.fromRawJson(String str) =>
      NotificationsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int id;
  int userId;
  String text;
  String type;
  int typeId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Datum({
    required this.id,
    required this.userId,
    required this.text,
    required this.type,
    required this.typeId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Datum copyWith({
    int? id,
    int? userId,
    String? text,
    String? type,
    int? typeId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) =>
      Datum(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        text: text ?? this.text,
        type: type ?? this.type,
        typeId: typeId ?? this.typeId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        text: json["text"],
        type: json["type"],
        typeId: json["type_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "text": text,
        "type": type,
        "type_id": typeId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
