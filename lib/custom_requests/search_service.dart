import 'package:flutter/material.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';

class SearchService {
  Future<List<SellingProductsModel>?> searchService({
    required BuildContext context,
    String? query,
  }) async {
    try {
      Map<String, dynamic> body = {'search': query};
      var res = await customPostRequest.httpPostRequest(
        url: 'get-all-products',
        body: body,
      );

      if (res != null && res is List<dynamic> && res.isNotEmpty) {
        List<SellingProductsModel> productsList = [];
        for (var item in res) {
          if (item is Map<String, dynamic>) {
            productsList.add(SellingProductsModel.fromJson(item));
          } else {
            print('Unexpected item format in the response: $item');
          }
        }
        return productsList;
      } else {
        print('No data found or empty response');
        return []; // Return an empty list if no data is found
      }
    } catch (err) {
      print('Error fetching data: $err');
      return null; // Return null or throw an exception based on your needs
    }
  }
}
