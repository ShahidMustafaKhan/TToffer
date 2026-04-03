import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/send_message_model.dart';

import '../../../data/network/network_api_services.dart';
import '../../models/chat_list_model.dart';
import '../../models/chat_model.dart';
import 'chat_repository.dart';

class ChatHttpRepository implements ChatRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<ChatListModel> getAllChat(int? userId) async {
    dynamic response = await _apiServices
        .getGetApiResponse("${AppUrls.baseUrl + AppUrls.getAllChats}/$userId");
    return ChatListModel.fromJson(response);
  }

  @override
  Future<ChatModel> getConversation(String? conversationId) async {
    dynamic response = await _apiServices.getGetApiResponse(
        "${AppUrls.baseUrl + AppUrls.getConversation}/$conversationId");
    return ChatModel.fromJson(response);
  }

  @override
  Future<void> markChatRead(String? conversationId) async {
    dynamic response = await _apiServices.getGetApiResponse(
        "${AppUrls.baseUrl + AppUrls.unReadCount}/$conversationId");
    return response;
  }

  @override
  Future<void> deleteProductConversation(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.deleteProductConversation, data);
    return response;
  }

  @override
  Future<SendMessageModel> sendMessage(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.sendMessage, data);
    return SendMessageModel.fromJson(response);
  }

  @override
  Future<SendMessageModel> sendMessageWithImage(
      dynamic data, String filePaths) async {
    dynamic response = await _apiServices.postSingleFileApiRequest(
        AppUrls.baseUrl + AppUrls.sendMessage, data, filePaths,
        fileKey: "images[]");
    return SendMessageModel.fromJson(response);
  }

  @override
  Future<dynamic> getConversationId(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getConversationUrl, data);
    return response;
  }
}
