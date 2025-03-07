import 'package:tt_offer/models/product_model.dart';
import 'package:tt_offer/models/user_model.dart';

class SavedListModel {
  int? code;
  bool? status;
  String? message;
  Data? data;

  SavedListModel({this.code, this.status, this.message, this.data});

  SavedListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
    }
  }


class Data {
  int? currentPage;
  List<SaveList>? saveList;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
        this.saveList,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      saveList = <SaveList>[];
      json['data'].forEach((v) {
        saveList!.add(SaveList.fromJson(v));
      });
    }
  }}


class SaveList {
  int? id;
  int? userId;
  int? productId;
  int? isSave;
  String? createdAt;
  UserModel? user;
  Product? product;

  SaveList({this.id, this.userId, this.productId, this.isSave, this.user, this.product});

  SaveList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isSave = json['is_save'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

}



