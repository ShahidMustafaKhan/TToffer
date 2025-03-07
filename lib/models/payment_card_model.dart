class PaymentCardsModel {
  int? code;
  bool? status;
  String? message;
  List<PaymentCard>? data;

  PaymentCardsModel({this.code, this.status, this.message, this.data});

  PaymentCardsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PaymentCard>[];
      json['data'].forEach((v) {
        data!.add(PaymentCard.fromJson(v));
      });
    }
  }

}

class PaymentCardDetailModel {
  int? code;
  bool? status;
  String? message;
  PaymentCard? data;

  PaymentCardDetailModel({this.code, this.status, this.message, this.data});

  PaymentCardDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = PaymentCard.fromJson(json['data']);
    }
  }



class PaymentCard {
  int? id;
  int? userId;
  String? brand;
  String? paymentMethodId;
  String? createdAt;

  PaymentCard({this.id, this.userId, this.brand, this.createdAt});

  PaymentCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    brand = json['brand'];
    paymentMethodId = json['payment_method_id'];
    createdAt = json['created_at'];
  }

}