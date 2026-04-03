import 'package:tt_offer/mock/product_mock_data.dart';
import 'package:tt_offer/mock/user_mock_data.dart';

import '../models/chat_list_model.dart';

List<Conversation> getMockConversationList(String conversationId) {
  switch (conversationId) {
    case '123456':
      return [
        Conversation(
          id: 1,
          productId: getMockProductById(1).id,
          product: getMockProductById(1),
          sellerId: getMockProductById(1).user!.id,
          buyerId: getMockUser().id,
          message: 'I am interested in this product',
          receiver: getMockProductById(1).user,
          receiverId: getMockProductById(1).user!.id,
          sender: getMockUser(),
          senderId: getMockUser().id,
          createdAt: DateTime.now(),
          conversationId: "123456",
        ),
        Conversation(
          id: 2,
          productId: getMockProductById(1).id,
          product: getMockProductById(1),
          sellerId: getMockProductById(1).user!.id,
          buyerId: getMockUser().id,
          message: 'Great, would like to place an order?',
          sender: getMockProductById(1).user,
          senderId: getMockProductById(1).user!.id,
          receiver: getMockUser(),
          receiverId: getMockUser().id,
          createdAt: DateTime.now(),
          conversationId: "123456",
        ),
        Conversation(
          id: 3,
          productId: getMockProductById(1).id,
          product: getMockProductById(1),
          sellerId: getMockProductById(1).user!.id,
          buyerId: getMockUser().id,
          message: 'Sure',
          receiver: getMockProductById(1).user,
          receiverId: getMockProductById(1).user!.id,
          sender: getMockUser(),
          senderId: getMockUser().id,
          createdAt: DateTime.now(),
          conversationId: "123456",
        ),
      ];
    case '654321':
      return [
        Conversation(
            id: 4,
            productId: getMockProductById(2).id,
            product: getMockProductById(2),
            sellerId: getMockProductById(2).user!.id,
            buyerId: getMockUser().id,
            message: 'Hello, is this product still available?',
            receiver: getMockProductById(2).user,
            receiverId: getMockProductById(2).user!.id,
            sender: getMockUser(),
            senderId: getMockUser().id,
            conversationId: "654321",
            createdAt: DateTime.now()),
        Conversation(
            id: 5,
            productId: getMockProductById(2).id,
            product: getMockProductById(2),
            sellerId: getMockProductById(2).user!.id,
            buyerId: getMockUser().id,
            message: 'Yes, it is still available',
            sender: getMockProductById(2).user,
            senderId: getMockProductById(2).user!.id,
            receiver: getMockUser(),
            receiverId: getMockUser().id,
            conversationId: "654321",
            createdAt: DateTime.now()),
      ];
    case '456123':
      return [
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
      ];
    default:
      return [];
  }
}
