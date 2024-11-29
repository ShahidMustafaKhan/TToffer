import 'dart:developer';

import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/views/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/config/app_urls.dart';

class CartApiProvider extends ChangeNotifier {
  bool isLoading = false;
  CartModel? cartModel;

  int? numberOfItems;



  Future<void> getCartItems({
    required dio,
    required context,
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
      response = await dio.get(path: AppUrls.getCartItems);
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
        cartModel = CartModel.fromJson(responseData);
        getNoOfItems(cartModel);
        notifyListeners();
      }

    } catch (e) {
      if (kDebugMode) {
        print("Something went Wrong $e");
      }

      // showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool?> addCartItems({
    required dio,
    required context,
    required int productId,
    required int price
  }) async {
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
      "quantity": 1,
      "price": price,
    };
    try {
      response = await dio.post(path: AppUrls.addCart, data: params);
      var responseData = response.data;


      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData['message']}");
        isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData['message']}");
        isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData['message']}");
        isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData['message']}");
        isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == responseCode422) {
        showSnackBar(context, "${responseData['message']}");
        isLoading = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        getCartItems(dio: dio, context: context);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
      return false;
    }
    return null;
  }

  Future<void> deleteCartItems({
    required dio,
    required context,
    required int productId
  }) async {
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
    };
    try {
      response = await dio.post(path: AppUrls.removeCart, data: params);
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
        getCartItems(dio: dio, context: context);

        notifyListeners();
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> deleteAllCartItems({
    required dio,
    required context,
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
      response = await dio.delete(path: AppUrls.removeAllCart);
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
        getCartItems(dio: dio, context: context);
        notifyListeners();
      }

    } catch (e) {
      if (kDebugMode) {
        print("Something went Wrong $e");
      }

      // showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }

  getNoOfItems(CartModel? cartModel){
    numberOfItems = 0;
    if(cartModel!= null && cartModel.data!=null ){
       numberOfItems = cartModel.data!.length;
    }
    notifyListeners();
  }


}
