import 'dart:developer';

import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/models/chat_list_model.dart';
import 'package:tt_offer/models/chat_model.dart';
import 'package:tt_offer/providers/chat_list_provider.dart';
import 'package:tt_offer/providers/chat_provider.dart';
import 'package:tt_offer/views/ChatScreens/offer_chat_screen.dart';
import 'package:tt_offer/config/app_urls.dart';

class BannerController extends ChangeNotifier {
  List<String> firstBanner = [];
  List<String> secondBanner = [];
  List<String> thirdBanner = [];

  bool isLoading = false;

  ////////////////////////////////////////// Make Offer ////////////////////////////////////////////////

  Future<void> getAllBanner({
    required dio,
    required context,
  }) async {
    isLoading = true;
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: AppUrls.getBanners);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        // showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode200) {
        isLoading = false;

        BannerModel model = BannerModel.fromJson(responseData);
        addBannerImages(model);

      }
    } catch (e) {
      print("Something went Wrong ${e}");
      // showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }


  addBannerImages(BannerModel model) {
    List<String> firstBannerTemp = [];
    List<String> secondBannerTemp = [];
    List<String> thirdBannerTemp = [];

    for (var element in model.data!) {
      if (element.pageName == "home") {
        firstBannerTemp.add(element.img!);
      }
      else if (element.pageName == "product") {
        secondBannerTemp.add(element.img!);
      }
      else {
        thirdBannerTemp.add(element.img!);
      }
    }

    firstBanner = firstBannerTemp;
    secondBanner = secondBannerTemp;
    thirdBanner = thirdBannerTemp;
    notifyListeners();
  }

}



class BannerModel {
  String? status;
  List<Data>? data;
  String? message;

  BannerModel({this.status, this.data, this.message});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? img;
  Null? html;
  String? status;
  String? pageName;
  String? sequence;
  String? startDatetime;
  String? endDatetime;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.img,
        this.html,
        this.status,
        this.pageName,
        this.sequence,
        this.startDatetime,
        this.endDatetime,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    html = json['html'];
    status = json['status'];
    pageName = json['page_name'];
    sequence = json['sequence'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img'] = this.img;
    data['html'] = this.html;
    data['status'] = this.status;
    data['page_name'] = this.pageName;
    data['sequence'] = this.sequence;
    data['start_datetime'] = this.startDatetime;
    data['end_datetime'] = this.endDatetime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}