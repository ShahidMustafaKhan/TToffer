import 'package:flutter/material.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/View/Sellings/item_dashboard.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class SellingPurchaseScreen extends StatefulWidget {
  final String title;
  const SellingPurchaseScreen({Key? key, required this.title})
      : super(key: key);

  @override
  State<SellingPurchaseScreen> createState() => _SellingPurchaseScreenState();
}

class _SellingPurchaseScreenState extends State<SellingPurchaseScreen> {
  String selectedOption = 'Selling';
  bool isLoading = false;
  late AppDio dio;
  AppLogger logger = AppLogger();
  var sellingData;
  var purchaseData;
  var archieveData;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getSellingProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      appBar: CustomAppBar1(
        title: widget.title,
        leading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            selectOption(),
            if (selectedOption == "Selling")
              const Expanded(
                  child: SellingPurchaseListView(
                ischeck: 1,
              )),
            if (selectedOption == "Buying")
              const Expanded(
                  child: SellingPurchaseListView(
                ischeck: 2,
              )),
            if (selectedOption == "Archive")
              const Expanded(
                  child: SellingPurchaseListView(
                ischeck: 3,
              )),
          ],
        ),
      ),
    );
  }

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.3) {
            setState(() {
              selectedOption = 'Selling';
            });
          } else if (tapPosition < screenWidth * 0.6) {
            setState(() {
              selectedOption = 'Buying';
            });
          } else {
            setState(() {
              selectedOption = 'Archive';
            });
          }
        },
        child: Container(
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: const Color(0xffEDEDED))),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(100)),
                    color: selectedOption == 'Selling'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Selling',
                    style: TextStyle(
                      color: selectedOption == 'Selling'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    color: selectedOption == 'Buying'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Buying',
                    style: TextStyle(
                      color: selectedOption == 'Buying'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDEDED)),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'Archive'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Archive',
                    style: TextStyle(
                      color: selectedOption == 'Archive'
                          ? Colors.white // Change text color when selected
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getSellingProducts() async {
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

    try {
      response = await dio.get(path: AppUrls.sellingScreen);
      var responseData = response.data;
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
        setState(() {
          isLoading = false;
          sellingData = responseData["sold"];
          purchaseData = responseData["purchase"];
          archieveData = responseData["archive"];
        });
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

class SellingPurchaseListView extends StatefulWidget {
  final int? ischeck;
  const SellingPurchaseListView({super.key, this.ischeck});

  @override
  State<SellingPurchaseListView> createState() =>
      _SellingPurchaseListViewState();
}

class _SellingPurchaseListViewState extends State<SellingPurchaseListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 7,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.ischeck == 1) {
                    push(context, const ItemDashBoard());
                  }
                },
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                "assets/images/auction1.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.appText("Modern light clothes",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppTheme.txt1B20),
                              const SizedBox(
                                height: 5,
                              ),
                              widget.ischeck == 2
                                  ? const SizedBox.shrink()
                                  : const Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 55,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 0,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/sp1.png'),
                                                ),
                                              ),
                                              Positioned(
                                                right: 12,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/sp2.png'),
                                                ),
                                              ),
                                              Positioned(
                                                right: 24,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/sp3.png'),
                                                ),
                                              ),
                                              Positioned(
                                                right: 36,
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: AssetImage(
                                                      'assets/images/sp4.png'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText.appText(
                                      widget.ischeck == 1
                                          ? "Sell faster"
                                          : widget.ischeck == 2
                                              ? "Sold"
                                              : "Sold",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppTheme.appColor),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  widget.ischeck == 2
                                      ? const SizedBox.shrink()
                                      : Container(
                                          height: 10,
                                          width: 1,
                                          color: const Color(0xffEAEAEA),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AppText.appText(
                                      widget.ischeck == 1
                                          ? "Mark as sold"
                                          : widget.ischeck == 2
                                              ? ""
                                              : "Unarchive",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textColor: AppTheme.appColor),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      widget.ischeck == 2
                          ? const SizedBox.shrink()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText.appText("21 View",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: AppTheme.lighttextColor),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
            const CustomDivider()
          ],
        );
      },
    );
  }
}
