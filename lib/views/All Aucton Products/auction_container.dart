import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';

class AuctionProductContainer extends StatefulWidget {
  final data;
  const AuctionProductContainer({super.key, this.data});

  @override
  State<AuctionProductContainer> createState() =>
      _AuctionProductContainerState();
}

class _AuctionProductContainerState extends State<AuctionProductContainer> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool isLoading = false;
  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    super.initState();
  }

  DateTime _parseEndingDateTime() {
    String? endingTimeString = widget.data["ending_time"];
    String? endingDateString = widget.data["ending_date"];
    DateTime endingDate =
        DateFormat("yyyy-MM-dd").parse("${widget.data["ending_date"]}");
    DateTime endingTime;

    if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse("${widget.data["ending_time"]}");
      print(" vkrvlrvm$endingTime");
    } else {
      endingTime = DateFormat("HH:mm").parse("${widget.data["ending_time"]}");
      print(" jf3o3jfpfp3fpk$endingTime");
    }
    return DateTime(
      endingDate.year,
      endingDate.month,
      endingDate.day,
      endingTime.hour,
      endingTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      width: 161,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 210,
            width: 161,
            decoration: BoxDecoration(
                color: AppTheme.hintTextColor,
                borderRadius: BorderRadius.circular(14),
                image: widget.data["photo"].isNotEmpty
                    ? DecorationImage(
                        image:
                            NetworkImage("${widget.data["photo"][0]["src"]}"),
                        fit: BoxFit.fill)
                    : null),
            child: GestureDetector(
              onTap: () {
                // widget.data["wishlist"].isNotEmpty
                //     ? removeFavourite(wishId: widget.data["wishlist"][0]["id"])
                //     : addToFavourite();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 10.0),
                  child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppTheme.whiteColor),
                      child: widget.data["wishlist"].isEmpty
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
          AppText.appText("${widget.data["title"]}",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppTheme.textColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("\$${widget.data["auction_price"]}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  textColor: AppTheme.textColor),
              AppText.appText("${widget.data["auction"].length} Bid Now",
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                  textColor: AppTheme.textColor),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText("Time Left:",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  textColor: AppTheme.textColor),
              SizedBox(
                width: 80,
                child: AppText.appText(getTimeLeftString(),
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    textColor: AppTheme.appColor),
              ),
            ],
          ),
          AppButton.appButton("Bid Now",
              onTap: () {},
              height: 32,
              width: 161,
              radius: 16.0,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              backgroundColor: AppTheme.appColor,
              textColor: AppTheme.whiteColor)
        ],
      ),
    );
  }

  String getTimeLeftString() {
    DateTime? endTime = _parseEndingDateTime();

    if (endTime == null) {
      return 'Invalid date/time';
    }

    Duration timeLeft = endTime.difference(DateTime.now());

    if (timeLeft.isNegative) {
      return 'Time Ends';
    }

    if (timeLeft.inHours < 24) {
      int hours = timeLeft.inHours;
      int minutes = timeLeft.inMinutes.remainder(60);
      return '$hours Hours $minutes Minutes';
    } else {
      int days = timeLeft.inDays;
      int hours = timeLeft.inHours % 24;
      int minutes = timeLeft.inMinutes.remainder(60);
      return '$days Days $hours Hours $minutes Minutes';
    }
  }

  // void addToFavourite() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var response;
  //   int responseCode200 = 200; // For successful request.
  //   int responseCode400 = 400; // For Bad Request.
  //   int responseCode401 = 401; // For Unauthorized access.
  //   int responseCode404 = 404; // For For data not found
  //   int responseCode422 = 422; // For For data not found
  //   int responseCode500 = 500; // Internal server error.
  //   Map<String, dynamic> params = {
  //     "user_id": userId,
  //     "product_id": widget.data["id"],
  //   };
  //   try {
  //     response = await dio.post(path: AppUrls.adddToFavorite, data: params);
  //     var responseData = response.data;
  //     if (response.statusCode == responseCode400) {
  //       showSnackBar(context, "${responseData["msg"]}");
  //       setState(() {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     } else if (response.statusCode == responseCode401) {
  //       showSnackBar(context, "${responseData["msg"]}");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode404) {
  //       showSnackBar(context, "${responseData["msg"]}");

  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode500) {
  //       showSnackBar(context, "${responseData["msg"]}");

  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode422) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode200) {
  //       setState(() {
  //         isLoading = false;
  //         isFav = true;
  //         getAuctionProductDetail();
  //       });
  //     }
  //   } catch (e) {
  //     print("Something went Wrong ${e}");
  //     showSnackBar(context, "Something went Wrong.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void removeFavourite({wishId}) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var response;
  //   int responseCode200 = 200; // For successful request.
  //   int responseCode400 = 400; // For Bad Request.
  //   int responseCode401 = 401; // For Unauthorized access.
  //   int responseCode404 = 404; // For For data not found
  //   int responseCode422 = 422; // For For data not found
  //   int responseCode500 = 500; // Internal server error.
  //   Map<String, dynamic> params = {
  //     "id": wishId,
  //     // "product_id": widget.detailResponse["id"],
  //   };
  //   try {
  //     response = await dio.post(path: AppUrls.removeFavorite, data: params);
  //     var responseData = response.data;
  //     if (response.statusCode == responseCode400) {
  //       showSnackBar(context, "${responseData["msg"]}");
  //       setState(() {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     } else if (response.statusCode == responseCode401) {
  //       showSnackBar(context, "${responseData["msg"]}");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode404) {
  //       showSnackBar(context, "${responseData["msg"]}");

  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode500) {
  //       showSnackBar(context, "${responseData["msg"]}");

  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode422) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else if (response.statusCode == responseCode200) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print("Something went Wrong ${e}");
  //     showSnackBar(context, "Something went Wrong.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
}
