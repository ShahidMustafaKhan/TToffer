import 'dart:developer';

import 'package:dialogs/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/listview_container.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/custom_requests/user_info_service.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/selling_serach_model.dart';
import 'package:tt_offer/models/user_info_model.dart';
import 'package:tt_offer/providers/profile_info_provider.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';
import 'package:tt_offer/views/Profile%20Screen/profile_screen.dart';

import '../../utils/utils.dart';
import '../../utils/widgets/custom_loader.dart';

class SellerProfileScreen extends StatefulWidget {
  var detailResponse;

  SellerProfileScreen({super.key, this.detailResponse});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  List<ProductsDataInfo> data = [];

  List<ProductsDataInfo> auction = [];
  List<ProductsDataInfo> feature = [];

  bool loader = false;

  String timeDifference = ''; // Store the calculated time difference

  getUserProduct() async {
    setState(() {
      loader = true;
    });
    await UserInfoService().userInfoService(
        context: context, id: widget.detailResponse['user_id']);
    setState(() {
      loader = false;
    });
    data = Provider.of<ProfileInfoProvider>(context, listen: false).data;
    print('data --> $data');

    // Clear the lists before adding data to them
    feature.clear();
    auction.clear();

    // Calculate time difference and add to appropriate list
    data.forEach((element) {
      if (element.firmOnPrice == null) {
        auction.add(element);
      } else if (element.auctionPrice == null) {
        feature.add(element);
      }
    });

    setState(() {}); // Update the UI after adding data to lists
  }

  @override
  void initState() {
    super.initState();
    log("widget.detailResponse = ${widget.detailResponse}");
    getUserProduct();
  }

