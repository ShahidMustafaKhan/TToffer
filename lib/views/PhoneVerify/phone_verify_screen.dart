import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/update_account_service.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import '../../Constants/app_logger.dart';
import '../../Utils/utils.dart';
import '../../config/app_urls.dart';
import '../../config/dio/app_dio.dart';

class PhoneVerifyScreen extends StatefulWidget {
  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  // final TextEditingController  = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool otpField = false;

  String verificationId = '';

  var userId;
  late AppDio dio;
  AppLogger logger = AppLogger();

  bool loading = false;

  late UserViewModel userViewModel;



  phoneVerifyHandler() async {
    setState(() {
      loading = true;
    });
    await UpdateAccountSettingService()
        .updatePhoneService(context: context, phone: _phoneNumberController.text, userViewModel: userViewModel);
    confirmPhoneVerification();

    setState(() {
      loading = false;
    });
  }

  void forgotPasswordPhone(String phoneNumber) async {
    setState(() {
      loading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {"phone": phoneNumber};
    try {
      response = await dio.post(path: AppUrls.verifyPhone, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          loading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          loading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          loading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          loading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          loading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == 'error') {
          setState(() {
            loading = false;
          });
          showSnackBar(context, responseData["message"]);

          return;
        } else if(responseData["status"] == 'success') {

          setState(() {
            loading = false;
            otpField = true;
          });

        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        loading = false;
      });
    }
  }


  otpVerification(String code, String phoneNumber) async {
    setState(() {
      loading = true;
    });
    var response;

    Map<String, dynamic> params = {"phone": phoneNumber, "code" : code};
    try {
      response = await dio.post(path: AppUrls.verifyPhoneOtp, data: params);
      var responseData = response.data;
      if (responseData["status"] ==  "error") {
        setState(() {
          loading = false;
        });

        showSnackBar(
            context, responseData["msg"]);

        return;
      } else {
        setState(() {
          loading = false;
        });
        phoneVerifyHandler();
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        loading = false;
      });
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.userId);
    });
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: _otpController.text);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential);
      phoneVerifyHandler();
    }
    catch(e){
      showSnackBar(context, e.toString().replaceAll(RegExp(r'\[.*?\]'), ''));
    }
    // Handle the sign-in completion
  }


  TextEditingController _phoneNumberController = TextEditingController();

  Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKey.phoneFirebase, phoneNumber);
  }

  confirmPhoneVerification() async{
    dio = AppDio(context);
    logger.init();

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);


    UpdateAccountSettingService().updatePhoneService(
      context: context,
      phone: _phoneNumberController.text.trim(), userViewModel: userViewModel,
     ).then((value) {
      userViewModel.updateVerification(
        userId, verifyPhone: true,
       ).then((value) => Navigator.of(context).pop()
       );
     }
     );

  }


   @override
  void initState() {
     dio = AppDio(context);
     logger.init();
     userViewModel = Provider.of<UserViewModel>(context, listen: false);
     getUserDetail();
     _phoneNumberController.text = "+971";
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar1(
        title: 'Phone Authentication',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: otpField == true
              ? Column(
                  children: [
                    const SizedBox(height: 20.0),

                    Pinput(
                      controller: _otpController,
                      length: 6,
                    ),
                    //
                    // TextField(
                    //   controller: _otpController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     hintText: 'Enter OTP',
                    //   ),
                    // ),
                    const SizedBox(height: 20.0),
                    loading
                        ? CircularProgressIndicator(color: AppTheme.appColor)
                        : AppButton.appButton('Verify',
                            height: 50,
                            textColor: Colors.white,
                            backgroundColor: AppTheme.appColor,
                            onTap: (){otpVerification(_otpController.text, _phoneNumberController.text);})
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    phoneField(controller: _phoneNumberController, context: context),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: AppTheme.borderColor),
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: InternationalPhoneNumberInput(
                    //       spaceBetweenSelectorAndTextField: 1,
                    //       inputDecoration:
                    //           const InputDecoration(border: InputBorder.none),
                    //       inputBorder: const OutlineInputBorder(),
                    //       onInputChanged: (PhoneNumber number) {
                    //         _phoneNumberController = number.phoneNumber;
                    //         print('phone--->$_phoneNumberController');
                    //       },
                    //       selectorConfig: const SelectorConfig(
                    //         selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    //       ),
                    //       initialValue: PhoneNumber(
                    //           isoCode: 'PK'), // Default country is Pakistan
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 40.h,),
                    loading
                        ? CircularProgressIndicator(color: AppTheme.appColor)
                        : AppButton.appButton('Verify Phone Number',
                            textColor: Colors.white,
                            backgroundColor: AppTheme.appColor,
                            height: 50,
                            onTap: (){
                          showSnackBar(context, 'This feature is temporarily unavailable due to the unavailability of the Twilio service.');


                          // forgotPasswordPhone(_phoneNumberController.text);
                        }),
                  ],
                ),
        ),
      ),
    );
  }



}
