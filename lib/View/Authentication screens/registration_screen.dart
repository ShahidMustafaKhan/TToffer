import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        context: context,
        title: "Registration",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/profileDetail.png",
                      height: 142,
                      width: 146,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LableTextField(
                      width: MediaQuery.of(context).size.width * 0.4,
                      labelTxt: "First Name",
                      hintTxt: "First Name",
                      controller: _fNameController),
                  LableTextField(
                      width: MediaQuery.of(context).size.width * 0.4,
                      labelTxt: "Last Name",
                      hintTxt: "Last Name",
                      controller: _lNameController),
                ],
              ),
              LableTextField(
                  labelTxt: "Username",
                  hintTxt: "Username",
                  controller: _userNameController),
              LableTextField(
                  labelTxt: "Email/Phone",
                  hintTxt: "Email/Phone",
                  controller: _emailController),
              LableTextField(
                  labelTxt: "Password",
                  hintTxt: "Password",
                  pass: true,
                  controller: _passwordController),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: AppButton.appButton("Register", onTap: () {
                  _emailController.text =
                      _emailController.text.replaceAll(' ', '');
                  if (_fNameController.text.isNotEmpty) {
                    if (_userNameController.text.isNotEmpty) {
                      if (_emailController.text.isNotEmpty) {
                        String emailPhone = _emailController.text.trim();
                        bool isEmail =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(emailPhone);
                        bool isPhoneNumber = RegExp(
                                r'^\+\d{1,3}\d{9,15}$')
                            .hasMatch(emailPhone);
                        if (isPhoneNumber || isEmail) {
                          if (_passwordController.text.isNotEmpty) {
                            if (_passwordController.text.isNotEmpty) {
                              print("is $isEmail");
                              print("is $isPhoneNumber");
                              register(phone:isPhoneNumber);
                            } else {
                              showSnackBar(
                                  context, "Password length is minimum 8");
                            }
                          } else {
                            showSnackBar(context, "Enter Password");
                          }
                        } else {
                          showSnackBar(context,
                              "Please enter a valid email address or phone number with +");
                        }
                      } else {
                        showSnackBar(context, "Enter Email");
                      }
                    } else {
                      showSnackBar(context, "Enter Username");
                    }
                  } else {
                    showSnackBar(context, "Enter Name");
                  }
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

  void register({phone}) async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "name": "${_fNameController.text} ${_lNameController.text}",
      "email": _emailController.text,
      "username": _userNameController.text,
      "password": _passwordController.text,
      "phone": _emailController.text,
    };
    if (phone == true) {
      params.remove("email");
    } else {
      params.remove("phone");
    }
    try {
      response = await dio.post(path: AppUrls.registration, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        if (responseData["status"] == false) {
          setState(() {
            _isLoading = false;
          });

          return;
        } else {
          setState(() {
            _isLoading = false;
          });
          var userId = responseData["data"]["user"]["id"];
          var token = responseData["data"]["token"];
          var id = userId.toString();
          print("id$id");
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
        _isLoading = false;
      });
    }
  }
}
