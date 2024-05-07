import 'package:flutter/cupertino.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/main.dart';

class UpdateAccountSettingService {
  Future updateProfileNameService(
      {required BuildContext context, required String name}) async {
    try {
      String? id = pref.getString(PrefKey.userId);
      print('idd--->${id}');

      Map body = {'user_id': id, 'username': name};

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'update/user', body: body);

      if (res['success'] == true) {
        // showSnackBar(context, 'Update Successfully');
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future updateEmailService(
      {required BuildContext context, required String email}) async {
    try {
      String? id = pref.getString(PrefKey.userId);

      Map body = {'user_id': id, 'email': email};

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'update/user', body: body);

      if (res['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future updatePasswordService(
      {required BuildContext context,
      required String newPassword,
      String? email}) async {
    try {
      // String? email = pref.getString(PrefKey.email);
      String? id = pref.getString(PrefKey.userId);

      Map body = {"email": email, "password": newPassword};

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'new-password', body: body);

      if (res['status'] == 'success') {
        showSnackBar(context, 'Password updated');
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future updateLocationService(
      {required BuildContext context, required String location}) async {
    try {
      String? id = pref.getString(PrefKey.userId);

      Map body = {'user_id': id, 'location': location};

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'update/user', body: body);

      if (res['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> updatePhoneService({
    required BuildContext context,
    required String phone,
  }) async {
    try {
      String? userId = pref.getString(PrefKey.userId);

      if (userId == null) {
        return false;
      }

      Map<String, dynamic> body = {
        "user_id": userId,
        "phone_verified_at": "2024-04-05",
        "phone": phone,
      };

      var res = await CustomPostRequest().httpPostRequest(
        url: 'update/user',
        body: body,
      );

      if (res != null && res['success'] == true) {
        showSnackBar(context, 'Phone verified successfully');
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('Error updating phone: $err');
      return false;
    }
  }


  Future verifyEmail(
      {required BuildContext context, required String email}) async {
    try {
      String? id = pref.getString(PrefKey.userId);

      Map<String, dynamic> body = {
        'user_id': id,
        'email_verified_at': DateTime.now().toString(),
      };

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'update/user', body: body);

      if (res != null && res['success'] == true) {
        // Check if res is not null before accessing 'success'
        showSnackBar(context, 'Email verified successfully');
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
