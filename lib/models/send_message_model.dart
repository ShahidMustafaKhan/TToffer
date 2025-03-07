import 'package:tt_offer/models/chat_list_model.dart';

class SendMessageModel {
  int? code;
  bool? status;
  String? message;
  Data? response;

  SendMessageModel({this.code, this.status, this.message, this.response});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    response = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

}

class Data {
  List<Conversation>? conversation;
  // List<Null>? documanets;
  List<Conversation>? images;

  Data({this.conversation});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Message'] != null) {
      conversation = <Conversation>[];
      json['Message'].forEach((v) {
        conversation!.add(Conversation.fromJson(v));
      });
    }
    // if (json['Documanets'] != null) {
    //   documanets = <Null>[];
    //   json['Documanets'].forEach((v) {
    //     documanets!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['Images'] != null) {
      images = <Conversation>[];
      json['Images'].forEach((v) {
        images!.add(Conversation.fromJson(v));
      });
    }
  }

}

