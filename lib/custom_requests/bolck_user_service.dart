import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';

class BlockdeUserService {
  Future blockUserService(
      {required BuildContext context, int? id, required bool report}) async {
    try {
      Map<String, dynamic> body = {"user_id": id};

      var res = await CustomPostRequest().httpPostRequest(
          url: report == true ? 'report-a-user' : 'block-a-user', body: body);

      if (res['status'] == true) {
        Navigator.of(context).pop();

        showSnackBar(
            context,
            report == true
                ? 'User Reported Successfully'
                : 'User Blocked Successfully', error : false);

        return true;
      } else {
        return false;
      }
    } catch (err) {
      showSnackBar(context, err.toString());
      print(err);
      return false;
    }
  }
}
