import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/views/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/config/app_urls.dart';

class ProductsApiProvider extends ChangeNotifier {
  var allfeatureProductsData;
  var allauctionProductsData;
  var allProductsData;
  var subCatagoryData;
  var catagoryData;
  bool isLoading = false;

  ////////////////////////////////////////// Auction Productss ////////////////////////////////////////////////

  Future<void> getAuctionProducts({
    productId,
    search,
    cateId,
    subCatId,
    limit,
    location,
    required dio,
    required context,
  }) async {
    if(allauctionProductsData==null ||  allauctionProductsData.isEmpty) {
      isLoading = true;
    }
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "search": search,
      "category_id": cateId,
      "sub_category_id": subCatId,
      "limit": limit,
      "location": location,
      "sort_by": "newest on top"
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        // showSnackBar(context, "${responseData["msg"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "Something went wrong!");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        if(responseData["data"].isNotEmpty ) {
          allauctionProductsData = responseData["data"];
        }
        notifyListeners();
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      // showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }



  ////////////////////////////////////////// Featured Productss ////////////////////////////////////////////////

  Future<void> getFeatureProducts({
    productId,
    search,
    cateId,
    subCatId,
    limit,
    location,
    dio,
    context,
  }) async {
    if(allfeatureProductsData==null ||  allfeatureProductsData.isEmpty) {
      isLoading = true;
    }
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "search": search,
      "category_id": cateId,
      "sub_category_id": subCatId,
      "limit": limit,
      "location": location,
      "sort_by": "newest on top"
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        // showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        notifyListeners();
        isLoading = false;
        if(responseData["data"].isNotEmpty) {
          allfeatureProductsData = responseData["data"];
        }
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // showSnackBar(context, "Something went Wrong.");

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllProducts({
    search,
    dio,
    context,
  }) async {

    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      // "id": productId,
      "search": search,
      // "category_id": cateId,
      // "sub_category_id": subCatId,
      // "limit": limit,
      // "location": location,
      // "sort_by": "newest on top"
    };
    try {
      response = await dio.post(path: AppUrls.getAllProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        // showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        notifyListeners();
        isLoading = false;
        if(responseData["data"].isNotEmpty) {
          allProductsData = responseData["data"];
        }
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print(e);
        print(e);
      }
      // showSnackBar(context, "Something went Wrong.");

      isLoading = false;
      notifyListeners();
    }
  }


}
