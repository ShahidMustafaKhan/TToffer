import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';

class ReportService {
  static Future reportProductService(
      {required BuildContext context, int? userId, int? productId, String? note, String? subject}) async {

      Map<String, dynamic> data = {
        "user_id": userId,
        "product_id": productId,
        "subject": subject,
        "note": note,
      };

      final productViewModel = Provider.of<ProductViewModel>(context, listen: false);

      productViewModel.submitProductReport(data).then((value){
        Navigator.of(context).pop();

        showSnackBar(context, 'Report submitted successfully', title: 'Congratulations!');

      }).onError((error, stackTrace){
        Navigator.of(context).pop();

        showSnackBar(context, error.toString());

      });
  }
}
