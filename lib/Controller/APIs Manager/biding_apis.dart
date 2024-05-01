// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:tt_offer/Utils/utils.dart';
// import 'package:tt_offer/config/app_urls.dart';

// class ProductsApiProvider extends ChangeNotifier {
//   bool isLoading = false;

//   ////////////////////////////////////////// Auction Productss ////////////////////////////////////////////////

//   void getPlaceBids(
//       {required dio, required context, required productId}) async {
//     isLoading = true;
//     var response;
//     int responseCode200 = 200; // For successful request.
//     int responseCode400 = 400; // For Bad Request.
//     int responseCode401 = 401; // For Unauthorized access.
//     int responseCode404 = 404; // For For data not found
//     int responseCode422 = 422; // For For data not found
//     int responseCode500 = 500; // Internal server error.
//     Map<String, dynamic> params = {
//       "product_id": productId,
//     };
//     try {
//       response = await dio.post(path: AppUrls.getPlaceBids, data: params);
//       var responseData = response.data;
//       if (response.statusCode == responseCode400) {
//         showSnackBar(context, "${responseData["msg"]}");
//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode401) {
//         showSnackBar(context, "${responseData["msg"]}");
//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode404) {
//         showSnackBar(context, "${responseData["msg"]}");

//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode500) {
//         showSnackBar(context, "${responseData["msg"]}");

//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode422) {
//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode200) {
//         isLoading = false;

//         notifyListeners();
//       }
//     } catch (e) {
//       print("Something went Wrong ${e}");
//       showSnackBar(context, "Something went Wrong.");
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   void placeBid(
//       {required dio,
//       required context,
//       required productId,
//       required userId,
//       required price}) async {
//     isLoading = true;
//     var response;
//     int responseCode200 = 200; // For successful request.
//     int responseCode400 = 400; // For Bad Request.
//     int responseCode401 = 401; // For Unauthorized access.
//     int responseCode404 = 404; // For For data not found
//     int responseCode422 = 422; // For For data not found
//     int responseCode500 = 500; // Internal server error.
//     Map<String, dynamic> params = {
//       "product_id": productId,
//       "user_id": userId,
//       "price": price,
//     };
//     try {
//       response = await dio.post(path: AppUrls.placeBid, data: params);
//       var responseData = response.data;
//       if (response.statusCode == responseCode400) {
//         showSnackBar(context, "${responseData["msg"]}");
//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode401) {
//         showSnackBar(context, "${responseData["msg"]}");
//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode404) {
//         showSnackBar(context, "${responseData["msg"]}");

//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode500) {
//         showSnackBar(context, "${responseData["msg"]}");

//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode422) {
//         isLoading = false;
//         notifyListeners();
//       } else if (response.statusCode == responseCode200) {
//         isLoading = false;

//         notifyListeners();
//       }
//     } catch (e) {
//       print("Something went Wrong ${e}");
//       showSnackBar(context, "Something went Wrong.");
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
