import 'package:flutter/material.dart';
import 'package:tt_offer/models/chat_list_model.dart';

class ChatListProvider extends ChangeNotifier {
  List<ChatListData> buying = [];
  List<ChatListData> selling = [];
  bool loading = true;


  void updateBuyingChatList(List<ChatListData> model) {
    buying = model;
    loading = false;
    notifyListeners();
  }
  void updateSellingChatList(List<ChatListData> model) {
    selling = model;
    loading = false;
    notifyListeners();
  }
}
