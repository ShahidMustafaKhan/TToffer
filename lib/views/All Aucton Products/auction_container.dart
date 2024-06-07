import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';

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
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.appColor),
          borderRadius: BorderRadius.circular(10)),
      // height: 370,
      width: 175,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              height: 140,
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
            const SizedBox(height: 12),
            AppText.appText("\$${widget.data["auction_price"]}",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppTheme.textColor),
            const SizedBox(height: 5),

            SizedBox(
              // height: 40,
              width: MediaQuery.sizeOf(context).width * .4,
              child: AppText.appText("${widget.data["title"]}",
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  textColor: AppTheme.textColor),
            ),

            const SizedBox(height: 3),
            Row(
              children: [
                ImageText(txt: '2012', image: 'calender.png'),
                ImageText(txt: '4500Km', image: 'road.png'),
                ImageText(txt: 'Petrol', image: 'petrol.png'),
              ],
            ),
            const SizedBox(height: 3),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //
            //     AppText.appText("${widget.data["auction"].length} Bid Now",
            //         fontSize: 12,
            //         fontWeight: FontWeight.w200,
            //         textColor: AppTheme.textColor),
            //   ],
            // ),

            const SizedBox(height: 4),

            Row(
              children: [
                Image.asset(
                  'assets/images/location.png',
                  height: 14,
                  width: 14,
                ),
                const SizedBox(width: 5),
                AppText.appText("${widget.data["location"]}",
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.black45),
              ],
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     AppText.appText("Time Left:",
            //         fontSize: 12,
            //         fontWeight: FontWeight.w700,
            //         textColor: AppTheme.textColor),
            //     SizedBox(
            //       width: 80,
            //       child: AppText.appText(getTimeLeftString(),
            //           fontSize: 12,
            //           overflow: TextOverflow.ellipsis,
            //           fontWeight: FontWeight.w600,
            //           textColor: AppTheme.appColor),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 10),
            Expanded(
              child: AppButton.appButton("Bid Now", onTap: () {
                getAuctionProductDetail(productId: widget.data["id"]);
              },
                  height: 50,
                  width: 161,
                  radius: 16.0,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  backgroundColor: AppTheme.appColor,
                  textColor: AppTheme.whiteColor),
            ),
            const SizedBox(height: 10),
          ],
        ),
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

class ImageText extends StatefulWidget {
  String? image;
  String? txt;

  ImageText({this.txt, this.image});

  @override
  State<ImageText> createState() => _ImageTextState();
}

class _ImageTextState extends State<ImageText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/${widget.image}'),
        SizedBox(width: widget.image == 'calender.png' ? 5 : 5),
        AppText.appText(widget.txt!, fontSize: 10, textColor: Colors.black54),
        const SizedBox(width: 6)
      ],
    );
  }
}
