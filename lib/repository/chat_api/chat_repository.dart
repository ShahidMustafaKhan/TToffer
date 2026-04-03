import 'package:tt_offer/models/send_message_model.dart';

import '../../models/chat_list_model.dart';
import '../../models/chat_model.dart';

abstract class ChatRepository {
  Future<ChatListModel> getAllChat(int? userId);

  Future<ChatModel> getConversation(String? conversationId);

  Future<void> markChatRead(String? conversationId);

  Future<void> deleteProductConversation(dynamic data);

  Future<SendMessageModel> sendMessage(dynamic data);

  Future<SendMessageModel> sendMessageWithImage(dynamic data, String filePaths);

  Future<dynamic> getConversationId(dynamic data);
}
