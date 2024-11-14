import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';

class ReportService {
  static Future reportProductService(
      {required BuildContext context, int? userId, int? productId, String? note, String? subject}) async {
    try {

      Map<String, dynamic> body = {
        "user_id": userId,
        "product_id": productId,
        "subject": productId,
        "note": note,
        "status": "1",
      };

      var res = await CustomPostRequest().httpPostRequest(
          url:  'add-product-report', body: body);

      if (res['status'] == "success") {
        Navigator.of(context).pop();

        showSnackBar(
            context,
            'Reported Successfully',
                 error : false);

        return true;
      } else {
        Navigator.of(context).pop();

        showSnackBar(
            context,
            res['error'],
            );
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
