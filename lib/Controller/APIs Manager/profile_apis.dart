import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/app_urls.dart';

class ProfileApiProvider extends ChangeNotifier {
  bool isLoading = false;
  var profileData;
  ////////////////////////////////////////// Make Offer ////////////////////////////////////////////////

  void updateProfile(
      {required dio,
      required context,
      required userId,
      imgPath,
      src,
      profile,
      emial,
      userName}) async {
        print("object${profile}");
    isLoading = true;
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    File? profilePhoto;
    if (imgPath != null) {
      profilePhoto = File(imgPath!);
    } else {
      print("Error: imgPath is null");
    }
    var formData = FormData.fromMap({
      "user_id": userId,
      "img": profilePhoto == null
          ? ""
          : await MultipartFile.fromFile(profilePhoto.path),
      "email": emial,
      "username": userName
    });
   if (profile == true) {
  formData = FormData.fromMap({
    "user_id": userId,
    "img": profilePhoto == null
        ? ""
        : await MultipartFile.fromFile(profilePhoto.path),
  });
}
       print("nfk4nfl${formData.fields}");
    try {
      response = await dio.post(path: AppUrls.updateProfile, data: formData);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
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
        showSnackBar(context, "Profile Update Successfully");
        notifyListeners();
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }

  void getProfile({required dio, required context}) async {
    isLoading = true;
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: AppUrls.getProfile);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        notifyListeners();
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
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
        profileData = responseData["data"];
        print("mflfl4mfl4mf$profileData");
        notifyListeners();
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      notifyListeners();
    }
  }
}
