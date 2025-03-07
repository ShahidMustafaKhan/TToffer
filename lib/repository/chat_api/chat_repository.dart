import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/send_message_model.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/post_product_model.dart';
import '../../../models/product_model.dart';
import '../../models/chat_list_model.dart';
import '../../models/chat_model.dart';


class ChatRepository {

  final _apiServices = NetworkApiService() ;

  Future<ChatListModel> getAllChat(int? userId) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.getAllChats}/$userId");
    return ChatListModel.fromJson(response) ;
  }

  Future<ChatModel> getConversation(String? conversationId) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.getConversation}/$conversationId");
    return ChatModel.fromJson(response) ;
  }

  Future<void> markChatRead(String? conversationId) async {
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.unReadCount}/$conversationId");
    return response ;
  }

  Future<void> deleteProductConversation(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.deleteProductConversation,data);
    return response ;
  }

  Future<SendMessageModel> sendMessage(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.sendMessage, data);
    return SendMessageModel.fromJson(response) ;
  }

  Future<SendMessageModel> sendMessageWithImage(dynamic data, String filePaths) async {
    dynamic response = await _apiServices.postSingleFileApiRequest(AppUrls.baseUrl+AppUrls.sendMessage, data, filePaths, fileKey: "images[]");
    return SendMessageModel.fromJson(response) ;
  }

  Future<dynamic> getConversationId(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.getConversationUrl, data);
    return response ;
  }







}