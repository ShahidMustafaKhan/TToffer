import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';

class AccountEditInfoScreen extends StatefulWidget {
  final title;
  final lable;
  final infoText;
  final email;
  final password;
  final location;
  const AccountEditInfoScreen({
    super.key,
    this.title,
    this.lable,
    this.infoText,
    this.email,
    this.password,
    this.location,
  });

  @override
  State<AccountEditInfoScreen> createState() => _AccountEditInfoScreenState();
}

class _AccountEditInfoScreenState extends State<AccountEditInfoScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "${widget.title}",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.appText("${widget.lable}",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.text09),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomAppFormField(
                    texthint: "${widget.infoText}",
                    controller: controller,
                    borderColor: AppTheme.borderColor,
                    hintTextColor: AppTheme.hintTextColor,
                  )
                ],
              ),
            ),
            if(widget.password == true)
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
              child: AppButton.appButton(
                  widget.email == true
                      ? "Change Email"
                      : widget.password == true
                          ? "Change password"
                          : widget.location == true
                              ? "Update Location"
                              : "Update", onTap: () {
                push(context, const BottomNavView());
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
    );
  }
}
