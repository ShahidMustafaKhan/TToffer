
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/verification/verificaiton_view_model.dart';
import 'package:tt_offer/views/Authentication%20screens/email_screen.dart';
import 'package:tt_offer/views/Authentication%20screens/phone_auth.dart';

class UpdateForgotPassordScreen extends StatefulWidget {
  final String email;
  final bool isPhone;

  const UpdateForgotPassordScreen({
    super.key,
    required this.email, this.isPhone= false,
  });

  @override
  State<UpdateForgotPassordScreen> createState() =>
      _AccountEditInfoScreenState();
}

class _AccountEditInfoScreenState extends State<UpdateForgotPassordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late VerificationViewModel verificationViewModel;

  bool loading = false;

  @override
  void initState() {
     verificationViewModel =  Provider.of<VerificationViewModel>(context, listen: false);
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar:  CustomAppBar1(
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
                    controller: passwordController,
                    borderColor: AppTheme.borderColor,
                    hintTextColor: AppTheme.hintTextColor,
                  ),
                  SizedBox(height: 15.h,),
                  AppText.appText("Confirm Password",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textColor: AppTheme.text09),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomAppFormField(
                    texthint: "",
                    controller: confirmPasswordController,
                    borderColor: AppTheme.borderColor,
                    hintTextColor: AppTheme.hintTextColor,
                  )
                ],
              ),
            ),
            Consumer<VerificationViewModel>(
                builder: (context, verificationViewModel, child) {
                  return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: verificationViewModel.loading
                      ? CircularProgressIndicator(color: AppTheme.appColor)
                      : AppButton.appButton("Change password", onTap: () {
                            updatePassword();
                        },
                          height: 53,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          radius: 32.0,
                          backgroundColor: AppTheme.appColor,
                          textColor: AppTheme.whiteColor),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  updatePassword (){
    verificationViewModel.resetPassword(widget.email, passwordController.text.trim(), confirmPasswordController.text.trim())
        .then((value){
          showSnackBar(context, "Password updated successfully.", title: 'Congratulations!');
      pushReplacement(context, widget.isPhone == false ? const EmailLoginScreen() : const PhoneLoginScreen());
    })
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString());
    });
  }

  // Future<void> updatePassword() async {
  //   Map body =
  //   widget.isPhone == false ?
  //   {"email": widget.email, "password": controller.text.trim()} :
  //   {"phone": widget.email, "password": controller.text.trim()};
  //   setState(() {
  //     loading = true;
  //   });
  //   var responce = await customPostRequest.httpPostRequest(
  //       noTokenHeader: true, url: widget.isPhone == true ? AppUrls.newPasswordPhoneUrl : AppUrls.newPasswordUrl, body: body);
  //
  //   log("responce in updatePassword  = $responce");
  //
  //   setState(() {
  //     loading = false;
  //   });
  //
  //   if (responce["status"] == "success") {
  //     showSnackBar(context, responce["msg"], title: 'Success!');
  //
  //     pushReplacement(context, widget.isPhone == false ? const EmailLoginScreen() : const PhoneLoginScreen());
  //   }
  //   else {
  //     showSnackBar(context, responce["msg"]);
  //   }
  // }
}
