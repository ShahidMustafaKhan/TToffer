import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/models/selling_serach_model.dart' hide User;
import 'package:tt_offer/models/user_info_model.dart';

import '../Utils/utils.dart';
import '../main.dart';

class ProfileInfoProvider extends ChangeNotifier {
  List<ProductsDataInfo> data = [];
  List<ReviewsDataInfo> review = [];
  UserInfoModel? userInfoModel;
  double? rating;

  getProfileInfoProduct({required List<ProductsDataInfo> newData}) {
    data = newData;
    notifyListeners();
  }

  getProfileInfoReview({required List<ReviewsDataInfo> newData}) {
    review = newData;
    rating = calculateAverageRatingReviewList(review);
    notifyListeners();
    fetchAndSaveUserInfo(review);
  }


  getUserInfo({required UserInfoModel? userInfo}) {
    userInfoModel = userInfo;
    notifyListeners();
  }

  Future<void> fetchAndSaveUserInfo(List<ReviewsDataInfo> reviews) async {
    for (int i = 0; i < reviews.length; i++) {
      final fromUserId = reviews[i].fromUser;

      if (fromUserId != null) {
        var response = await customGetRequest.httpGetRequest(url: 'user/info/$fromUserId');

        if (response['data'] != null || response['success'] == true) {

          // Store the user data in the review object
          reviews[i].fromUesr = User.fromJson(response['data']);
          notifyListeners();
        } else {
          print('Failed to load user info for user ID $fromUserId');
        }
      }
    }
  }




}
