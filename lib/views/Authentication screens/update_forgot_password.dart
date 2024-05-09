import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/views/Authentication%20screens/email_screen.dart';

class UpdateForgotPassordScreen extends StatefulWidget {
  final String email;

  const UpdateForgotPassordScreen({
    super.key,
    required this.email,
  });

  @override
  State<UpdateForgotPassordScreen> createState() =>
      _AccountEditInfoScreenState();
}

class _AccountEditInfoScreenState extends State<UpdateForgotPassordScreen> {
  TextEditingController controller = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dio = AppDio(context);
        final profileApi =
            Provider.of<ProfileApiProvider>(context, listen: false);
        await profileApi.getProfile(
          dio: dio,
          context: context,
        );
        return true; // Allow the pop action
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: const CustomAppBar1(
          title: "Change Password",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.appText("New Password",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.text09),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomAppFormField(
                      texthint: "",
                      controller: controller,
                      borderColor: AppTheme.borderColor,
                      hintTextColor: AppTheme.hintTextColor,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: loading
                    ? CircularProgressIndicator(color: AppTheme.appColor)
                    : AppButton.appButton("Change password", onTap: () {
                        if (controller.length < 8) {
                          showSnackBar(context,
                              "Password must be of atleast 8 characters");
                        } else {
                          updatePassword();
                        }
                      },
                        height: 53,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        radius: 32.0,
                        backgroundColor: AppTheme.appColor,
                        textColor: AppTheme.whiteColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatePassword() async {
    Map body = {"email": widget.email, "password": controller.text.trim()};
    setState(() {
      loading = true;
    });
    var responce = await customPostRequest.httpPostRequest(
        noTokenHeader: true, url: AppUrls.newPasswordUrl, body: body);

    log("responce in updatePassword  = $responce");

    setState(() {
      loading = false;
    });

    if (responce["status"] == "success") {
      showSnackBar(context, responce["msg"]);

      pushReplacement(context, const EmailLoginScreen());
    }
  }
}
