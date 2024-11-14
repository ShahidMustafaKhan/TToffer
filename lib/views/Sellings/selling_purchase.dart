import 'dart:developer';

import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
import 'package:tt_offer/views/Sell%20Faster/sell_faster.dart';
import 'package:tt_offer/views/Sellings/item_dashboard.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/views/Sellings/new_sold_screen.dart';
import 'package:tt_offer/views/Sellings/rating_screen.dart';

import '../../Controller/APIs Manager/profile_apis.dart';
import '../../Utils/widgets/others/delete_notification_dialog.dart';
import '../../custom_requests/user_info_service.dart' ;
import '../../providers/profile_info_provider.dart' ;
import '../All Featured Products/feature_info.dart';
import '../Auction Info/auction_info.dart';

class SellingPurchaseScreen extends StatefulWidget {
  final String title;
  final String? selectedOption;

  const SellingPurchaseScreen({Key? key, required this.title, this.selectedOption})
      : super(key: key);

  @override
  State<SellingPurchaseScreen> createState() => _SellingPurchaseScreenState();
}

class _SellingPurchaseScreenState extends State<SellingPurchaseScreen> {
  String selectedOption = 'Buying';
  bool isLoading = false;
  AppLogger logger = AppLogger();
  late final dio;


  // var sellingData;
  // var purchaseData;
  // var archieveData;

  SellingProductsModel? sellingProductsModel;
  List<Selling>? soldProductsList;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    if(widget.selectedOption!=null){
      selectedOption = selectedOption;
    }

