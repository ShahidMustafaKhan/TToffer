class AdvertisementBannerModel {
  int? code;
  bool? status;
  String? message;
  List<AdvertisementBanner>? data;

  AdvertisementBannerModel({this.code, this.status, this.message, this.data});

  AdvertisementBannerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AdvertisementBanner>[];
      json['data'].forEach((v) {
        data!.add(AdvertisementBanner.fromJson(v));
      });
    }
  }

}

class AdvertisementBanner {
  int? id;
  String? title;
  String? description;
  String? type;
  String? path;
  String? redirect;
  String? status;
  String? position;
  int? sequence;
  String? startDate;
  String? endDate;
  String? price;

  AdvertisementBanner(
      {this.id,
        this.title,
        this.description,
        this.type,
        this.path,
        this.redirect,
        this.status,
        this.position,
        this.sequence,
        this.startDate,
        this.endDate,
        this.price});

  AdvertisementBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    path = json['mobile_path'];
    redirect = json['redirect'];
    status = json['status'];
    position = json['position'];
    sequence = json['sequence'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    price = json['price'];
  }

}