import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/views/Authentication%20screens/otp_screen.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

import '../../view_model/verification/verificaiton_view_model.dart';
import 'otp_phone_screen.dart';

class ForgotEmailPass extends StatefulWidget {
  final bool phone;
  const ForgotEmailPass({super.key, this.phone=false});

  @override
  State<ForgotEmailPass> createState() => _ForgotEmailPassState();
}

class _ForgotEmailPassState extends State<ForgotEmailPass> {
  final TextEditingController _emailController = TextEditingController();


  late VerificationViewModel verificationViewModel;
  bool _isLoading = false;

  @override
  void initState() {
    verificationViewModel = Provider.of<VerificationViewModel>(context, listen: false);

    if(widget.phone == true){
      _emailController.text = "+971";
    }
    super.initState();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        context: context,
        title: widget.phone ? 'Phone' : "Email",
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
                child: AppText.appText(widget.phone ? 'Phone' : "Email",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff090B0C)),
              ),

              if(widget.phone == false)
              CustomAppFormField(
                texthint: widget.phone ? 'Add phone number' : "Email",
                controller: _emailController,
                type: widget.phone ? TextInputType.phone : TextInputType.emailAddress,
                hintTextColor: const Color(0xff939699),
                borderColor: const Color(0xffE5E9EB),
              ),

              if(widget.phone == true)
                phoneField(controller: _emailController, context: context),

              Consumer<VerificationViewModel>(
                  builder: (context, verificationViewModel, child) {
                    return verificationViewModel.loading == true
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.appColor,
                        ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: AppButton.appButton("Send OTP", onTap: () {
                        if(widget.phone == false) {
                          if (_emailController.text.isNotEmpty) {
                            final emailPattern =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailPattern.hasMatch(_emailController.text)) {
                              showSnackBar(
                                  context, "Please enter a valid email address",
                                  title: 'Input Required');
                            } else {
                              forgotPassword();
                            }
                          } else {
                            showSnackBar(context, "Enter Email");
                          }
                        }
                        else{
                          if (_emailController.text.isNotEmpty) {
                            // Adjust this pattern based on your specific phone number format requirements
                            final phonePattern = RegExp(r'^\+?[1-9]\d{1,14}$');
                            if (!phonePattern.hasMatch(_emailController.text)) {
                              showSnackBar(
                                  context,
                                  "Please enter a valid phone number",
                                  title: 'Input Required'
                              );
                            } else {
                              // Proceed with your phone number-related function
                              forgotPasswordPhone();
                            }
                          }
                          else {
                            showSnackBar(context, "Phone number required");
                          }
                        }
                      },
                          height: 53,
                          radius: 32.0,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          backgroundColor: AppTheme.appColor,
                          textColor: AppTheme.whiteColor),
                    );}),
            ],
          ),
        ),
      ),
    );
  }

  void forgotPassword() async {

    verificationViewModel.forgetPasswordEmailVerification(_emailController.text.trim())
        .then((value){
      pushReplacement(
          context,
          OTPScreen(
            email: _emailController.text.trim(),
          ));
      showSnackBar(context, 'A verification code has been sent to your email.', title: "Congratulations!");})
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString());
    });

  }

  void forgotPasswordPhone() async {

    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"phone": _emailController.text};
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

          pushReplacement(
              context,
              OTPPhoneScreen(
                phoneNumber: _emailController.text,
              ));
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
