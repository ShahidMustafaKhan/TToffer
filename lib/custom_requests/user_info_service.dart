import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/models/user_info_model.dart';
import 'package:tt_offer/providers/profile_info_provider.dart';
import 'package:http/http.dart' as http;

class UserInfoService {
  Future userInfoService(
      {required BuildContext context, required int id}) async {
    try {
      var res = await customGetRequest.httpGetRequest(url: 'user/info/$id');

      if (res['success'] == true) {
        UserInfoModel userInfoModel = UserInfoModel.fromJson(res);

        Provider.of<ProfileInfoProvider>(context, listen: false)
            .getProfileInfoProduct(newData: userInfoModel.data!.products!);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
