import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/Profile%20Screen/Account%20Settigs/account_info_edit.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final profileApi = Provider.of<ProfileApiProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: const CustomAppBar1(
        title: "Account Setting",
      ),
      body: Padding(
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
                        title: "User Name",
                        lable: "Your Name",
                        infoText: "${profileApi.profileData["name"]}",
                      ));
                },
                img: "assets/images/profile.png",
                txt: "${profileApi.profileData["name"]}"),
            profileApi.profileData["phone"] == null
                ? const SizedBox.shrink()
                : divider(),
            profileApi.profileData["phone"] == null
                ? const SizedBox.shrink()
                : customRow(
                    onTap: () {
                      push(
                          context,
                          AccountEditInfoScreen(
                            title: "Phone Number",
                            lable: "Your Number",
                            infoText: "${profileApi.profileData["phone"]}",
                          ));
                    },
                    img: "assets/images/call.png",
                    txt: "${profileApi.profileData["phone"]}"),
            profileApi.profileData["email"] == null
                ? const SizedBox.shrink()
                : divider(),
            profileApi.profileData["email"] == null
                ? const SizedBox.shrink()
                : customRow(
                    onTap: () {
                      push(
                          context,
                          AccountEditInfoScreen(
                            title: "Email Address",
                            lable: "Your Email",
                            infoText: "${profileApi.profileData["email"]}",
                            email: true,
                          ));
                    },
                    img: "assets/images/sms.png",
                    txt: "${profileApi.profileData["email"]}"),
            divider(),
            customRow(
                onTap: () {
                  push(
                      context,
                      const AccountEditInfoScreen(
                        title: "Password",
                        lable: "Old Password",
                        infoText: "************",
                        password: true,
                      ));
                },
                img: "assets/images/password.png",
                txt: "************"),
            divider(),
            customRow(
                onTap: () {
                  push(
                      context,
                      const AccountEditInfoScreen(
                        title: "Location",
                        lable: "Your Location",
                        infoText: "Belarus",
                        location: true,
                      ));
                },
                img: "assets/images/location.png",
                txt: "Belarus"),
            divider(),
            customRow(
                onTap: () {
                  push(
                      context,
                      const AccountEditInfoScreen(
                        title: "User Name",
                        lable: "Your Name",
                        infoText: "John Doe",
                      ));
                },
                img: "assets/images/join.png",
                txt: "Join TruYou"),
            divider(),
          ],
        ),
      ),
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

  Widget customRow({img, txt, required Function() onTap}) {
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
            Image.asset(
              "assets/images/arrowFor.png",
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
