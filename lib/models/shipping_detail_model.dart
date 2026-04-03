class ShippingDetailModel {
  int? code;
  bool? status;
  String? message;
  Shipping? data;

  ShippingDetailModel({this.code, this.status, this.message, this.data});

  ShippingDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Shipping.fromJson(json['data']) : null;
  }
}

class Shipping {
  int? id;
  int? userId;
  int? countryId;
  int? cityId;
  String? address;
  String? address2;
  String? phoneNo;
  int? isLandline;
  String? state;
  String? zipCode;
  City? city;
  City? country;
  String? createdAt;
  String? updatedAt;

  Shipping(
      {this.id,
        this.userId,
        this.countryId,
        this.cityId,
        this.address,
        this.address2,
        this.phoneNo,
        this.isLandline,
        this.state,
        this.zipCode,
        this.city,
        this.country,
        this.createdAt,
        this.updatedAt});

  Shipping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    address = json['address'];
    address2 = json['address_2'];
    phoneNo = json['phone_no'];
    isLandline = json['is_landline'];
    state = json['state'];
    zipCode = json['zip_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    country = json['country'] != null ? City.fromJson(json['country']) : null;
  }
}

class City {
  int? id;
  String? name;

  City({this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}