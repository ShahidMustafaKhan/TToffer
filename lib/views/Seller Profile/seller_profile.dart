import 'dart:developer';

import 'package:dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  bool loader = false;

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
    print('datat000-->${data}');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    log("widget.detailResponse = ${widget.detailResponse}");
    getUserProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: CustomAppBar1(
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
                const SizedBox(height: 10),
                loader == true
                    ? Center(
                        child: CircularProgressIndicator(
                        color: AppTheme.appColor,
                      ))
                    : data.isEmpty
                        ? const Center(child: Text('No product found'))
                        : Wrap(
                            children: [
                              for (var l in data)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4),
                                  child: SizedBox(
                                    height: 325,
                                    width: getWidth(context) * .43,
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
                                                color: AppTheme.hintTextColor,
                                                borderRadius:
                                                    BorderRadius.circular(14),
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
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, right: 10.0),
                                                  child: Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppTheme
                                                              .whiteColor),
                                                      child: l.wishlist == null
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
                                        Container(
                                          height: 40.5,
                                          child: AppText.appText("${l.title}",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              textColor: AppTheme.textColor),
                                        ),
                                        AppText.appText(
                                            "\$${l.auctionPrice ?? l.fixPrice}",
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

                                        if (l.auctionPrice == null)
                                          const SizedBox(
                                            height: 30,
                                          ),

                                        if (l.auctionPrice != null)
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        if (l.auctionPrice != null)
                                          Expanded(
                                            child: AppButton.appButton(
                                                "Bid Now", onTap: () {
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
                                                textColor: AppTheme.whiteColor),
                                          )
                                        else
                                          SizedBox()
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
}
