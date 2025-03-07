import 'package:tt_offer/models/user_model.dart';

class AuthenticationModel {
  int? code;
  bool? status;
  String? message;
  Data? data;

  AuthenticationModel({this.code, this.status, this.message, this.data});

  AuthenticationModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}

class Data {
  UserModel? user;
  String? token;

  Data({this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }


}

