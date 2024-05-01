class CommonModel {
  final bool success;
  final String message;

  CommonModel({required this.success, required this.message});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(success: json["success"], message: json["message"]);
  }
}
