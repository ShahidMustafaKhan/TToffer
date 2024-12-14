import 'package:flutter/cupertino.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

class UpdateAccountSettingService {

  Future updateProfileNameService(
      {required BuildContext context, required String name, required UserViewModel userViewModel}) async {
      String? id = pref.getString(PrefKey.userId);

      Map body = {'user_id': id, 'name': name};

      userViewModel.updateUserProfile(body).then((value){
        showSnackBar(context, 'Updated Successfully', title : 'Congratulations!');
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });

  }

  Future updateEmailService(
      {required BuildContext context, required String email, required UserViewModel userViewModel}) async {

      String? id = pref.getString(PrefKey.userId);

      Map body = {'user_id': id, 'email': email};

      userViewModel.updateUserProfile(body).then((value){
        showSnackBar(context, 'Updated Successfully', title : 'Congratulations!');
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
  }

  Future updatePasswordService(
      {required BuildContext context,
      required String newPassword, required String oldPassword, required UserViewModel userViewModel,}) async {

      Map body = {"old_password": oldPassword, "password": newPassword};

      userViewModel.updatePassword(body).then((value){
        showSnackBar(context, 'Password Updated Successfully', title : 'Congratulations!');
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
  }

  Future updateLocationService(
      {required BuildContext context, required String location, required UserViewModel userViewModel}) async {
      String? id = pref.getString(PrefKey.userId);

      Map body = {'user_id': id, 'location': location};


      userViewModel.updateUserProfile(body).then((value){
        showSnackBar(context, 'Updated Successfully', title : 'Congratulations!');
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
  }

  Future<void> updatePhoneService({
    required BuildContext context,
    required String phone, required UserViewModel userViewModel
  }) async {
      String? userId = pref.getString(PrefKey.userId);

      if (userId == null) {
        return ;
      }

      Map<String, dynamic> body = {
        "user_id": userId,
        "phone_verified_at": DateTime.now.toString(),
        "phone": phone,
      };


      userViewModel.updateUserProfile(body).then((value){
        showSnackBar(context, 'Updated Successfully', title : 'Congratulations!');
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
  }


  Future verifyEmail(
      {required BuildContext context, required String email, required UserViewModel userViewModel}) async {
      String? id = pref.getString(PrefKey.userId);

      Map<String, dynamic> body = {
        'user_id': id,
        'email_verified_at': DateTime.now().toString(),
      };

      userViewModel.updateUserProfile(body).then((value){
        showSnackBar(context, 'Updated Successfully', title : 'Congratulations!');
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
      });
}
}
