import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import 'package:tt_offer/views/PhoneVerify/phone_verify_screen.dart';
import 'package:tt_offer/views/Profile%20Screen/Account%20Settigs/account_info_edit.dart';

import '../../../config/keys/pref_keys.dart';
import '../../../main.dart';
import '../../../models/user_model.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  int? showContact;
  int? userId;
  late UserViewModel userViewModel;

  @override
  void dispose() {
    userViewModel.updateShowContact(userId, showContact ?? 1);
    super.dispose();
  }

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userId = int.parse(pref.getString(PrefKey.userId) ?? "0");
    showContact = userViewModel.userModel.data?.showContact ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Account Setting",
      ),
      body: Consumer<UserViewModel>(builder: (context, userViewModel, child) {
        UserModel? userModel = userViewModel.userModel.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              customRow(
                  onTap: () {
                    push(
                        context,
                        AccountEditInfoScreen(
                          userName: true,
                          title: "User Name",
                          lable: "Your Name",
                          infoText: "${userModel?.name}",
                        ), then: () {
                      userViewModel.getUserProfile();
                    });
                  },
                  img: "assets/images/profile.png",
                  txt: "${userModel?.name}"),
              userModel?.phone == null ? const SizedBox.shrink() : divider(),
              userModel?.phone == null
                  ? const SizedBox.shrink()
                  : customRow(
                      onTap: () {
                        push(
                            context,
                            const PhoneVerifyScreen(
                                // userName: false,
                                // title: "Phone Number",
                                // lable: "Your Number",
                                // infoText: "${profileApi.profileData["phone"]}",
                                ));
                      },
                      img: "assets/images/call.png",
                      txt: "${userModel?.phone}"),
              userModel?.email == null ? const SizedBox.shrink() : divider(),
              userModel?.email == null || userModel?.socialLogin == 1
                  ? const SizedBox.shrink()
                  : customRow(
                      onTap: () {
                        push(
                            context,
                            AccountEditInfoScreen(
                              userName: false,
                              title: "Email Address",
                              lable: "Your Email",
                              infoText: "${userModel?.email}",
                              email: true,
                            ), then: () {
                          userViewModel.getUserProfile();
                        });
                      },
                      img: "assets/images/sms.png",
                      txt: "${userModel?.email}"),
              divider(),
              if (userViewModel.userModel.data?.socialLogin != 1) ...[
                customRow(
                    onTap: () {
                      push(
                          context,
                          AccountEditInfoScreen(
                            emailSt: "${userModel?.email}",
                            userName: false,
                            title: "Password",
                            lable: "Old Password",
                            infoText: "************",
                            password: true,
                          ), then: () {
                        userViewModel.getUserProfile();
                      });
                    },
                    img: "assets/images/password.png",
                    txt: "************"),
                divider()
              ],
              customRow(
                  onTap: () {
                    push(
                        context,
                        AccountEditInfoScreen(
                          userName: false,
                          title: "Location",
                          lable: "Your Location",
                          infoText: userModel?.location == null
                              ? 'Add Location'
                              : "${userModel?.location}",
                          location: true,
                        ), then: () {
                      userViewModel.getUserProfile();
                    });
                  },
                  img: "assets/images/location.png",
                  txt: userModel?.location == null
                      ? 'Add Location'
                      : "${userModel?.location}"),
              divider(),
              customRow(
                  onTap: () {
                    push(
                        context,
                        AccountEditInfoScreen(
                          title: "",
                          lable: "",
                          infoText: "",
                        ), then: () {
                      userViewModel.getUserProfile();
                    });
                  },
                  radioButton: true,
                  img: "assets/images/call.png",
                  txt: "Show my phone Number"),
              divider(),
            ],
          ),
        );
      }),
    );
  }

  Widget divider() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffEAEAEA),
        ));
  }

  Widget customRow(
      {img,
      txt,
      required Function() onTap,
      bool radioButton = false,
      Function? radioButtonTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "$img",
                  height: 20,
                ),
                const SizedBox(
                  width: 20,
                ),
                AppText.appText("$txt",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.txt1B20),
              ],
            ),
            if (radioButton == false)
              Image.asset(
                "assets/images/arrowFor.png",
                height: 16,
              ),
            if (radioButton == true)
              Consumer<UserViewModel>(builder: (context, userViewModel, child) {
                return Switch(
                  value: showContact == 1,
                  onChanged: (bool value) {
                    if (value == true) {
                      setState(() {
                        showContact = 1;
                      });
                    } else {
                      setState(() {
                        showContact = 0;
                      });
                    }
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
