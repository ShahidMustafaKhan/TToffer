import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/Authentication%20screens/GoogleSignIn/forgot_email.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        context: context,
        title: "Email",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/email.png",
                      height: 165,
                      width: 201,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: AppText.appText("Email",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff090B0C)),
              ),
              CustomAppFormField(
                texthint: "Email",
                controller: _emailController,
                hintTextColor: const Color(0xff939699),
                borderColor: const Color(0xffE5E9EB),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: AppText.appText("Password",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff090B0C)),
              ),
              CustomAppPasswordfield(
                texthint: "Password",
                controller: _passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  push(context, const ForgotEmailPass());
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppText.appText("Forgot Password?",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.txt1B20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.appColor,
                        ),
                      )
                    : AppButton.appButton("Sign In", onTap: () {
                        _emailController.text =
                            _emailController.text.replaceAll(' ', '');

                        if (_emailController.text.isNotEmpty) {
                          final emailPattern =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailPattern.hasMatch(_emailController.text)) {
                            showSnackBar(
                                context, "Please enter a valid email address");
                          } else {
                            if (_passwordController.text.isNotEmpty) {
                              signIn();
                            } else {
                              showSnackBar(context, "Enter Password");
                            }
                          }
                        } else {
                          showSnackBar(context, "Enter Email");
                        }
                      },
                        height: 53,
                        radius: 32.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        backgroundColor: AppTheme.appColor,
                        textColor: AppTheme.whiteColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
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
      "email": _emailController.text,
      "password": _passwordController.text
    };
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
          var id = userId.toString();
          print("id$id");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefKey.userId, id ?? '');
          prefs.setString(PrefKey.authorization, token ?? '');

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
