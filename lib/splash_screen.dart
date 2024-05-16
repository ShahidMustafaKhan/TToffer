import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/on_boarding_screen.dart';

import 'stripe_test.dart';
import 'views/Authentication screens/login_screen.dart';
import 'views/BottomNavigation/navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? id;
  String? token;

  getUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(PrefKey.userId);
      token = prefs.getString(PrefKey.authorization);
    });
  }

  navigationFunction() async {
    await getUserCredentials();

    if (token != null) {
      Future.delayed(const Duration(seconds: 2), () {
        pushReplacement(context, const BottomNavView());
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        pushReplacement(context, const SigInScreen());
      });
    }
  }

  @override
  void initState() {
    super.initState();

    navigationFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      body: Container(
        decoration: const BoxDecoration(),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
