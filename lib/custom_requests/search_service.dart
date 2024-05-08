import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/views/SearchPage/search_page.dart';

class SearchService {
  Future<void> searchService({
    required BuildContext context,
    String? query,
  }) async {
    try {
      Map<String, dynamic> body = {'search': query};
      var res = await customPostRequest.httpPostRequest(
        url: 'get-all-products',
        body: body,
      );

      if (res is List<dynamic> && res.isNotEmpty) {
        List<Selling> sellingList =
        res.map((item) => Selling.fromJson(item)).toList();

        Provider.of<SearchProvider>(context, listen: false)
            .getSellingData(newSelling: sellingList);
      } else {
        // Handle empty response or other error cases
        Provider.of<SearchProvider>(context, listen: false)
            .clearSellingData();
      }
    } catch (err) {
      // Handle error
      print('Error fetching data: $err');
      Provider.of<SearchProvider>(context, listen: false)
          .clearSellingData();
    }
  }
}