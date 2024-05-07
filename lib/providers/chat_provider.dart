import 'package:flutter/material.dart';
import 'package:tt_offer/models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatData> data = [];

  bool loading = true;

  updateChatData(List<ChatData> model) {
    data = model;

    loading = false;

    notifyListeners();
  }
}
