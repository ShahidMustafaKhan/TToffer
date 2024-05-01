import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    _phoneController.text = "+375";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        context: context,
        title: "Phone",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/phoneAuth.png",
                      height: 165,
                      width: 201,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: AppText.appText("Phone",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff090B0C)),
              ),
              phoneField(controller: _phoneController),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                child: AppText.appText("Password",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff090B0C)),
              ),
              CustomAppPasswordfield(
                texthint: "Password",
                controller: _passwordController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: AppButton.appButton("Sign In", onTap: () {
                  if (_phoneController.text.isNotEmpty) {
                    if (_passwordController.text.isNotEmpty) {
                      phoneSignIn();
                    } else {
                      showSnackBar(context, "Enter Password");
                    }
                  } else {
                    showSnackBar(context, "Enter Phone");
                  }
                },
                    height: 53,
                    radius: 32.0,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    backgroundColor: AppTheme.appColor,
                    textColor: AppTheme.whiteColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneField({controller}) {
    String initialCountry = "by";
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          border: Border.all(color: const Color(0xffE5E9EB)),
          borderRadius: BorderRadius.circular(14)),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CountryListPick(
            onChanged: (CountryCode? countryCode) {
              controller.text = countryCode?.dialCode ?? '';
            },
            theme: CountryTheme(
                isShowFlag: true,
                showEnglishName: true,
                isShowTitle: false,
                isShowCode: false,
                isDownIcon: false),
            initialSelection: initialCountry,
            useUiOverlay: false,
            useSafeArea: false,
          ),
          Expanded(
            child: TextFormField(
              cursorColor: AppTheme.textColor,
              cursorHeight: 25,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: const InputDecoration(
                  fillColor: Colors.black38,
                  focusedBorder: InputBorder.none,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 4)),
            ),
          ),
        ],
      ),
    );
  }

  void phoneSignIn() async {
    setState(() {
      isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "phone": _phoneController.text,
      "password": _passwordController.text
    };
    try {
      response = await dio.post(path: AppUrls.logInPhone, data: params);
      var responseData = response.data;
      print("object${responseData}");
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            isLoading = false;
          });

          return;
        } else {
          setState(() {
            isLoading = false;
          });
          var userId = responseData["data"]["user"]["id"];
          var token = responseData["data"]["token"];
          var id = userId.toString();
          print("id$id  kmff $token");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefKey.userId, id ?? '');
          prefs.setString(PrefKey.authorization, token ?? '');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavView(),
              ),
              (route) => false);
        }
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }
}
