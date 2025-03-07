import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../config/keys/pref_keys.dart';
import '../../../main.dart';
import '../../../models/user_model.dart';

//singleton class
class SessionController {

  static final SessionController _session = SessionController._internel();

  bool? isLogin;
  UserModel user = UserModel();

  factory SessionController() {
    return _session;
  }

  SessionController._internel() {
    // here we can initialize the values
    isLogin = false;
  }

  // saving data into shared preference
  Future<void> saveUserInPreference(UserModel? userModel, String? token) async {
    await pref.setString(PrefKey.userId, userModel?.id?.toString() ?? '');
    await pref.setString(PrefKey.authorization, token ?? '');
    await pref.setString(PrefKey.userName, userModel?.username ?? '');

  }

  //getting User Data from shared Preference
  // and assigning it to session controller to used it across the app
   Future<void> getUserFromPreference() async {
    try {
      var userData = pref.getString('token');


    } catch (e) {
      debugPrint(e.toString());
    }
  }


}
