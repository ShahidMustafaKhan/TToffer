import 'package:flutter/material.dart';
import 'package:tt_offer/models/chat_list_model.dart';

class ChatListProvider extends ChangeNotifier {
  List<Conversation> buying = [];
  List<Conversation> selling = [];
  bool loading = true;


  void updateBuyingChatList(List<Conversation> model) {
    buying = model;
    loading = false;
    notifyListeners();
  }
  void updateSellingChatList(List<Conversation> model) {
    selling = model;
    loading = false;
    notifyListeners();
  }
}
