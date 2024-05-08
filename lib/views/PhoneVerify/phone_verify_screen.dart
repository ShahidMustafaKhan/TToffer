import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/update_account_service.dart';

class PhoneVerifyScreen extends StatefulWidget {
  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  // final TextEditingController  = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool otpField = false;

  String verificationId = '';

  bool loading = false;

  phoneVerifyHandler() async {
    setState(() {
      loading = true;
    });
    await UpdateAccountSettingService()
        .updatePhoneService(context: context, phone: _phoneNumberController!);

    setState(() {
      loading = false;
    });
  }

  Future<void> verifyPhoneNumber() async {
    try {
      setState(() {
        loading = true;
      });
      verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

        // await savePhoneNumber(_phoneNumberController!);

        // Handle the sign-in completion
      }

      verificationFailed(FirebaseAuthException authException) {
        print('Phone verification failed: ${authException.message}');
        // Show snackbar for verification failure
        showSnackbar('Phone verification failed: ${authException.message}');
      }

      codeSent(String verificationId, [int? forceResendingToken]) async {
        this.verificationId = verificationId;
        // Handle the code sent
      }

      codeAutoRetrievalTimeout(String verificationId) {
        this.verificationId = verificationId;
        // Handle timeout
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      print('otp---->${otpField}');
      setState(() {
        otpField =
            true; // Set otpField to true only when verification is completed
      });

      setState(() {
        loading = false;
      });
    } catch (err) {
      print('err--->${err}');
      // Show snackbar for other errors
      showSnackbar('Error occurred: $err');
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithPhoneNumber() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: _otpController.text);
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    phoneVerifyHandler();
    // Handle the sign-in completion
  }

  String? _phoneNumberController;

  Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKey.phoneFirebase, phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar1(
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
                        : AppButton.appButton('Sign In',
                            height: 50,
                            backgroundColor: AppTheme.appColor,
                            onTap: signInWithPhoneNumber)
                    // ElevatedButton(onPressed: phoneVerifyHandler, child: Text('sddsad'))
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: InternationalPhoneNumberInput(
                          spaceBetweenSelectorAndTextField: 1,
                          inputDecoration:
                              const InputDecoration(border: InputBorder.none),
                          inputBorder: const OutlineInputBorder(),
                          onInputChanged: (PhoneNumber number) {
                            _phoneNumberController = number.phoneNumber;
                            print('phone--->$_phoneNumberController');
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          initialValue: PhoneNumber(
                              isoCode: 'PK'), // Default country is Pakistan
                        ),
                      ),
                    ),

                    // TextField(
                    //   controller: _phoneNumberController,
                    //   keyboardType: TextInputType.phone,
                    //   decoration: const InputDecoration(
                    //     hintText: 'Enter phone number',
                    //   ),
                    // ),
                    const Spacer(),
                    loading
                        ? CircularProgressIndicator(
                            color: AppTheme.appColor)
                        : AppButton.appButton('Verify Phone Number',
                            backgroundColor: AppTheme.appColor,
                        height: 50,

                        onTap: verifyPhoneNumber),
                  ],
                ),
        ),
      ),
    );
  }
}
