import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/repository/chat_api/chat_repository.dart';

import '../../../data/app_exceptions.dart';
import '../../../data/response/api_response.dart';


class ChatListViewModel with ChangeNotifier {

  ChatRepository chatRepository ;
  ChatListViewModel({required this.chatRepository});


  Timer? _timer;


  ApiResponse<List<Conversation>> sellingChat = ApiResponse.loading();

  setSellingChat(ApiResponse<List<Conversation>> response){
    sellingChat = response ;
    notifyListeners();
  }

  ApiResponse<List<Conversation>> buyingChat = ApiResponse.loading();

  setBuyingChat(ApiResponse<List<Conversation>> response){
    buyingChat = response ;
    notifyListeners();
  }


  bool _unReadMessagesIndicator = false;
  bool get unReadMessagesIndicator => _unReadMessagesIndicator ;

  toggleUnReadMessageIndicator(bool value){
    _unReadMessagesIndicator = value;
    notifyListeners();
  }


  Future<void> getAllChat(int? userId) async {

    try {
      final response = await chatRepository.getAllChat(userId);

      setSellingChat(ApiResponse.completed(response.data.sellerChats));
      setBuyingChat(ApiResponse.completed(response.data.buyerChats));

    } catch(e){
      setSellingChat(ApiResponse.error(e.toString()));
      setBuyingChat(ApiResponse.error(e.toString()));
      log("all chat api ${e.toString()} ");
      log("all chat api ${e.toString()} ");
    }

  }

  void checkForUnReadMessages(List<Conversation> chatList, userId) {
    bool temp = false;
    for (int i = 0; i < chatList.length; i++) {
      if (userId.toString() == chatList[i].receiverId) {
        if ((chatList[i].unReadMsgsCount ?? 0) > 0) {
            temp = true;
            break;
        }
      }
    }
    toggleUnReadMessageIndicator(temp);
    notifyListeners();
  }



  Future<void> markReadChat(String? conversationId) async {

    try {
      await chatRepository.markChatRead(conversationId);

    } catch(e){
      AppException(e.toString());
    }
  }


  Future<void> deleteProductConversation(int? productId) async {

    dynamic data= {
      'product_id' : productId
    };

    try {
      await chatRepository.deleteProductConversation(data);

    } catch(e){
      AppException(e.toString());
    }
  }

  void startTimer(int? userId) {

      _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
        getAllChat(userId);
      });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }






}