import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/views/PhoneVerify/phone_verify_screen.dart';
import 'package:tt_offer/views/Profile%20Screen/Account%20Settigs/account_info_edit.dart';

import '../../../Constants/app_logger.dart';
import '../../../config/dio/app_dio.dart';
import '../../../config/keys/pref_keys.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  late final ProfileApiProvider profileApi;
  var userId;
  late AppDio dio;
  AppLogger logger = AppLogger();


  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserDetail();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    profileApi = Provider.of<ProfileApiProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
   profileApi.showPhoneNumberInAds(dio: dio, context: context, userId: userId, showPhone: profileApi.profileData["show_contact"] == '1');
    super.dispose();
  }

  getUserDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.userId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Account Setting",
      ),
      body: Consumer<ProfileApiProvider>(
          builder: (context, profileApi, child) {
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
                            infoText: "${profileApi.profileData["name"]}",
                          ), then: (){profileApi.getProfile(dio: dio, context: context);});
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
                              PhoneVerifyScreen(
                                  // userName: false,
                                  // title: "Phone Number",
                                  // lable: "Your Number",
                                  // infoText: "${profileApi.profileData["phone"]}",
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
                                userName: false,
                                title: "Email Address",
                                lable: "Your Email",
                                infoText: "${profileApi.profileData["email"]}",
                                email: true,
                              ), then: (){profileApi.getProfile(dio: dio, context: context);});
                        },
                        img: "assets/images/sms.png",
                        txt: "${profileApi.profileData["email"]}"),
                divider(),
                customRow(
                    onTap: () {
                      push(
                          context,
                          AccountEditInfoScreen(
                            emailSt: "${profileApi.profileData["email"]}",
                            userName: false,
                            title: "Password",
                            lable: "Old Password",
                            infoText: "************",
                            password: true,
                          ), then: (){profileApi.getProfile(dio: dio, context: context);});
                    },
                    img: "assets/images/password.png",
                    txt: "************"),
                divider(),
                customRow(
                    onTap: () {
                      push(
                          context,
                          AccountEditInfoScreen(
                            userName: false,
                            title: "Location",
                            lable: "Your Location",
                            infoText: profileApi.profileData["location"] == null
                                ? 'Add Location'
                                : "${profileApi.profileData["location"]}",
                            location: true,
                          ), then: (){profileApi.getProfile(dio: dio, context: context);});
                    },
                    img: "assets/images/location.png",
                    txt: profileApi.profileData["location"] == null
                        ? 'Add Location'
                        : "${profileApi.profileData["location"]}"),
                // divider(),
                // customRow(
                //     onTap: () {
                //       push(
                //           context,
                //           AccountEditInfoScreen(
                //             title: "User Name",
                //             lable: "Your Name",
                //             infoText: "John Doe",
                //           ));
                //     },
                //     img: "assets/images/join.png",
                //     txt: "Join TruYou"),
                divider(),
                customRow(
                    onTap: () {
                      push(
                          context,
                          AccountEditInfoScreen(
                            title: "User Name",
                            lable: "Your Name",
                            infoText: "John Doe",
                          ), then: (){profileApi.getProfile(dio: dio, context: context);});
                    },
                    radioButton: true,
                    img: "assets/images/call.png",
                    txt: "Show my phone Number"),
                divider(),
              ],
            ),
          );
        }
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

  Widget customRow({img, txt, required Function() onTap, bool radioButton=false, Function? radioButtonTap}) {
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
            if(radioButton==false)
            Image.asset(
              "assets/images/arrowFor.png",
              height: 16,
            ),
            if(radioButton==true)
              Consumer<ProfileApiProvider>(
                  builder: (context, profileApi, child) {
                    return Switch(
                    value: profileApi.profileData['show_contact']=='1',
                    onChanged: (bool value) {
                      if(value==true) {
                        setState(() {
                          profileApi.profileData['show_contact'] = '1';
                        });
                      }
                      else{
                        setState(() {
                          profileApi.profileData['show_contact'] = '0';
                        });                      }
                    },
                  );
                }
              ),

          ],
        ),
      ),
    );
  }
}
