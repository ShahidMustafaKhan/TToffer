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

class OTPPhoneScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPPhoneScreen({super.key, required this.phoneNumber});

  @override
  State<OTPPhoneScreen> createState() => _OTPPhoneScreenState();
}

class _OTPPhoneScreenState extends State<OTPPhoneScreen> {
  // final TextEditingController _emailController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  String enteredOTP = "";

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        context: context,
        title: "Phone",
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
                      "Please type in the OTP code we sent to your phone number. It's an extra step to make sure it's really you and keep your account safe.",
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
                          text: widget.phoneNumber,
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

                    otpVerification(otp);

                    // setState(() {
                    //   enteredOTP = otp;
                    // });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: AppButton.appButton("Verify", onTap: () {
                  otpVerification(textEditingController.text);
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
                  forgotPasswordPhone();
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

  otpVerification(String code) async {
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
      Map<String, dynamic> params = {"phone": widget.phoneNumber, "code" : code};
      try {
        response = await dio.post(path: AppUrls.verifyPhoneOtp, data: params);
        var responseData = response.data;
          if (responseData["status"] ==  "error") {
            setState(() {
              _isLoading = false;
            });

            showSnackBar(
                context, responseData["msg"]);

            return;
          } else {
            setState(() {
              _isLoading = false;
            });
            showSnackBar(context, 'Otp Verified Successfully', title: 'Success!');
            pushReplacement(context,
                UpdateForgotPassordScreen(email: widget.phoneNumber , isPhone: true,));
          }
      } catch (e) {
        print("Something went Wrong ${e}");
        showSnackBar(context, "Something went Wrong.");
        setState(() {
          _isLoading = false;
        });
      }
    }

  void forgotPasswordPhone() async {
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
    Map<String, dynamic> params = {"phone": widget.phoneNumber};
    try {
      response = await dio.post(path: AppUrls.forgotPhonePass, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == 'error') {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(context, responseData["message"]);

          return;
        } else if(responseData["status"] == 'success') {

          setState(() {
            _isLoading = false;
          });

          showSnackBar(context, 'OTP resent successfully', title: 'Success!');


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
