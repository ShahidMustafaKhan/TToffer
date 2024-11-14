import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Controller/APIs%20Manager/profile_apis.dart';
import 'package:tt_offer/Controller/loading_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/views/PhoneVerify/phone_verify_screen.dart';
import 'package:tt_offer/views/Profile%20Screen/Account%20Settigs/account_info_edit.dart';
import 'package:tt_offer/views/Profile%20Screen/Settings/about_us.dart';
import 'package:tt_offer/views/Profile%20Screen/Settings/privacy_policy.dart';

import '../../../Constants/app_logger.dart';
import '../../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../../config/app_urls.dart';
import '../../../config/dio/app_dio.dart';
import '../../../config/keys/pref_keys.dart';
import '../../../providers/selling_purchase_provider.dart';
import '../../Authentication screens/login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
        title: "Settings",
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
                      PrivacyPolicyScreen(
                      ));
                },
                img: Icons.privacy_tip_outlined,
                txt: "Privacy Policy"),
             divider(),
             customRow(
                    onTap: () {
                      push(
                          context,
                          AboutUsScreen(
                              ));
                    },
                    img: Icons.info_outline,
                    txt: "About Us"),
            divider(),
             customRow(
                    onTap: () {
                      deleteAccountDialog(context);
                    },
                    img: Icons.delete_outline,
                    txt: "Delete Account"),

          ],
        ),
      ),
    );
  }

  Future<void> deleteAccountDialog(BuildContext context) async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Confirm Account Deletion",
      description: "Are you sure you want to delete account?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes",
      context: context,
      loading: isLoading,

      onTap: () async {
        deleteProfile(dio: dio, context: context);
      },
    );
  }

  Future<void> clearCacheAndSignOut() async {
    // Sign out from Google
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // Clear shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Provider.of<ProfileApiProvider>(context, listen: false).profileData = null;
    await prefs.clear();

    // Optionally, clear other caches if needed
    // e.g., app-specific caches, in-memory caches, etc.

    // Restart the authentication flow or navigate to the login screen
    // For example:
    // Navigator.of(context).pushReplacementNamed('/login');
  }


  Future deleteProfile({required dio, required context}) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);


    loadingProvider.changeLoadingStatus(true);

    setState(() {

    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: "${AppUrls.deleteAccount}/$userId");
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
          Navigator.of(context).pop();
           showSnackBar(context, "${responseData["message"]}");
            loadingProvider.changeLoadingStatus(false);

      } else if (response.statusCode == responseCode401) {
           Navigator.of(context).pop();
           showSnackBar(context, "${responseData["message"]}");
            loadingProvider.changeLoadingStatus(false);

      } else if (response.statusCode == responseCode404) {
          Navigator.of(context).pop();
          showSnackBar(context, "${responseData["message"]}");

            loadingProvider.changeLoadingStatus(false);

      } else if (response.statusCode == responseCode500) {
          Navigator.of(context).pop();
          showSnackBar(context, "${responseData["message"]}");

            loadingProvider.changeLoadingStatus(false);

      } else if (response.statusCode == responseCode422) {
            loadingProvider.changeLoadingStatus(false);

      } else if (response.statusCode == responseCode200) {
            loadingProvider.changeLoadingStatus(false);

        setState(() {

        });
        clearDataAndSignOut(context);
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      Navigator.of(context).pop();
      showSnackBar(context, "Something went Wrong.");
          loadingProvider.changeLoadingStatus(false);

    }
  }

  clearDataAndSignOut(BuildContext context) async {
    Navigator.of(context).pop();
    clearCacheAndSignOut();
    SharedPreferences pref =
        await SharedPreferences.getInstance();
    pref.clear();
    Provider.of<SellingPurchaseProvider>(context, listen: false).sellingProductsModel = null;
    pushUntil(context, const SigInScreen());
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
                Icon(
                  img,
                  size: 21,
                  color: Colors.grey.shade700,
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
