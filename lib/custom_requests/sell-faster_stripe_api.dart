import 'package:flutter/cupertino.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';

class SellFasterStripeService {
  Future<bool> sellFasterStripeService({
    required BuildContext context,
    int? productId,
    String? nod,
    String? amount,
    String? currency,
    String? token,
  }) async {
    try {
      Map<String, dynamic> body = {
        'product_id': productId,
        'number_of_days': nod,
        'amount': amount,
        'currency': currency,
        'token': '4242424242424242',
      };

      Map<String, dynamic> res = await CustomPostRequest()
          .httpPostRequest(url: 'sell-faster', body: body);

      if (res['success'] == true) {
        return true; // Success
      } else {
        showSnackBar(context, res['error']);
        return false; // Failure
      }
    } catch (err) {
      print(err);
      return false; // Error
    }
  }
}
