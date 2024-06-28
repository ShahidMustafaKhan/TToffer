import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/custom_requests/update_account_service.dart';
import 'package:tt_offer/models/otp_model.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/utils/resources/res/app_theme.dart';
import 'package:tt_offer/utils/widgets/others/custom_app_bar.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool loading = false;
  OtpModel? otpModel;

  Future<void> emailVerification() async {
    try {
      setState(() {
        loading = true;
      });

      Map<String, dynamic> body = {'email': emailController.text.trim()};

      var res = await CustomPostRequest()
          .httpPostRequest(url: 'verify-email', body: body);

      setState(() {
        loading = false;
      });

      if (res['status'] == 'success') {
        showSnackBar(context, 'Email Verification OTP sent to your email');
        // Assuming you have logic to update otpModel with the received OTP
        setState(() {
          otpModel = OtpModel(
              otp: res['otp']); // Update otpModel with the received OTP
        });
      } else {
        showSnackBar(context, 'The email field must be a valid email address');
      }
    } catch (err) {
      print('Error: $err');
      showSnackBar(context, 'Error occurred: $err');
      setState(() {
        loading = false;
      });
    }
  }

  verifyEmailHandler() async {
    setState(() {
      loading = true;
    });
    bool res = await UpdateAccountSettingService()
        .verifyEmail(context: context, email: emailController.text);
    if (res) {
      showSnackBar(context, 'Email verify successfully');
    }
    setState(() {
      loading = false;
    });
  }

  late AppDio dio;
  AppLogger logger = AppLogger();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dio = AppDio(context);
        logger.init();
        final profileApi =
            Provider.of<ProfileApiProvider>(context, listen: false);
        await profileApi.getProfile(
          dio: dio,
          context: context,
        );
        // getUserDetail();
        return true; // Allow the pop action
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(title: 'Email Verification'),
        body: SafeArea(
          child: Center(
            child: otpModel == null || otpModel!.otp == null
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
                      loading
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
                            ),
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
                      loading
                          ? CircularProgressIndicator(color: AppTheme.appColor)
                          : ElevatedButton(
                              onPressed: () {
                                if (otpController.text ==
                                    otpModel!.otp.toString()) {
                                  verifyEmailHandler();
                                } else {
                                  showSnackBar(context, 'Enter correct otp');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.appColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Verify Now',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                    ],
                  ), // Display OTP when available
          ),
        ),
      ),
    );
  }
}
