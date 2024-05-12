import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/providers/search_provider.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:tt_offer/views/All%20Featured%20Products/feature_info.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';

import '../../utils/resources/res/app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // DateTime _parseEndingDateTime() {
  //   String? endingTimeString = widget.data["ending_time"];
  //   String? endingDateString = widget.data["ending_date"];
  //   DateTime endingDate =
  //   DateFormat("yyyy-MM-dd").parse("${widget.data["ending_date"]}");
  //   DateTime endingTime;
  //
  //   if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
  //     endingTime = DateFormat("h:mm a").parse("${widget.data["ending_time"]}");
  //     print(" vkrvlrvm$endingTime");
  //   } else {
  //     endingTime = DateFormat("HH:mm").parse("${widget.data["ending_time"]}");
  //     print(" jf3o3jfpfp3fpk$endingTime");
  //   }
  //   return DateTime(
  //     endingDate.year,
  //     endingDate.month,
  //     endingDate.day,
  //     endingTime.hour,
  //     endingTime.minute,
  //   );
  // }

  // String getTimeLeftString() {
  //   DateTime? endTime = _parseEndingDateTime();
  //
  //   if (endTime == null) {
  //     return 'Invalid date/time';
  //   }
  //
  //   Duration timeLeft = endTime.difference(DateTime.now());
  //
  //   if (timeLeft.isNegative) {
  //     return 'Time Ends';
  //   }
  //
  //   if (timeLeft.inHours < 24) {
  //     int hours = timeLeft.inHours;
  //     int minutes = timeLeft.inMinutes.remainder(60);
  //     return '$hours Hours $minutes Minutes';
  //   } else {
  //     int days = timeLeft.inDays;
  //     int hours = timeLeft.inHours % 24;
  //     int minutes = timeLeft.inMinutes.remainder(60);
  //     return '$days Days $hours Hours $minutes Minutes';
  //   }
  // }

  bool isLoading = false;

  bool isAuctionProduct = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, data, _) {
      return Scaffold(
        appBar: const CustomAppBar1(title: 'Searched Items'),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              for (var l in data.selling)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                  child: SizedBox(
                    height: 325,
                    width: getWidth(context) * .43,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (l.auctionPrice == null) {
                              getFeatureProductDetail(productId: l.id);
                            } else {
                              getAuctionProductDetail(productId: l.id);
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
                                borderRadius: BorderRadius.circular(14),
                                image: l.photo!.isNotEmpty
                                    ? DecorationImage(
                                        image:
                                            NetworkImage("${l.photo![0].src}"),
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
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 10.0),
                                  child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.whiteColor),
                                      child: l.wishlist == null
                                          ? Icon(
                                              Icons.favorite_border,
                                              size: 13,
                                              color: AppTheme.textColor,
                                            )
                                          : Icon(
                                              size: 13,
                                              Icons.favorite_sharp,
                                              color: AppTheme.appColor,
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
                        AppText.appText("\$${l.auctionPrice ?? l.fixPrice}",
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
                        Expanded(
                          child: AppButton.appButton("Bid Now", onTap: () {
                            getAuctionProductDetail(productId: l.id);
                          },
                              height: 32,
                              width: 161,
                              radius: 16.0,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              backgroundColor: AppTheme.appColor,
                              textColor: AppTheme.whiteColor),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        )),
      );
    });
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
