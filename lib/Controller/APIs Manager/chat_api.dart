import 'dart:developer';

import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/views/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/config/app_urls.dart';

class ChatApiProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isConversationLoading = false;
  var allChatsData;
  var conversationData;
  var conversationsList;
  var showUnReadMessageIndicator = false;

  ////////////////////////////////////////// Make Offer ////////////////////////////////////////////////

  makeOffer(
      {required dio,
      required context,
      required productId,
      required sellerId,
      required buyerId,
      required offerPrice}) async {
    isLoading = true;
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "product_id": productId,
      "seller_id": sellerId,
      "buyer_id": buyerId,
      "offer_price": offerPrice,
    };
    try {
      response = await dio.post(path: AppUrls.makeOffer, data: params);
      var responseData = response.data;

      if (responseData['success'] == true) {
        Navigator.of(context).pop();
        showSnackBar(context, "Offer placed Successfully", error : false);
        notifyListeners();
      }

      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {

        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        isLoading = false;

        notifyListeners();
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllChats({
    required dio,
    required context,
    required userId,
    bool updateChatOnly = false,
  }) async {
    isLoading = true;
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: "${AppUrls.getAllChats}$userId");
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        allChatsData = responseData["data"];

        ChatListModel model = ChatListModel.fromJson(responseData);

        Provider.of<ChatListProvider>(context, listen: false)
            .updateBuyingChatList(model.data.buyerChats);
        Provider.of<ChatListProvider>(context, listen: false)
            .updateSellingChatList(model.data.sellerChats);
        notifyListeners();

        checkForUnReadMessages(model.data.buyerChats,userId, updateChatOnly);
        checkForUnReadMessages(model.data.sellerChats,userId, updateChatOnly);
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      print("Something went Wrong ${e}");
      print("Something went Wrong ${e}");
      // showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }

  void checkForUnReadMessages(List<ChatListData> chatList, userId, bool updateChatOnly) {
      bool temp = false;
      for (int i = 0; i < chatList.length; i++) {
        if (userId.toString() == chatList[i].receiverId) {
          if ((chatList[i].unReadMsgsCount ?? 0) > 0) {
            if(updateChatOnly == true) {
              temp = true;
              break;
            }// No need to continue once we find an unread message
          }
        }
      }
      showUnReadMessageIndicator = temp;
      notifyListeners();
  }


  Future<void> getConversation({
    required dio,
    required context,
    required conversationId,
    required recieverId,
    required sellingId,
    required buyerId,
    required title,
    bool updateOnly = false,
    bool loading = false,
    ProgressDialog? pr,
  }) async {
    isConversationLoading = loading;
    if(pr!=null){
      pr.show();
    }
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    // try {
    response = await dio.get(path: "${AppUrls.getConverstaion}$conversationId");
    var responseData = response.data;
    if (response.statusCode == responseCode400) {
      showSnackBar(context, "${responseData["message"]}");
      isConversationLoading = false;
      if(pr!=null){
        pr.dismiss();
      }
      notifyListeners();
    } else if (response.statusCode == responseCode401) {
      showSnackBar(context, "${responseData["message"]}");
      isConversationLoading = false;
      if(pr!=null){
        pr.dismiss();
      }
      notifyListeners();
    } else if (response.statusCode == responseCode404) {
      showSnackBar(context, "${responseData["message"]}");

      isConversationLoading = false;
      if(pr!=null){
        pr.dismiss();
      }
      notifyListeners();
    } else if (response.statusCode == responseCode500) {
      showSnackBar(context, "${responseData["message"]}");

      isConversationLoading = false;
      if(pr!=null){
        pr.dismiss();
      }
      notifyListeners();
    } else if (response.statusCode == responseCode422) {
      isConversationLoading = false;
      if(pr!=null){
        pr.dismiss();
      }
      notifyListeners();
    } else if (response.statusCode == responseCode200) {
      isConversationLoading = false;
      notifyListeners();
      if(pr!=null){
        pr.dismiss();
      }
      conversationData = responseData["data"];


      // log("responseData for chat in chatapi = $responseData");



      ChatModel model = ChatModel.fromJson(responseData);

      Provider.of<ChatProvider>(context, listen: false).updateChatData(model);
      String? receiverImg;
      if (recieverId == model.data!.participant1!.id.toString()) {
        receiverImg = model.data!.participant1!.img;
      } else {
        receiverImg = model.data!.participant2!.img;
      }

      // if(updateOnly == false) {
      //   push(
      //     context,
      //     OfferChatScreen(
      //       recieverId: recieverId,
      //       buyerId: buyerId ?? model.data!.conversation![0].buyerId,
      //       sellerId: sellingId ?? model.data!.conversation![0].sellerId,
      //       title: title,
      //       userImgUrl: receiverImg,
      //     ));
      // }
      notifyListeners();
    }
    // } catch (e) {
    //   print("Something went Wrong ${e}");
    //   showSnackBar(context, "Something went Wrong.");
    //   isLoading = false;
    //   notifyListeners();
    // }
  }

  void changeUnReadMessagesStatus({
    required dio,
    required context,
    required conversationId,
  }) async {
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    // try {
    response = await dio.get(path: "${AppUrls.unReadCount}$conversationId");
    var responseData = response.data;
    if (response.statusCode == responseCode400) {
      showSnackBar(context, "${responseData["message"]}");
      isLoading = false;
      notifyListeners();
    } else if (response.statusCode == responseCode401) {
      showSnackBar(context, "${responseData["message"]}");
      isLoading = false;
      notifyListeners();
    } else if (response.statusCode == responseCode404) {
      showSnackBar(context, "${responseData["message"]}");

      isLoading = false;
      notifyListeners();
    } else if (response.statusCode == responseCode500) {
      showSnackBar(context, "${responseData["message"]}");

      isLoading = false;
      notifyListeners();
    } else if (response.statusCode == responseCode422) {
      isLoading = false;
      notifyListeners();
    } else if (response.statusCode == responseCode200) {
      isLoading = false;
      conversationData = responseData["data"];

      log("responseData for chat in chatapi = $responseData");

// Convert the list of data into ChatData objects
      // List<ChatData> chatDataList =
      //     responseData["data"].map((json) => ChatData.fromJson(json)).toList();

      // ChatModel model = ChatModel.fromJson(responseData);

      // Provider.of<ChatProvider>(context, listen: false).updateChatData(model);
      notifyListeners();
    }
    // } catch (e) {
    //   print("Something went Wrong ${e}");
    //   showSnackBar(context, "Something went Wrong.");
    //   isLoading = false;
    //   notifyListeners();
    // }
  }



}
