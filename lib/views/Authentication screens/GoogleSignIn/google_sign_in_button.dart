import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/views/Authentication%20screens/GoogleSignIn/authentication.dart';
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
    // TODO: implement initState
    super.initState();

    myDio = AppDio(context);
    logger.init();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider =
        Provider.of<GoogleSignInProvider>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: googleSignInProvider.isSigningIn
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.appColor),
              ),
            )
          : Center(
              child: AppButton.appButtonWithLeadingImage(
                "Continue with Google",
                onTap: () async {
                  googleSignInProvider.setSigningIn(true);
                  // setState(() {
                  //   _isSigningIn = true;
                  // });

                  try {
                    await Authentication.initializeFirebase(context: context);
                    print("initialize");
                    await Authentication.signInWithGoogle(context: context);
                    isAlready == true || isRegister == true
                        ? await signIn()
                        : await register();
                    print("registerUser");

                    googleSignInProvider.setSigningIn(false);
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const BottomNavView(),
                    //     ),
                    //     (route) => false);

                    if (isAlready) {
                      showSnackBar(context, 'Login Successfully');
                    } else {
                      showSnackBar(context, 'Register Successfully');
                    }
                  } catch (e) {
                    googleSignInProvider.setSigningIn(false);
                    print("fbjkbfjeblfbekb$e");
                  }
                },
                height: 44,
                imgHeight: 20,
                imagePath: "assets/images/google.png",
              ),
            ),
    );
  }

  bool _isLoading = false;

  Future<void> register() async {
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For data not found.
    int responseCode422 = 422; // For data validation errors.
    int responseCode500 = 500; // Internal server error.

    Map<String, dynamic> params = {
      "name": "${userCredential!.user!.displayName}",
      "email": userCredential!.user!.email,
      "username": userCredential!.user!.displayName,
      "password": userCredential!.user!.email,
      "phone": '+923214567899', // Example phone number.
    };

    try {
      response = await myDio.post(path: AppUrls.registration, data: params);
      var responseData = response.data;

      if (responseData != null) {
        if (responseData["status"] == 'error') {
          await signIn();
        }

        if (response.statusCode == responseCode400) {
          // showSnackBar(context, "${responseData["message"]}");
        } else if (response.statusCode == responseCode401) {
          // showSnackBar(context, "${responseData["message"]}");
        } else if (response.statusCode == responseCode404) {
          // showSnackBar(context, "${responseData["message"]}");
        } else if (response.statusCode == responseCode500) {
          showSnackBar(context, "${responseData["message"]}");
        } else if (response.statusCode == responseCode422) {
          // Handle data validation errors if needed.
        } else if (response.statusCode == responseCode200) {
          if (responseData["status"] == false) {
            showSnackBar(
                context, "Registration failed: ${responseData["message"]}");
          } else {
            var userId = responseData["data"]["user"]["id"];
            var token = responseData["data"]["token"];
            var id = userId.toString();

            // Save data to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(PrefKey.userId, id ?? '');
            prefs.setString(PrefKey.authorization, token ?? '');

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavView(),
              ),
              (route) => false,
            );
          }
        } else {
          showSnackBar(context, "Unexpected server response.");
        }
      } else {
        showSnackBar(context, "Empty response from server.");
      }
    } catch (e) {
      print("Error during registration: $e");
      showSnackBar(context, "Something went wrong. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false; // Update loading state.
      });
    }
  }

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "email": userCredential!.user!.email,
      "password": userCredential!.user!.email
    };

    print('body--->${params}');

    try {
      response = await dio.post(path: AppUrls.logInEmail, data: params);
      var responseData = response.data;
      print("object${responseData}");
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        if (response.statusCode == responseCode401) {
          // authMessage = 'alreadyExists';
        }

        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            _isLoading = false;
          });
          var userId = responseData["data"]["user"]["id"];
          var token = responseData["data"]["token"];
          var name = responseData["data"]["name"];
          var id = userId.toString();
          print("id$id");
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          pref.setString(PrefKey.userId, id ?? '');
          pref.setString(PrefKey.authorization, token ?? '');
          pref.setString(PrefKey.userName, name ?? '');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavView(),
              ),
              (route) => false);
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
