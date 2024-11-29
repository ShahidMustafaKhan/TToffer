import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

import '../../view_model/login/login_view_model.dart';
import '../Profile Screen/Settings/privacy_policy.dart';
import '../Profile Screen/Settings/terms_and_condition.dart';
import 'forgot_email.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    _phoneController.text = "+971";
    super.initState();
  }

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
                padding: const EdgeInsets.only(top: 50.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/newLogin.png",
                      height: 165,
                      width: 201,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: AppText.appText("Phone",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff090B0C)),
              ),
              phoneField(controller: _phoneController, context: context),
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
                  push(context, const ForgotEmailPass(phone: true,));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppText.appText("Forgot Password?",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppTheme.txt1B20),
                ),
              ),
              SizedBox(height: 20.h),

              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By logging in I agree to the ',
                      style: TextStyle(color: AppTheme.hintTextColor, fontFamily: 'Poppins', fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              push(context, const TermsAndCondition());


                            },
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(color: AppTheme.hintTextColor,  fontFamily: 'Poppins'),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              push(context, PrivacyPolicyScreen());
                            },
                        ),])),
              Consumer<LoginViewModel>(
                  builder: (context, provider, child){
                    return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: provider.loginLoading == true
                        ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.appColor,
                      ),
                    )
                        : AppButton.appButton("Sign In", onTap: () {
                      if (_phoneController.text.isNotEmpty) {
                        if (_passwordController.text.isNotEmpty) {

                          Map<String, dynamic> data = {
                            "phone": _phoneController.text,
                            "password": _passwordController.text
                          };

                          provider.loginApiWithPhone(data).then((value){
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavView(fromLogin : true),
                                ),
                                    (route) => false);
                          }).onError((error, stackTrace){
                            showSnackBar(context, error.toString());
                          });
                        } else {
                          showSnackBar(context, "Enter Password");
                        }
                      } else {
                        showSnackBar(context, "Enter Phone");
                      }
                    },
                        height: 53,
                        radius: 32.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        backgroundColor: AppTheme.appColor,
                        textColor: AppTheme.whiteColor),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }


}
