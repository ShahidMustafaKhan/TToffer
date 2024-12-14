import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/on_boarding_screen.dart';
import 'package:tt_offer/views/Products/Feature%20Product/feature_info.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';

import 'Constants/app_logger.dart';
import 'view_model/banner/banner_view_model.dart';
import 'config/dio/app_dio.dart';
import 'custom_requests/firebase_messaging_service.dart';
import 'main.dart';
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
        pushReplacement(context, const BottomNavView(fromLogin : true));
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        pushReplacement(context, const BottomNavView(fromLogin : true));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    backgroundNotification();


  }

  backgroundNotification() async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if(notificationAppLaunchDetails?.didNotificationLaunchApp ?? false){
      final selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse!.payload;
      pushReplacement(
                    context,
                    FeatureInfoScreen(
                      fromDynamicLink: true,
                      productId: "91",
                    )) ;
    }
    else{
      FirebaseDynamicLinks.instance.getInitialLink().then((PendingDynamicLinkData? data) {
        final Uri? deepLink = data?.link;
        if (deepLink != null) {
          final productId = deepLink.queryParameters['productId'];
          final productType = deepLink.queryParameters['productType'];

          if (productId != null && productType != null) {
            Future.delayed(const Duration(seconds: 2), () {
              pushReplacement(
                context,
                productType == 'featured' ?
                FeatureInfoScreen(
                  fromDynamicLink: true,
                  popToBottomNav: true,
                  productId: productId.toString(),
                ) : AuctionInfoScreen(
                  fromDynamicLink: true,
                  popToBottomNav: true,
                  productId: productId.toString(),
                ),
              );
            });
          }
        } else {
          navigationFunction();
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              child: Image.asset(
                "assets/images/newFrame.png",
                // fit: BoxFit.cover,
                height: 120.w,
                width: 120.w,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Text(
                  ' Time The Offer',
                  style:TextStyle(
                    fontFamily:'FranklinGothic',
                    color: AppTheme.appColor, // Dark Blue
                    fontSize: 28.sp,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