  String calculateTimeDifference(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(dateTime);
    int days = difference.inDays;
    int hours =
        difference.inHours.remainder(24); // Get hours within the current day
    int minutes = difference.inMinutes
        .remainder(60); // Get minutes within the current hour

    if (days > 0) {
      return '$days ${days == 1 ? 'day' : 'days'} $hours ${hours == 1 ? 'hour' : 'hours'} $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }
  }


  List<String> dataRequest = [
    'Inappropriate profile picture',
    'The user is threatening me',
    'The user is insulting me',
    'Spam',
    'Fraud',
    'Other'
  ];

  String?  selectData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(
          widget: [
            PopupMenuButton(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding:
                          const EdgeInsets.only(right: 60, left: 10, bottom: 0),
                      value: 1,
                      child: const Text('Block User'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Do you want to block this user?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text('No')),
                                  TextButton(
                                      onPressed: () {},
                                      child: const Text('Yes')),
                                ],
                              );
                            });
                      },
                    ),
                    const PopupMenuItem(

                        padding:
                            EdgeInsets.only(right: 60, left: 10, bottom: 0),
                        value: 2,
                        child: Text('Report User')),
                  ];
                })
          ],
          action: true,
          title: "${widget.detailResponse["user"]["name"]}'s Profile",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                upperContainer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    verifiedContainer(
                        txt: "Email Verified",
                        color: widget.detailResponse["user"]
                                    ["email_verified_at"] !=
                                null
                            ? null
                            : Colors.red,
                        img: "assets/images/sms.png"),
                    verifiedContainer(
                        txt: "Image Verified",
                        img: "assets/images/gallery.png"),
                    verifiedContainer(
                        txt: "Phone Verified",
                        img: "assets/images/call.png",
                        color: widget.detailResponse["user"]
                                    ["phone_verified_at"] !=
                                null
                            ? null
                            : Colors.red),
                    verifiedContainer(
                        color: widget.detailResponse["user"]["is_true_you"] == 0
                            ? Colors.red
                            : null,
                        txt: "Join TruYou",
                        img: "assets/images/verify1.png"),
                  ],
                ),
                selectOption(),
                const SizedBox(height: 10),
                loader == true
                    ? Center(
                        child: CircularProgressIndicator(
                        color: AppTheme.appColor,
                      ))
                    : data.isEmpty
                        ? const Center(child: Text('No product found'))
                        : selectedOption == "Auction"
                            ? Wrap(
                                children: [
                                  for (var l in selectedOption == 'Auction'
                                      ? auction
                                      : feature)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2.5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (l.auctionPrice == null) {
                                                  getFeatureProductDetail(
                                                      productId: l.id);
                                                  print('featureId--->${l.id}');
                                                } else {
                                                  getAuctionProductDetail(
                                                      productId: l.id);
                                                  print('auctionId--->${l.id}');

                                                  // push(
                                                  //     context,
                                                  //     AuctionInfoScreen(
                                                  //       detailResponse: l,
                                                  //     ));
                                                }
                                              },
                                              child: Container(
                                                height: 210,
                                                width: 161,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppTheme.hintTextColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    image: l.photo!.isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                "${l.photo![0].src}"),
                                                            fit: BoxFit.fill)
                                                        : null),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // widget.data["wishlist"].isNotEmpty
                                                    //     ? removeFavourite(
                                                    //         wishId: widget.data["wishlist"][0]
                                                    //             ["id"])
                                                    //     : addToFavourite();
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              right: 10.0),
                                                      child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: AppTheme
                                                                  .whiteColor),
                                                          child:
                                                              l.wishlist == null
                                                                  ? Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      size: 13,
                                                                      color: AppTheme
                                                                          .textColor,
                                                                    )
                                                                  : Icon(
                                                                      size: 13,
                                                                      Icons
                                                                          .favorite_sharp,
                                                                      color: AppTheme
                                                                          .appColor,
                                                                    )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              width: 130,
                                              child: AppText.appText(
                                                  "${l.title}",
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500,
                                                  textColor:
                                                      AppTheme.textColor),
                                            ),

                                            const SizedBox(height: 8),

                                            AppText.appText(
                                                "${l.fixPrice != null ? '\$' : ''}${l.auctionPrice ?? l.fixPrice ?? ''}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                textColor: AppTheme.textColor),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //   children: [
                                            //     AppText.appText("Time Left:",
                                            //         fontSize: 12,
                                            //         fontWeight: FontWeight.w700,
                                            //         textColor: AppTheme.textColor),
                                            //     // SizedBox(
                                            //     //   width: 80,
                                            //     //   child: AppText.appText(getTimeLeftString(),
                                            //     //       fontSize: 12,
                                            //     //       overflow: TextOverflow.ellipsis,
                                            //     //       fontWeight: FontWeight.w600,
                                            //     //       textColor: AppTheme.appColor),
                                            //     // ),
                                            //   ],
                                            // ),

                                            SizedBox(
                                                height: l.endingTime == null
                                                    ? 0
                                                    : 8),
                                            l.endingTime == null
                                                ? const SizedBox.shrink()
                                                : Row(
                                                    children: [
                                                      const Text('Time Left'),
                                                      const Spacer(),
                                                      SizedBox(
                                                        width: 100,
                                                        child: AppText.appText(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          l.endingTime
                                                              .toString(),
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textColor:
                                                              AppTheme.appColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                            SizedBox(
                                                height: l.endingTime == null
                                                    ? 0
                                                    : 8),

                                            AppButton.appButton("Bid Now",
                                                onTap: () {
                                              getAuctionProductDetail(
                                                  productId: l.id);
                                            },
                                                height: 32,
                                                width: 161,
                                                radius: 16.0,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                backgroundColor:
                                                    AppTheme.appColor,
                                                textColor: AppTheme.whiteColor)
                                            // else
                                            //   const SizedBox()
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              )
                            : Wrap(
                                children: [
                                  for (var l in selectedOption == 'Auction'
                                      ? auction
                                      : feature)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2.4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (l.auctionPrice == null) {
                                                  getFeatureProductDetail(
                                                      productId: l.id);
                                                  print('featureId--->${l.id}');
                                                } else {
                                                  getAuctionProductDetail(
                                                      productId: l.id);
                                                  print('auctionId--->${l.id}');

                                                  // push(
                                                  //     context,
                                                  //     AuctionInfoScreen(
                                                  //       detailResponse: l,
                                                  //     ));
                                                }
                                              },
                                              child: Container(
                                                height: 210,
                                                width: 161,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppTheme.hintTextColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    image: l.photo!.isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                "${l.photo![0].src}"),
                                                            fit: BoxFit.fill)
                                                        : null),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // widget.data["wishlist"].isNotEmpty
                                                    //     ? removeFavourite(
                                                    //         wishId: widget.data["wishlist"][0]
                                                    //             ["id"])
                                                    //     : addToFavourite();
                                                  },
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              right: 10.0),
                                                      child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: AppTheme
                                                                  .whiteColor),
                                                          child:
                                                              l.wishlist == null
                                                                  ? Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      size: 13,
                                                                      color: AppTheme
                                                                          .textColor,
                                                                    )
                                                                  : Icon(
                                                                      size: 13,
                                                                      Icons
                                                                          .favorite_sharp,
                                                                      color: AppTheme
                                                                          .appColor,
                                                                    )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              width: 100,
                                              child: AppText.appText(
                                                  "${l.title}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  textColor:
                                                      AppTheme.textColor),
                                            ),
                                            const SizedBox(height: 5),
                                            AppText.appText(
                                                "${l.fixPrice != null ? '\$' : ''}${l.auctionPrice ?? l.fixPrice ?? ''}",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                textColor: AppTheme.textColor),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: AppTheme.textColor,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  child: AppText.appText(
                                                    "${l.location}",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textColor:
                                                        AppTheme.textColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: AppText.appText(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    calculateTimeDifference(
                                                        DateTime.parse(
                                                            l.createdAt)),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    textColor:
                                                        AppTheme.appColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
              ],
            ),
          ),
        ));
  }

  Widget verifiedContainer({img, txt, color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 80,
        width: 48,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color ?? AppTheme.appColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "$img",
                  height: 20,
                  color: AppTheme.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              child: AppText.appText("$txt",
                  textAlign: TextAlign.center,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.txt1B20),
            ),
          ],
        ),
      ),
    );
  }

  Widget upperContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 140,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 92,
                  width: 80,
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: widget.detailResponse['user']['img'] ==
                                        null
                                    ? const AssetImage(
                                        'assets/images/profile.png')
                                    : NetworkImage(widget.detailResponse['user']
                                        ['img']) as ImageProvider<Object>,
                                fit: BoxFit.cover),
                            color: AppTheme.text09,
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Container(
                      //     height: 24,
                      //     width: 24,
                      //     decoration: BoxDecoration(
                      //         color: AppTheme.whiteColor,
                      //         borderRadius: BorderRadius.circular(6)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Image.asset("assets/images/camera.png"),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                AppText.appText(widget.detailResponse['user']['name'],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppTheme.txt1B20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const StarRating(
                //       percentage: 20,
                //       color: Colors.yellow,
                //       size: 14,
                //     ),
                //     AppText.appText("5.0",
                //         fontSize: 10,
                //         fontWeight: FontWeight.w400,
                //         textColor: AppTheme.txt1B20),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
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

  bool isLoading = false;

  bool isAuctionProduct = false;

  void getFeatureProductDetail({productId, limit}) async {
    final ProgressDialog pr = ProgressDialog(
      context: context,
      textColor: AppTheme.txt1B20,
      backgroundColor: Colors.white54,
      progressIndicatorColor: AppTheme.appColor,
    );

    setState(() {
      pr.show();
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

  String selectedOption = 'Auction';

  Widget selectOption() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          double tapPosition = details.localPosition.dx;
          if (tapPosition < screenWidth * 0.45) {
            setState(() {
              if (selectedOption != 'Auction') {
                // final apiProvider =
                // Provider.of<ProductsApiProvider>(context, listen: false);
                // apiProvider.getAuctionProducts(
                //     dio: dio, context: context, cateId: widget.catId);
              }
              selectedOption = 'Auction';
            });
          } else if (tapPosition < screenWidth * 0.9) {
            setState(() {
              if (selectedOption == 'Auction') {
                // final apiProvider =
                // Provider.of<ProductsApiProvider>(context, listen: false);
                // apiProvider.getFeatureProducts(
                //     dio: dio, context: context, cateId: widget.catId);
              }
              selectedOption = 'Featured';
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
                    color: selectedOption == 'Auction'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Auction',
                    style: TextStyle(
                      color: selectedOption == 'Auction'
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
                    color: selectedOption == 'Featured'
                        ? AppTheme.appColor // Change color when selected
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Featured',
                    style: TextStyle(
                      color: selectedOption == 'Featured'
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
