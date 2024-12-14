import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/view_model/verification/verificaiton_view_model.dart';
import 'package:tt_offer/views/Authentication%20screens/update_forgot_password.dart';

import '../../config/app_urls.dart';
import '../../main.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController textEditingController = TextEditingController();
  late VerificationViewModel verificationViewModel;
  String enteredOTP = "";

  @override
  void initState() {
    verificationViewModel = Provider.of<VerificationViewModel>(context, listen: false);

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
                    verifyOtp();

                  },
                ),
              ),
              Consumer<VerificationViewModel>(
                  builder: (context, verificationViewModel, child) {
                    return verificationViewModel.loading ?
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(child: CircularProgressIndicator()),
                    ) :
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: AppButton.appButton("Verify", onTap: () {
                      verifyOtp();
                    },
                        height: 53,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        radius: 32.0,
                        backgroundColor: AppTheme.appColor,
                        textColor: AppTheme.whiteColor),
                  );
                }
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
  void verifyOtp() async {
    verificationViewModel.forgetPasswordEmailOtpVerification(widget.email, int.tryParse(textEditingController.text))
        .then((value){
      pushReplacement(context,
          UpdateForgotPassordScreen(email: widget.email));
    }).onError((error, stackTrace) {
      showSnackBar(context, error.toString());});
  }

  void forgotPassword() async {

    verificationViewModel.forgetPasswordEmailVerification(widget.email)
        .then((value){
      showSnackBar(context, 'A verification code has been sent to your email.', title: "Congratulations!");})
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString());
    });

  }

}
