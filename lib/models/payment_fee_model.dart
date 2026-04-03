class PaymentFeeModel {
  bool? success;
  Data? data;
  String? message;

  PaymentFeeModel({this.success, this.data, this.message});

  PaymentFeeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? value;
  String? extra;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.value,
      this.extra,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    extra = json['extra'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['extra'] = extra;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
