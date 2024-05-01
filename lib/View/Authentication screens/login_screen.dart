import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/View/Authentication%20screens/GoogleSignIn/google_sign_in_button.dart';
import 'package:tt_offer/View/Authentication%20screens/email_screen.dart';
import 'package:tt_offer/View/Authentication%20screens/phone_auth.dart';
import 'package:tt_offer/View/Authentication%20screens/registration_screen.dart';

class SigInScreen extends StatefulWidget {
  const SigInScreen({super.key});

  @override
  State<SigInScreen> createState() => _SigInScreenState();
}

class _SigInScreenState extends State<SigInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: AppText.appText("Sign up / Log in",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xff1B2028)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(
                "assets/images/cross.png",
                height: 20,
                width: 20,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const GoogleSignInButton(),
                  AppButton.appButtonWithLeadingImage("Continue with Apple",
                      onTap: () {},
                      height: 44,
                      imgHeight: 40,
                      imagePath: "assets/images/apple.png"),
                  AppButton.appButtonWithLeadingImage("Continue with Phone",
                      onTap: () {
                    push(context, const PhoneLoginScreen());
                  },
                      height: 44,
                      imgHeight: 20,
                      imagePath: "assets/images/call.png"),
                  AppButton.appButtonWithLeadingImage("Continue with Email",
                      onTap: () {
                    push(context, const EmailLoginScreen());
                  },
                      height: 44,
                      imgHeight: 20,
                      imagePath: "assets/images/sms.png"),
                  GestureDetector(
                    onTap: () {
                      push(context, const RegistrationScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.appText("Don't have an account?",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.txt1B20),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText.appText("Register",
                            fontSize: 12,
                            underLine: true,
                            fontWeight: FontWeight.w400,
                            textColor: AppTheme.appColor),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "By moving forward, you're agreeing to our ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Terms of Service ",
                      style: TextStyle(
                        color: AppTheme.appColor, // Set the c AppTheme.appColor
                      ),
                    ),
                    const TextSpan(
                      text: "and recognizing that you've checked out our ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                        color: AppTheme.appColor, // Set the color to green
                      ),
                    ),
                    const TextSpan(
                      text: " to understand how we handle your information.",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
