import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/View/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  String? id;
  String? token;

  @override
  void initState() {
    getUserCredentials();
    super.initState();
  }

  void getUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString(PrefKey.userId);
      token = prefs.getString(PrefKey.authorization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                AppText.appText("WELCOME TO TT OFFER",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    textColor: AppTheme.blackColor),
                const SizedBox(
                  height: 10,
                ),
                AppText.appText("Discover, chat, bid, and shop with ease",
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w300,
                    textColor: AppTheme.blackColor),
              ],
            ),
            Image.asset("assets/images/onBorad.png"),
            AppButton.appButton("Get Started", onTap: () {
              if (token != null) {
                pushReplacement(context, const BottomNavView());
              } else {
                pushReplacement(context, const SigInScreen());
              }
            },
                height: 53,
                radius: 32.0,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                backgroundColor: AppTheme.appColor,
                textColor: AppTheme.whiteColor)
          ],
        ),
      ),
    );
  }
}
