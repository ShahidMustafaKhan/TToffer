import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';

class CustomLinkScreen extends StatefulWidget {
  String? link;

  CustomLinkScreen({super.key, this.link});

  @override
  State<CustomLinkScreen> createState() => _CustomLinkScreenState();
}

class _CustomLinkScreenState extends State<CustomLinkScreen> {
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linkController.text = widget.link ?? '';
  }

  void _copyText() {
    if (_linkController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _linkController.text));
      showSnackBar(context, 'Link copied', error: false);
    } else {
      showSnackBar(context, 'No link to copy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Custom Link",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: AppText.appText(
                      "This is your profile link. You can copy and share it", //Enter your custom shareable link
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.text09),
                ),
                InkWell(
                  onTap: _copyText,
                  child: CustomAppFormField(
                    height: 38.h,
                    enable: false,
                    texthint: "ttoffer.com/profile/your profile name",
                    controller: _linkController,
                    borderColor: AppTheme.borderColor,
                    hintTextColor: AppTheme.hintTextColor,
                    radius: 14.0,
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: AppButton.appButton("Copy Profile Link",
                      onTap: _copyText,
                      border: false,
                      height: 53,
                      radius: 32.0,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      backgroundColor: AppTheme.appColor,
                      textColor: AppTheme.whiteColor),
                ),
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text:
                //             "Please do not use special characters, Offensive language, or copy righted content that you do not own. We reserve the custom profile link ar any time. By tapping “Create Custom link”, you agree to TT Offer ",
                //         style: TextStyle(
                //             color: AppTheme.hintTextColor,
                //             fontSize: 10,
                //             fontWeight: FontWeight.w400),
                //       ),
                //       TextSpan(
                //         text: "Terms of Service ",
                //         style: TextStyle(
                //             color: AppTheme.appColor,
                //             fontSize: 10,
                //             fontWeight: FontWeight.w400),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 40.0),
            //   child: AppButton.appButton("Create Custom Link",
            //       onTap: () {},
            //       border: false,
            //       height: 53,
            //       radius: 32.0,
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14,
            //       backgroundColor: AppTheme.disableColor,
            //       textColor: AppTheme.whiteColor),
            // ),
          ],
        ),
      ),
    );
  }
}
