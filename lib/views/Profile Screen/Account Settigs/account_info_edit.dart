import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/custom_requests/update_account_service.dart';
import 'package:tt_offer/main.dart';

import '../../../view_model/profile/user_profile/user_view_model.dart';

class AccountEditInfoScreen extends StatefulWidget {
  final title;
  final userName;
  final lable;
  final infoText;
  final email;
  final password;
  String? emailSt;
  final location;

  AccountEditInfoScreen({
    super.key,
    this.title,
    this.userName,
    this.lable,
    this.infoText,
    this.email,
    this.password,
    this.emailSt,
    this.location,
  });

  @override
  State<AccountEditInfoScreen> createState() => _AccountEditInfoScreenState();
}

class _AccountEditInfoScreenState extends State<AccountEditInfoScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  late UserViewModel userViewModel;

  bool loading = false;

  updateNameHandler() async {
    setState(() {
      loading = true;
    });

     await UpdateAccountSettingService().updateProfileNameService(
      context: context,
      name: controller.text, userViewModel: userViewModel,
    );

    setState(() {
      loading = false;
    });
  }

  updateEmailHandler() async {
    setState(() {
      loading = true;
    });
    await UpdateAccountSettingService()
        .updateEmailService(context: context, email: controller.text, userViewModel: userViewModel);


    setState(() {
      loading = false;
    });
  }

  updateLocationHandler() async {
    final RegExp locationPattern = RegExp(r'^.+,.+$');

    // Check if the location matches the pattern
    if (!locationPattern.hasMatch(controller.text)) {
      // Show SnackBar if the format is incorrect
      showSnackBar(context, 'Please enter full location.');
      return;
    }

    setState(() {
      loading = true;
    });
     await UpdateAccountSettingService()
        .updateLocationService(context: context, location: controller.text, userViewModel: userViewModel);

     await pref.setString('myLocation', controller.text);


    setState(() {
      loading = false;
    });
  }

  updatePasswordHandler() async {
    setState(() {
      loading = true;
    });
    await UpdateAccountSettingService().updatePasswordService(
        context: context, newPassword: controller.text, oldPassword: oldPasswordController.text, userViewModel: userViewModel);

    setState(() {
      loading = false;
    });
  }

  var userId = pref.getString(PrefKey.userId);
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  Widget build(BuildContext context) {

    userViewModel =  Provider.of<UserViewModel>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {

        await userViewModel.getUserProfile();
        return true; // Allow the pop action
      },
      child: Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(
          title: "${widget.title}",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: widget.password == true ? 0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.password == true
                        ? const SizedBox.shrink()
                        : AppText.appText("${widget.lable}",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: AppTheme.text09),
                    SizedBox(
                      height: widget.password == true ? 0 : 10,
                    ),
                    widget.password == true
                        ? const SizedBox.shrink()
                        : CustomAppFormField(
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.appText("Old Password",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor: AppTheme.text09),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomAppFormField(
                        texthint: "",
                        controller: oldPasswordController,
                        borderColor: AppTheme.borderColor,
                        hintTextColor: AppTheme.hintTextColor,
                      ),
                      SizedBox(height: 16.h,),
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
                      ),
                      SizedBox(height: 7.h,)
                    ],
                  ),
                ),
              Consumer<UserViewModel>(
                  builder: (context, userViewModel, child) {
                    return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: userViewModel.updateProfileLoading
                        ? CircularProgressIndicator(color: AppTheme.appColor)
                        : AppButton.appButton(
                            widget.email == true
                                ? "Change Email"
                                : widget.password == true
                                    ? "Change password"
                                    : widget.location == true
                                        ? "Update Location"
                                        : "Update", onTap: () {
                            widget.userName == true
                                ? updateNameHandler()
                                : widget.email == true
                                    ? updateEmailHandler()
                                    : widget.location == true
                                        ? updateLocationHandler()
                                        : widget.password == true
                                            ? updatePasswordHandler()
                                            : null;
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
      ),
    );
  }
}
