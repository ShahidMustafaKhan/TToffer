import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/models/post_product_model.dart';
import 'package:tt_offer/repository/chat_api/chat_repository.dart';

import '../../../data/app_exceptions.dart';
import '../../../data/response/api_response.dart';
import '../../../models/product_model.dart';
import '../../../repository/product_api/get_product_api/get_product_repository.dart';
import '../../../repository/product_api/post_products_api/post_product_repository.dart';


class ChatViewModel with ChangeNotifier {

  ChatRepository chatRepository ;
  ChatViewModel({required this.chatRepository});


  // ApiResponse<List<Conversation>> conversation = ApiResponse.loading();
  //
  // setConversation(ApiResponse<List<Conversation>> response, {bool update = true}){
  //   conversation = response ;
  //   if(update){
  //   notifyListeners();
  //   }
  // }


  bool _unReadMessagesIndicator = false;
  bool get unReadMessagesIndicator => _unReadMessagesIndicator ;

  toggleUnReadMessageIndicator(bool value){
    _unReadMessagesIndicator = value;
    notifyListeners();
  }

  bool _sendingMessage = false;
  bool get sendingMessage => _sendingMessage ;

  bool _sendingTapMessage = false;
  bool get sendingTapMessage => _sendingTapMessage ;


  updateSendingMessageLoading(bool value, {bool isTapMessageLoading = false}){
    if(isTapMessageLoading == true){
      _sendingTapMessage = value;
    }
    else{
      _sendingMessage = value;
    }
    notifyListeners();
  }

  bool _disableTextField = false;
  bool get disableTextField => _disableTextField ;

  setDisableTextField(bool value){
    _disableTextField = value;
    notifyListeners();
  }

  bool _conversationLoading = false;
  bool get conversationLoading => _conversationLoading ;

  setConversationLoading(bool value, {bool update = true}){
    _conversationLoading = value;
    if(update){
      notifyListeners();
    }
  }


  // Future<void> getConversation(String? conversationId , {bool loading = false}) async {
  //
  //   if(loading == true){
  //     setConversation(ApiResponse.loading());
  //   }
  //
  //   try {
  //     final response = await chatRepository.getConversation(conversationId);
  //     setConversation(ApiResponse.completed(response.data?.conversation ?? []));
  //
  //   } catch(e){
  //     setConversation(ApiResponse.error(e.toString()));
  //     log("conversation api ${e.toString()} ");
  //     log("conversation api ${e.toString()} ");
  //   }
  //
  // }


  Future<List<Conversation>> getConversationList(String? conversationId , {bool loading = false}) async {
    if(loading == true){
      setConversationLoading(true);
    }

    try {
      final response = await chatRepository.getConversation(conversationId);
      setConversationLoading(false);
      return response.data?.conversation ?? [];

    } catch(e){
      setConversationLoading(false);
      throw AppException(e.toString());
      log("conversation api ${e.toString()} ");
      log("conversation api ${e.toString()} ");
    }

  }

  Future<void> markReadChat(String? conversationId) async {

    try {
      await chatRepository.markChatRead(conversationId);

    } catch(e){
      AppException(e.toString());
    }

  }


  Future<List<Conversation>> sendMessage({
    required int? senderId,
    required int? receiverId,
    required int? buyerId,
    required int? sellerId,
    required int? productId,
    required String? message,
    bool isTapMessageLoading = false
  }) async {

    var data = {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "buyer_id": buyerId,
      "seller_id": sellerId,
      "product_id": productId,
    };

    try {
      updateSendingMessageLoading(true, isTapMessageLoading: isTapMessageLoading);
      setDisableTextField(true);
      final response = await chatRepository.sendMessage(data);
      updateSendingMessageLoading(false, isTapMessageLoading: isTapMessageLoading);
      setDisableTextField(false);
      return response.response?.conversation ?? [];

    } catch(e){
      updateSendingMessageLoading(false, isTapMessageLoading: isTapMessageLoading);
      setDisableTextField(false);
      throw AppException(e.toString());
    }

  }


  Future<List<Conversation>> sendMessageWithImage({
    required int? senderId,
    required int? receiverId,
    required int? buyerId,
    required int? sellerId,
    required int? productId,
    required String filePaths,
    required String? message,
  }) async {

    var data = {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "buyer_id": buyerId,
      "seller_id": sellerId,
      "product_id": productId,
      if(message!=null)
      "message": message,
    };

    try {
      updateSendingMessageLoading(true);
      setDisableTextField(true);
      final response = await chatRepository.sendMessageWithImage(data, filePaths);
      updateSendingMessageLoading(false);
      setDisableTextField(false);
      return response.response?.images ?? [];

    } catch(e){
      debugPrint("error in chat ${e.toString()}");
      updateSendingMessageLoading(false);
      setDisableTextField(false);
      throw AppException(e.toString());
    }

  }


  Future<dynamic> getConversationId({

    required int? sellerId,
    required int? buyerId,
    required int? productId,
  }) async {

    var data = {
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "product_id": productId,
    };

    try {
      dynamic response = await chatRepository.getConversationId(data);
      return response;

    } catch(e){
      log("get conversation id ${e.toString()}");
      throw AppException(e.toString());
    }

  }











}