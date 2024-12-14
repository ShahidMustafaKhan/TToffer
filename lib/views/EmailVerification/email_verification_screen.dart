import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/utils/widgets/others/custom_app_bar.dart';

import '../../view_model/profile/user_profile/user_view_model.dart';
import '../../view_model/verification/verificaiton_view_model.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  late VerificationViewModel verificationViewModel;



  bool loading = false;
  bool enterOtp = false;



  Future<void> emailVerification() async {

    verificationViewModel.verifyEmail(emailController.text.trim())
        .then((value){
          setState(() {
            enterOtp = true;
          });
          showSnackBar(context, 'A verification code has been sent to your email.', title: "Congratulations!");})
        .onError((error, stackTrace) {
          showSnackBar(context, error.toString());
    });

  }

  verifyEmailHandler() async {
    verificationViewModel.verifyEmailOtp(emailController.text.trim(), int.tryParse(otpController.text))
        .then((value){
          Provider.of<UserViewModel>(context, listen: false).getUserProfile();
          Navigator.of(context).pop();
      showSnackBar(context, 'Email verified successfully.', title: "Congratulations!");})
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString());});
    }


  @override
  void initState() {
    super.initState();

    verificationViewModel = Provider.of<VerificationViewModel>(context, listen: false);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<UserViewModel>(context, listen: false).getUserProfile();
        return true; // Allow the pop action
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(title: 'Email Verification'),
        body: SafeArea(
          child: Center(
            child: enterOtp == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/mail.jpg',
                        scale: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: AppText.appText("Your Email",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              textColor: AppTheme.text09),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CustomAppFormField(
                          texthint: "Email",
                          controller: emailController,
                          borderColor: AppTheme.borderColor,
                          hintTextColor: AppTheme.hintTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<VerificationViewModel>(
                          builder: (context, verificationViewModel, child) {
                            return verificationViewModel.loading
                                ? CircularProgressIndicator(color: AppTheme.appColor)
                                : ElevatedButton(
                              onPressed: emailVerification,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.appColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Submit',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          })



                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/mail.jpg',
                        scale: 1.5,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Please enter the 6 digit code sent to\n',
                          style: const TextStyle(color: Colors.black),
                          // Normal text style
                          children: <TextSpan>[
                            TextSpan(
                              text: emailController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold), // Bold style for emailController.text
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 19.0, vertical: 10),
                        child: Pinput(length: 6, controller: otpController),
                      ),
                      const SizedBox(height: 10),
                      Consumer<VerificationViewModel>(
                          builder: (context, verificationViewModel, child) {
                            return verificationViewModel.loading
                                ? CircularProgressIndicator(color: AppTheme.appColor)
                                : ElevatedButton(
                              onPressed: () {
                                verifyEmailHandler();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.appColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Verify Now',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          }),


                    ],
                  ), // Display OTP when available
          ),
        ),
      ),
    );
  }
}