    getSellingProducts(context,dio);
    getUserSoldProducts(context);
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
          soldProductsList = value.soldProductsList;
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
                if(sellingProductsModel!=null)...[
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
                if (selectedOption == "History")
                  Expanded(
                      child: SellingPurchaseListView(
                    sellingProductsModel: sellingProductsModel,
                    soldProductList: soldProductsList,
                    ischeck: 3,
                  )),]
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
              selectedOption = 'Buying';
            });
          } else if (tapPosition < screenWidth * 0.6) {
            setState(() {
              selectedOption = 'Selling';
            });
          } else {
            setState(() {
              selectedOption = 'History';
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
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(100)),
                    color: selectedOption == 'History'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'History',
                    style: TextStyle(
                      color: selectedOption == 'History'
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

Future<void> getSellingProducts(context,dio) async {
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


Future<void> getUserSoldProducts(BuildContext context) async {
  try {
    var res = await customGetRequest.httpGetRequest(url: 'user/info/${Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"]}');

    if (res['data'] != null || res['success'] == true) {

      List productList = res['data']['products'];
      List<Selling> sellingModelList=[];



      for (var element in productList) {
        Selling selling = Selling.fromJson(element);

        if(selling.isSold == "1"){
          sellingModelList.add(selling);
        }
      }

      Provider.of<SellingPurchaseProvider>(context, listen: false)
          .updateSoldProductData(soldProductList: sellingModelList);


    } else {

    }
  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
}






class SellingPurchaseListView extends StatefulWidget {
  final int? ischeck;
  SellingProductsModel? sellingProductsModel;
  List<Selling>? soldProductList;

  // final Function getSellingProduct;
  SellingPurchaseListView({
    super.key,
    this.ischeck,
    this.sellingProductsModel,
    this.soldProductList,
    // required this.getSellingProduct
  });

  @override
  State<SellingPurchaseListView> createState() =>
      _SellingPurchaseListViewState();
}

class _SellingPurchaseListViewState extends State<SellingPurchaseListView> {
  // int listCount = 0;
  List<Selling> data = [];
  late final dio;
  @override
  void initState() {
    super.initState();
    dio = AppDio(context);

    if (widget.ischeck == 1) {
      // listCount = widget.sellingProductsModel!.data!.selling!.length;
      data = List.from(widget.sellingProductsModel!.data!.selling!);

      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);
      });
    }
    else if (widget.ischeck == 2) {
      // listCount = widget.sellingProductsModel!.data!.purchase!.length;
      data = widget.sellingProductsModel!.data!.purchase ?? [];

      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);
      });
    } else {
      // listCount = widget.sellingProductsModel!.data!.archive!.length;
      data = widget.sellingProductsModel!.data!.history ?? [];

      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);    });
          }
  }

  @override
  void didUpdateWidget(covariant SellingPurchaseListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ischeck == 1) {
      // listCount = widget.sellingProductsModel!.data!.selling!.length;
       data = List.from(widget.sellingProductsModel!.data!.selling!);

      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);
      });
    }
    else if (widget.ischeck == 2) {
      // listCount = widget.sellingProductsModel!.data!.purchase!.length;
      data = widget.sellingProductsModel!.data!.purchase ?? [];

      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);
      });
    } else {
      // listCount = widget.sellingProductsModel!.data!.archive!.length;
      data = widget.sellingProductsModel!.data!.history ?? [];

      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.createdAt!);
        DateTime dateB = DateTime.parse(b.createdAt!);
        return dateB.compareTo(dateA);
      });
    }
  }


  List<Selling> historyProducts(){
    List<Selling>? data = [];
    data.addAll(widget.sellingProductsModel!.data!.purchase ?? []);
    data.addAll(widget.soldProductList ?? []);

    data.sort((a, b) => DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));


    return data;
  }


  bool isItemPurchased(Selling selling){
    if(selling.userId!=null){
      if(selling.userId != Provider.of<ProfileApiProvider>(context, listen: false).profileData["id"]){
        return true;
      }
      else{
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    log("data for check ${widget.ischeck} = $data");


    if (data.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/no_data_folder.png", height: 150.h,)),
          SizedBox(height: 16.h,),
          Center(
              child: AppText.appText(
                  "No Relevant Data found",
                  textColor: AppTheme.appColor, fontSize: 14.sp
              )),
          SizedBox(height: 45.h,)
        ],
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        bool restrictMarkSold = false;
        if(data[index].auctionPrice!=null && endTimeReached(data[index].endingDate!, data[index].endingTime!)==false){
          restrictMarkSold = true;
        }
        return InkWell(
          onTap: widget.ischeck != 3 ? () {
            if(widget.ischeck == 1) {
              push(
                context,
                ItemDashBoard(
                  selling: data[index],
                ));
            }
            else if(widget.ischeck == 2) {
              if (data[index].auctionPrice == null) {
                getFeatureProductDetail(productId: data[index].id);
                // print('featureId--->${l.id}');
              } else {
                getAuctionProductDetail(productId: data[index].id);
              }
            }


          } : null,
          child: Column(
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
                            selling: data[index],
                          ),
                      then: (){
                        getSellingProducts(context, dio);
                        getUserSoldProducts(context);
                      });
                    }
                    else if(widget.ischeck == 2) {
                      if (data[index].auctionPrice == null) {
                        getFeatureProductDetail(productId: data[index].id);
                        // print('featureId--->${l.id}');
                      } else {
                        getAuctionProductDetail(productId: data[index].id);
                      }
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
                              child: Stack(
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
                                          ? Image.asset('assets/images/gallery.png')
                                          : Image.network(
                                              data[index].photo![0].src!,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            height: 25.h,
                                            decoration: const BoxDecoration(
                                              color: Colors.black38,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(16),
                                                bottomRight: Radius.circular(16),
                                              ),

                                            ),
                                            child: Center(child: AppText.appText(data[index].productType == 'auction' ? "Auction" : "AED ${abbreviateNumber(data[index].fixPrice ?? '')}" ?? '', fontSize: 10.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.center, textColor: Colors.white.withOpacity(0.85))))),
                                ],
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
                                  child: AppText.appText(
                                      data[index].title ?? "",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                      maxlines: 1,
                                      textColor: AppTheme.txt1B20),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                if(widget.ischeck != 2)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if(widget.ischeck == 1)
                                    InkWell(
                                      onTap: () {
                                        if (widget.ischeck == 1) {
                                          push(
                                              context,
                                              SellFaster(
                                                selling: data[index],
                                                fromLocation: false,
                                              ));
                                        }
                                      },
                                      child: AppText.appText(
                                          widget.ischeck == 1
                                              ? "Sell faster"
                                              : widget.ischeck == 2
                                              ? 'Purchased'
                                              : widget.ischeck == 3
                                              ? isItemPurchased(data[index]) ? 'Purchased' : 'Sold'
                                              : '',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor: AppTheme.yellowColor),
                                    )
                                    else
                                      if(data[index].auctionPrice!=null || data[index].fixPrice!=null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: AppTheme.yellowColor,
                                        borderRadius: BorderRadius.circular(8.r)
                                      ),
                                      child: AppText.appText(
                                           widget.ischeck == 2
                                                  ? 'Purchased'
                                                  : widget.ischeck == 3
                                                      ? isItemPurchased(data[index]) ? 'Purchased' : 'Sold for AED ${formatNumber(removeLastTwoZeros(data[index].auctionPrice ?? data[index].fixPrice)) }'
                                                      : '',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor: AppTheme.appColor),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    widget.ischeck != 1
                                        ? const SizedBox.shrink()
                                        : Container(
                                            height: 10,
                                            width: 1,
                                            color: const Color(0xffEAEAEA),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    if(widget.ischeck!=3)
                                    InkWell(
                                      onTap: () {
                                        if (widget.ischeck == 1) {
                                          if(restrictMarkSold == false) {
                                            push(
                                              context,
                                              NewSoldScreen(
                                                title: data[index].title,
                                                productId: data[index].id.toString(),
                                                fixPrice: data[index].fixPrice,
                                                auctionPrice: data[index].auctionPrice,
                                                image: data[index].photo!=null && data[index].photo!.isNotEmpty ? data[index].photo![0].src : null,
                                                auction: data[index].fixPrice != null ? false : true,
                                                fromMyAds: true,
                                              ), then: (){
                                            getSellingProducts(context, dio);
                                            getUserSoldProducts(context);
                                          }
                                          );
                                          }
                                          else{
                                            showSnackBar(context, 'You cannot mark this as sold until the auction has ended.');
                                          }
                                          // markAsSold(
                                          //     data[index].id, context, index);
                                        } else if (widget.ischeck == 3) {
                                          makrAsUnArchive(
                                              data[index].categoryId, context);
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

                      ],
                    ),
                  ),
                ),
              ),
              const CustomDivider()
            ],
          ),
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


          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context,dio).then((value) {
              showSnackBar(context, responce["message"], title: 'Success!');
              Navigator.of(context).pop(true);
            });
          }
          else{
            Navigator.of(context).pop(true);
          }

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

          showSnackBar(context, responce["message"], error: false);
          // showSnackBar(context, responce["success"]);

          // if (responce.statusCode == 200) {
          if (responce["success"] == true) {
            getSellingProducts(context,dio).then((value) => Navigator.of(context).pop(true));
          }
          else {
            Navigator.of(context).pop(true);
          }
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

  void getAuctionProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getAuctionProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          push(context, AuctionInfoScreen(detailResponse: detailResponse[0]));
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }



  void getFeatureProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.
    Map<String, dynamic> params = {
      "id": productId,
      "limit": limit,
    };
    try {
      response = await dio.post(path: AppUrls.getFeatureProducts, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            pr.dismiss();
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode422) {
        setState(() {
          pr.dismiss();
        });
      } else if (response.statusCode == responseCode200) {
        setState(() {
          var detailResponse = responseData["data"];
          pr.dismiss();
          push(
              context,
              FeatureInfoScreen(
                detailResponse: detailResponse[0],
              ));
        });
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      setState(() {
        pr.dismiss();
      });
    }
  }

  bool endTimeReached(String endDate, String endTimeString) {
    DateTime? endTime = convertEndTimeToUserTimeZone(_parseEndingDateTime(endDate, endTimeString));

    if (kDebugMode) {
      print('endTime $endTime');
    }

    // If the current time is after or at the endTime, return true (end time reached)
    return !endTime.isAfter(DateTime.now());
  }

  DateTime _parseEndingDateTime(String endDate, String endTime) {
    String? endingTimeString = endTime;
    String? endingDateString = endDate;
    DateTime endingDate =
    DateFormat("yyyy-MM-dd").parse(endDate);
    DateTime endingTime;

    if (endingTimeString.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse(endTime);
      if (kDebugMode) {
        print(" vkrvlrvm$endingTime");
      }
    } else {
      endingTime = DateFormat("HH:mm").parse(endTime);
      if (kDebugMode) {
        print(" jf3o3jfpfp3fpk$endingTime");
      }
    }
    return DateTime(
      endingDate.year,
      endingDate.month,
      endingDate.day,
      endingTime.hour,
      endingTime.minute,
    );
  }


  DateTime convertEndTimeToUserTimeZone(DateTime endTime) {
    // Get the user's local time zone offset (e.g., UTC+5)
    Duration userTimeZoneOffset = DateTime.now().timeZoneOffset;

    // Define the time zone offset for UTC+4 (Dubai time)
    const dubaiTimeZoneOffset = Duration(hours: 4);

    // Calculate the difference between user time zone and Dubai time zone
    Duration timeDifference = userTimeZoneOffset - dubaiTimeZoneOffset;

    // Add or subtract the time difference to the endTime
    return endTime.add(timeDifference);
  }


}
