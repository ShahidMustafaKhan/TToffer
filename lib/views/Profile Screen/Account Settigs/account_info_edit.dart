import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
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
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';

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

  bool loading = false;

  updateNameHandler() async {
    setState(() {
      loading = true;
    });
    var res = await UpdateAccountSettingService().updateProfileNameService(
      context: context,
      name: controller.text,
    );
    print('userId--->${PrefKey.userId}');
    print('boolll_--->${res}');
    if (res) {
      showSnackBar(context, 'Update Successfully');
    }

    setState(() {
      loading = false;
    });
  }

  updateEmailHandler() async {
    setState(() {
      loading = true;
    });
    var res = await UpdateAccountSettingService()
        .updateEmailService(context: context, email: controller.text);

    if (res) {
      showSnackBar(context, 'Update Successfully');
    }

    setState(() {
      loading = false;
    });
  }

  updateLocationHandler() async {
    setState(() {
      loading = true;
    });
    var res = await UpdateAccountSettingService()
        .updateLocationService(context: context, location: controller.text);

    await pref.setString('myLocation', controller.text);

    if (res) {
      showSnackBar(context, 'Update Successfully');
    }

    setState(() {
      loading = false;
    });
  }

  updatePasswordHandler() async {
    setState(() {
      loading = true;
    });
    var res = await UpdateAccountSettingService().updatePasswordService(
        context: context, newPassword: controller.text, email: widget.emailSt);

    if (res) {
      showSnackBar(context, 'Update Successfully');
    }

    setState(() {
      loading = false;
    });
  }

  var userId = pref.getString(PrefKey.userId);
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dio = AppDio(context);
        logger.init();
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
                    widget.password == true
                        ? const SizedBox.shrink()
                        : AppText.appText("${widget.lable}",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: AppTheme.text09),
                    const SizedBox(
                      height: 10,
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
              if (widget.password == true)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
