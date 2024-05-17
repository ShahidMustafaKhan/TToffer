class PaymentFeeModel {
  bool? success;
  Data? data;
  String? message;

  PaymentFeeModel({this.success, this.data, this.message});

  PaymentFeeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? value;
  Null? extra;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['extra'] = this.extra;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
