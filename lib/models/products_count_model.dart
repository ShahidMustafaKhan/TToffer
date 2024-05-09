class ProductCountModel {
  bool success;
  List<ItemData> data;
  String message;

  ProductCountModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProductCountModel.fromJson(Map<String, dynamic> json) =>
      ProductCountModel(
        success: json["success"],
        data:
            List<ItemData>.from(json["data"].map((x) => ItemData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ItemData {
  int id;
  int userId;
  String title;
  String description;
  dynamic soldToUserId;
  int? viewsCount;

  List<Photo> photo;

  ItemData({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.photo,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        description: json["description"],
        photo: List<Photo>.from(json["photo"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "views_count": viewsCount,
        "photo": List<dynamic>.from(photo.map((x) => x.toJson())),
      };
}

class Photo {
  int id;
  int productId;
  String? src;

  Photo({
    required this.id,
    required this.productId,
    this.src,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        productId: json["product_id"],
        src: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "src": src,
      };
}
