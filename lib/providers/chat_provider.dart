import 'package:flutter/material.dart';
import 'package:tt_offer/models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  ChatModel? data;

  bool loading = true;

  updateChatData(ChatModel model) {
    data = model;

    loading = false;

    notifyListeners();
  }
}
