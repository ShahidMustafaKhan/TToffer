class SubscriptionModel {
  int? code;
  bool? status;
  String? message;
  List<Subscription>? data;

  SubscriptionModel({this.code, this.status, this.message, this.data});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Subscription>[];
      json['data'].forEach((v) {
        data!.add(Subscription.fromJson(v));
      });
    }
  }

}

class Subscription {
  int? id;
  String? name;
  String? title;
  double? price;
  String? durationType;
  int? duration;
  String? shortDescription;
  int? productLimit;

  Subscription(
      {this.id,
        this.name,
        this.title,
        this.price,
        this.durationType,
        this.duration,
        this.shortDescription,
        this.productLimit});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    price = json['price'];
    durationType = json['duration_type'];
    duration = json['duration'];
    shortDescription = json['short_description'];
    productLimit = json['product_limit'];
  }

}