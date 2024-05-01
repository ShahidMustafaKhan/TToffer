import 'package:flutter/material.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/loading_popup.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/Utils/widgets/textField_lable.dart';
import 'package:tt_offer/View/BottomNavigation/navigation_bar.dart';
import 'package:tt_offer/View/Post%20screens/indicator.dart';
import 'package:tt_offer/View/Post%20screens/post_product_payment.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class PostLocationScreen extends StatefulWidget {
  final productId;
  const PostLocationScreen({super.key, this.productId});

  @override
  State<PostLocationScreen> createState() => _PostLocationScreenState();
}

class _PostLocationScreenState extends State<PostLocationScreen> {
  final TextEditingController _locationController = TextEditingController();
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading == true
            ? LoadingDialog()
            : AppButton.appButton("Next", onTap: () {
                enterLocation();
              },
                height: 53,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                radius: 32.0,
                backgroundColor: AppTheme.appColor,
                textColor: AppTheme.whiteColor),
      ),
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: "Finish",
        actionOntap: () {
          pushUntil(context, const BottomNavView());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: StepsIndicator(
                  conColor1: AppTheme.appColor,
                  circleColor1: AppTheme.appColor,
                  circleColor2: AppTheme.appColor,
                  conColor2: AppTheme.appColor,
                  conColor3: AppTheme.appColor,
                  circleColor3: AppTheme.appColor,
                  circleColor4: AppTheme.appColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const CustomDivider(),
              const SizedBox(
                height: 20,
              ),
              LableTextField(
                labelTxt: "Set a Location (Required)",
                hintTxt: "Set a location",
                controller: _locationController,
              ),
              Image.asset("assets/images/shipping.png"),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: AppText.appText("Ship, ship, Hooray! ",
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w700,
                    textColor: AppTheme.blackColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: AppText.appText(
                    "Accelerate the sale of your item by making it available to millions of buyers across the country.",
                    fontSize: 12,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    textColor: AppTheme.blackColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void enterLocation() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500;
    Map<String, dynamic> params = {
      "product_id": "${widget.productId}",
      "location": _locationController.text,
    };

    try {
      response = await dio.post(path: AppUrls.addProductLocation, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          pushReplacement(context, const PostProductPayment());
          _isLoading = false;
        });
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
