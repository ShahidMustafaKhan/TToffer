import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/view_model/google_auth/google_auth_view_model.dart';
import 'package:tt_offer/view_model/login/login_view_model.dart';
import 'package:tt_offer/view_model/register/register_view_model.dart';
import 'package:tt_offer/repository/google_auth/authentication.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/google_signin_provider.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';

import '../../../Utils/widgets/others/app_button.dart';
import '../../../utils/utils.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  late AppDio myDio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    super.initState();

    myDio = AppDio(context);
    logger.init();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer3<LoginViewModel, RegisterViewModel, GoogleAuthViewModel>(
        builder: (context, loginViewModel, registerViewModel, googleAuthViewModel, child) {
          return Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: googleAuthViewModel.isSigningIn
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.appColor),
                          ),
                        )
                      : Center(
                          child: AppButton.appButtonWithLeadingImage(
                            "Continue with Google",
                            onTap: () async {

                                  // showSnackBar(context, "This feature is coming soon."  ,title: "Google Authentication");


                              googleAuthViewModel.setSigningIn(true);

                                await googleAuthViewModel
                                    .signInWithGoogle(loginViewModel, registerViewModel)
                                    .then((_) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BottomNavView(fromLogin: true),
                                    ),
                                        (route) => false,
                                  );
                                }).onError((error, stackTrace){
                                  googleAuthViewModel.setSigningIn(false);
                                  showSnackBar(context, error.toString());
                                });

                            },
                            height: 44,
                            imgHeight: 20,
                            containerWidth: 88,
                            imagePath: "assets/images/google.png",
                          ),
                        ),
                );
              }
            );
          }



}
