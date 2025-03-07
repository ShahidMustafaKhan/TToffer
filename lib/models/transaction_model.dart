class TransactionModel {
  int? code;
  bool? status;
  String? message;
  Data? data;

  TransactionModel({this.code, this.status, this.message, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

}

class Data {
  List<Transaction>? transactionList;

  Data(
      {this.transactionList,});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      transactionList = <Transaction>[];
      json['data'].forEach((v) {
        transactionList!.add(Transaction.fromJson(v));
      });
    }
  }


}

class Transaction {
  int? id;
  int? userId;
  int? orderId;
  String? type;
  String? amount;
  String? createdAt;
  String? updatedAt;

  Transaction(
      {this.id,
        this.userId,
        this.orderId,
        this.type,
        this.amount,
        this.createdAt,
        this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    // orderId = json['order_id'];
    type = json['type'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }


}
