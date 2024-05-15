import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/constants.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/selling_purchase_provider.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/utils/widgets/others/delete_notification_dialog.dart';
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';
import 'package:tt_offer/views/Sellings/item_dashboard.dart';
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
  AppLogger logger = AppLogger();

  // var sellingData;
  // var purchaseData;
  // var archieveData;

  SellingProductsModel? sellingProductsModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getSellingProducts(context);
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
      body: Consumer<SellingPurchaseProvider>(
        builder: (context, value, child) {
          sellingProductsModel = value.sellingProductsModel;
          if (value.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.appColor,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                selectOption(),
                if (selectedOption == "Selling")
                  Expanded(
                      child: SellingPurchaseListView(
                    ischeck: 1,
                    sellingProductsModel: sellingProductsModel,
                  )),
                if (selectedOption == "Buying")
                  Expanded(
                      child: SellingPurchaseListView(
                    ischeck: 2,
                    sellingProductsModel: sellingProductsModel,
                  )),
                if (selectedOption == "Archive")
                  Expanded(
                      child: SellingPurchaseListView(
                    sellingProductsModel: sellingProductsModel,
                    ischeck: 3,
                  )),
              ],
            ),
          );
        },
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
}

void getSellingProducts(context) async {
  log("getSellingProducts fired");

  var response;

  // try {
  response = await dio.get(path: AppUrls.sellingScreen);
  var responseData = response.data;
  if (response.statusCode == 200) {
    // sellingData = responseData["sold"];
    SellingProductsModel model = SellingProductsModel.fromJson(responseData);

    Provider.of<SellingPurchaseProvider>(context, listen: false)
        .updateData(model: model);
    // purchaseData = responseData["purchase"];
    // archieveData = responseData["archive"];
  }
  // } catch (e) {
  //   print("Something went Wrong $e");
  //   showSnackBar(context, "Something went Wrong.");
  // }
}

class SellingPurchaseListView extends StatefulWidget {
  final int? ischeck;
  SellingProductsModel? sellingProductsModel;

  // final Function getSellingProduct;
  SellingPurchaseListView({
    super.key,
    this.ischeck,
    this.sellingProductsModel,
    // required this.getSellingProduct
  });

  @override
  State<SellingPurchaseListView> createState() =>
      _SellingPurchaseListViewState();
}

class _SellingPurchaseListViewState extends State<SellingPurchaseListView> {
  // int listCount = 0;
  var data;

  @override
  void initState() {
    super.initState();

    if (widget.ischeck == 1) {
      // listCount = widget.sellingProductsModel!.data!.selling!.length;
      data = widget.sellingProductsModel!.data!.selling;
    } else if (widget.ischeck == 2) {
      // listCount = widget.sellingProductsModel!.data!.purchase!.length;
      data = widget.sellingProductsModel!.data!.purchase;
    } else {
      // listCount = widget.sellingProductsModel!.data!.archive!.length;
      data = widget.sellingProductsModel!.data!.archive;
    }
  }

  @override
  void didUpdateWidget(covariant SellingPurchaseListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ischeck == 1) {
      // listCount = widget.sellingProductsModel!.data!.selling!.length;
      data = widget.sellingProductsModel!.data!.selling;
    } else if (widget.ischeck == 2) {
      // listCount = widget.sellingProductsModel!.data!.purchase!.length;
      data = widget.sellingProductsModel!.data!.purchase;
    } else {
      // listCount = widget.sellingProductsModel!.data!.archive!.length;
      data = widget.sellingProductsModel!.data!.archive;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("data for check ${widget.ischeck} = $data");
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.ischeck == 1) {
                    log("go to ItemDashBoard");
                    push(
                        context,
                        ItemDashBoard(
                          selling: widget
                              .sellingProductsModel!.data!.selling![index],
                        ));
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
                              child: data[index].photo == null ||
                                  data[index].photo!.isEmpty ||
                                  data[index].photo![0].src == null
                                  ?Image.asset('assets/images/gallery.png')
                                  : Image.network(
                                      data[index].photo![0].src,
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
                              SizedBox(
                                width: getWidth(context) * .5,
                                child: AppText.appText(data[index].title ?? "",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                    maxlines: 1,
                                    textColor: AppTheme.txt1B20),
                              ),
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
                                  InkWell(
                                    onTap: () {
                                      if (widget.ischeck == 1) {
                                        push(
                                            context,
                                            SellFaster(
                                              selling: data[index],
                                            ));
                                      }
                                    },
                                    child: AppText.appText(
                                        widget.ischeck == 1
                                            ? "Sell faster"
                                            : widget.ischeck == 2
                                                ? ';':widget.ischeck==3?'Ready to sale':'',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        textColor: AppTheme.appColor),
                                  ),
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
                                  InkWell(
                                    onTap: () {
                                      if (widget.ischeck == 1) {
                                        markAsSold(
                                            data[index].id, context, index);
                                      } else if (widget.ischeck == 3) {
                                        makrAsUnArchive(
                                            data[index].id, context);
                                      }
                                    },
                                    child: AppText.appText(
                                        widget.ischeck == 1
                                            ? "Mark as sold"
                                            : widget.ischeck == 2
                                                ? ""
                                                : "Unarchive",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        textColor: AppTheme.appColor),
                                  ),
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

  Future<void> markAsSold(int? id, context, int index) async {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Update Item Status",
      description: "Do you want mark item as sold ?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Mark as sold",
      context: context,
      loading: isLoading,
      onTap: () async {
        Navigator.of(context).pop();
        showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductSold}/$id");

          showSnackBar(context, responce["message"]);
          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context);
          }
          Navigator.of(context).pop(true);
          //
          // }

          log("responce = $responce");
        } catch (e) {
          log("excepion = ${e.toString()}");
          Navigator.of(context).pop(false);
          showSnackBar(context, "Something went Wrong");
        }
      },
    );
  }

  void makrAsUnArchive(id, BuildContext context) {
    bool isLoading = false;
    CustomAlertDialog(
      title: "Update Item Status",
      description: "Do you want to Unarchive?",
      cancelButtonTitle: "No",
      confirmButtonTitle: "Yes, Unarchive",
      context: context,
      loading: isLoading,
      onTap: () async {
        Navigator.of(context).pop();
        showAlertLoader(context: context);
        try {
          var responce = await customGetRequest.httpGetRequest(
              url: "${AppUrls.markProductUnarchive}/$id");

          showSnackBar(context, responce["message"]);
          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context);
          }
          Navigator.of(context).pop(true);
          //
          // }

          log("responce = $responce");
        } catch (e) {
          log("excepion = ${e.toString()}");
          Navigator.of(context).pop(false);
          showSnackBar(context, "Something went Wrong");
        }
      },
    );
  }
}
