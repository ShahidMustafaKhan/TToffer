import 'package:tt_offer/models/user_model.dart';

import '../../../models/product_model.dart';
import 'chat_list_model.dart';


class ChatModel {
  Data? data;
  String message;

  ChatModel({
    this.data,
    required this.message,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

}

class Data {
  List<Conversation>? conversation;
  UserModel? participant1;
  UserModel? participant2;

  Data({
    this.conversation,
    this.participant1,
    this.participant2,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['conversation'] != null) {
      conversation = <Conversation>[];
      json['conversation'].forEach((v) {

        conversation!.add(Conversation.fromJson(v));

      });
    }
    participant1 = json['Participant1'] != null
        ? UserModel.fromJson(json['Participant1'])
        : null;
    participant2 = json['Participant2'] != null
        ? UserModel.fromJson(json['Participant2'])
        : null;
  }


}





