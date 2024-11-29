import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';

// var response;

class SearchService {
  Future<bool> searchService({
    required BuildContext context,
    String? query,
  }) async {
    try {
      Map<String, dynamic> body = {'search': query};
      var res = await customPostRequest.httpPostRequest(
        url: 'get-all-products',
        body: body,
      );

      // response = res;
      //
      // print('resssssssss--->${response}');

      if (res['success'] == true) {
        SellingSearchModel searchModel = SellingSearchModel.fromJson(res);

        Provider.of<SearchProvider>(context, listen: false)
            .getSellingData(newSelling: searchModel.data!);



        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('Error fetching data: $err');
      return false; // Return null or throw an exception based on your needs
    }
  }
}
