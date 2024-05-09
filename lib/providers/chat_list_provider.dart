import 'package:flutter/material.dart';
import 'package:tt_offer/models/chat_list_model.dart';

class ChatListProvider extends ChangeNotifier {
  List<ChatListData> data = [];
  bool loading = true;
  void updateChatList(List<ChatListData> model) {
    data = model;
    loading = false;
    notifyListeners();
  }
}
