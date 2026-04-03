import 'package:tt_offer/mock/product_mock_data.dart';
import 'package:tt_offer/models/send_message_model.dart' as send_message_model;

import '../../mock/chat_mock_data.dart';
import '../../mock/user_mock_data.dart';
import '../../models/chat_list_model.dart';
import '../../models/chat_model.dart';
import 'chat_repository.dart';

class ChatMockRepository implements ChatRepository {
  @override
  Future<ChatListModel> getAllChat(int? userId) async {
    await Future.delayed(const Duration(seconds: 2));
    return ChatListModel(
        data: ConversationList(buyerChats: [
          Conversation(
            id: 1,
            productId: getMockProductById(1).id,
            product: getMockProductById(1),
            sellerId: getMockProductById(1).user!.id,
            buyerId: userId,
            message: 'Sure',
            receiver: getMockProductById(1).user,
            receiverId: getMockProductById(1).user!.id,
            sender: getMockUser(),
            senderId: getMockUser().id,
            createdAt: DateTime.now(),
            conversationId: "123456",
          ),
          Conversation(
              id: 2,
              productId: getMockProductById(2).id,
              product: getMockProductById(2),
              sellerId: getMockProductById(2).user!.id,
              buyerId: userId,
              message: 'Yes, it is still available',
              receiver: getMockProductById(2).user,
              receiverId: getMockProductById(2).user!.id,
              sender: getMockUser(),
              senderId: getMockUser().id,
              conversationId: "654321",
              createdAt: DateTime.now()),
        ], sellerChats: [
          Conversation(
            id: 6,
            productId: getMockProductById(5).id,
            product: getMockProductById(5),
            sellerId: getMockProductById(5).user!.id,
            buyerId: getMockUserById(4).id,
            message: 'Can i get a discount on this product?',
            receiver: getMockProductById(5).user,
            receiverId: getMockProductById(5).user!.id,
            sender: getMockUserById(4),
            senderId: getMockUserById(4).id,
            createdAt: DateTime.now(),
            conversationId: "456123",
          ),
        ]),
        message: '');
  }

  @override
  Future<ChatModel> getConversation(String? conversationId) async {
    Future.delayed(const Duration(seconds: 2));
    return ChatModel(
        message: '',
        data: Data(conversation: getMockConversationList(conversationId!)));
  }

  @override
  Future<void> markChatRead(String? conversationId) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<void> deleteProductConversation(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<send_message_model.SendMessageModel> sendMessage(dynamic data) async {
    return send_message_model.SendMessageModel();
  }

  @override
  Future<send_message_model.SendMessageModel> sendMessageWithImage(
      dynamic data, String filePaths) async {
    dynamic response = {};
    return send_message_model.SendMessageModel.fromJson(response);
  }

  @override
  Future<dynamic> getConversationId(dynamic data) async {
    dynamic response = {};
    return response;
  }
}
