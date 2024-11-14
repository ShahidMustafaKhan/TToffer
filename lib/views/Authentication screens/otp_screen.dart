import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/views/Authentication%20screens/update_forgot_password.dart';

import '../../config/app_urls.dart';
import '../../main.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  String validOtp;
  OTPScreen({super.key, required this.email, required this.validOtp});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // final TextEditingController _emailController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  String enteredOTP = "";
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
                padding: const EdgeInsets.only(top: 40.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/verifyscreen.png",
                      height: 165,
                      width: 201,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                child: Container(
                  child: AppText.appText(
                      "Please type in the OTP code we sent to your email. It's an extra step to make sure it's really you and keep your account safe.",
                      textAlign: TextAlign.center,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: const Color(0xff333333)),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Verification Code Sent to ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                          text: widget.email,
                          style: TextStyle(
                              color: AppTheme.appColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: PinCodeTextField(
                  highlightAnimation: true,
                  highlight: true,
                  highlightColor: AppTheme.appColor,
                  pinBoxColor: AppTheme.white,
                  controller: textEditingController,
                  highlightAnimationEndColor: AppTheme.appColor,
                  highlightAnimationBeginColor: AppTheme.whiteColor,
                  pinBoxWidth: 40,
                  pinBoxHeight: 40,
                  highlightPinBoxColor: const Color(0xffEDEDED),
                  defaultBorderColor: const Color(0xffEDEDED),
                  hasTextBorderColor: const Color(0xffEDEDED),
                  maxLength: 6, // Set the length of your OTP
                  autofocus: false,
                  pinBoxRadius: 10,

                  onDone: (otp) {
                    log("onDone fired");

                    if (otp == widget.validOtp) {
                      showSnackBar(context, "Please set up a new password.", title: 'Password Required');
                      pushReplacement(context,
                          UpdateForgotPassordScreen(email: widget.email));
                    } else {
                      showSnackBar(
                          context, "Otp not valid, please try again... ");
                    }
                    // setState(() {
                    //   enteredOTP = otp;
                    // });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: AppButton.appButton("Verify", onTap: () {
                  if (textEditingController.text == widget.validOtp) {
                    showSnackBar(context, "Please setup new password.. ", title: 'Password Required');
                    pushReplacement(context,
                        UpdateForgotPassordScreen(email: widget.email));
                  } else {
                    showSnackBar(
                        context, "Otp not valid, please try again... ");
                  }
                },
                    height: 53,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    radius: 32.0,
                    backgroundColor: AppTheme.appColor,
                    textColor: AppTheme.whiteColor),
              ),
              Container(
                alignment: Alignment.center,
                child: AppText.appText("Didn’t Receive OTP?",
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: const Color(0xff000000)),
              ),
              GestureDetector(
                onTap: () {
                  forgotPassword();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: AppText.appText("Resend Code",
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: const Color(0xff000000)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void forgotPassword() async {
    setState(() {
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"email": widget.email};
    try {
      response = await dio.post(path: AppUrls.forgotEmailPass, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == 'error') {
          setState(() {
          });
          showSnackBar(context, responseData["message"]);

          return;
        } else if(responseData["status"] == 'success') {

          setState(() {
          });

          widget.validOtp = responseData['otp'].toString();

          showSnackBar(context, 'OTP resent successfully', title: 'Success!');


        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
      });
    }
  }


}
