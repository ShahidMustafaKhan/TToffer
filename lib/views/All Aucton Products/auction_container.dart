import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Constants/app_logger.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/views/Auction%20Info/auction_info.dart';

import '../../config/keys/pref_keys.dart';
import '../All Featured Products/feature_container.dart';

class AuctionProductContainer extends StatefulWidget {
   var data;

   AuctionProductContainer({super.key, this.data});

  @override
  State<AuctionProductContainer> createState() =>
      _AuctionProductContainerState();
}

class _AuctionProductContainerState extends State<AuctionProductContainer> {
  late AppDio dio;
  AppLogger logger = AppLogger();
  bool isLoading = false;

  var userId;
  String? authorizationToken;

  late bool wishItem;

  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString(PrefKey.userId);
      authorizationToken = pref.getString(PrefKey.authorization);
    });
  }

  ProductsApiProvider? apiProvider;


  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    getUserId();


     apiProvider =
    Provider.of<ProductsApiProvider>(context, listen: false);

    if(widget.data!=null && widget.data["wishlist"]!=null) {
      isFav = widget.data["wishlist"].isNotEmpty
          ? true
          : false;
    }
    // apiProvider!.getCatagories(
    //   dio: dio,
    //   context: context,
    // );
    // apiProvider!.getAuctionProducts(
    //   dio: dio,
    //   context: context,
    // );
    // apiProvider!.getFeatureProducts(
    //   dio: dio,
    //   context: context,
    // );
    if(widget.data!=null && widget.data["wishlist"]!=null) {
    wishItem = widget.data["wishlist"].isNotEmpty
        ? true
        : false;}



    super.initState();
  }


  addOrRemoveWishItem(){
    wishItem = !wishItem;
    setState(() {

    });
  }

  addOrRemoveWishItemFromDB(){
    widget.data["wishlist"].isNotEmpty
        ? removeFavourite(
        wishId: widget.data["wishlist"][0]["id"])
        : addToFavourite();
  }


  DateTime _parseEndingDateTime() {
    String? endingTimeString = widget.data["ending_time"];
    String? endingDateString = widget.data["ending_date"];
    DateTime endingDate =
        DateFormat("yyyy-MM-dd").parse("${widget.data["ending_date"]}");
    DateTime endingTime;

    if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse("${widget.data["ending_time"]}");
      if (kDebugMode) {
        print(" vkrvlrvm$endingTime");
      }
    } else {
      endingTime = DateFormat("HH:mm").parse("${widget.data["ending_time"]}");
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

  @override
  Widget build(BuildContext context) {
    VehicleAttributes vehicleAttributes =
        VehicleAttributes.fromJson(widget.data["attributes"]);
    PropertyAttributes propertyAttributes =
        PropertyAttributes.fromJson(widget.data["attributes"]);
        // PropertyAttributes.fromJson(widget.data['attributes']);


    final allAuctionProducts = Provider.of<ProductsApiProvider>(context, listen: false).allauctionProductsData;

    final product = allAuctionProducts.firstWhere((item) => item['id'] == widget.data["id"], orElse: () => null);

    widget.data = product;

    if(widget.data!=null && widget.data["wishlist"]!=null) {
      isFav = widget.data["wishlist"].isNotEmpty
        ? true
        : false;
    }



    return Container(
      width: 165.w,
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(8.r)),
      // height: 370,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150.h,
            decoration: BoxDecoration(
              color: AppTheme.hintTextColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              // borderRadius: BorderRadius.circular(8.r),
              image: widget.data["photo"].isNotEmpty
                  ? DecorationImage(
                image:
                NetworkImage("${widget.data["photo"][0]["src"]}"),
                fit: BoxFit.fill,
              )
                  : null,
            ),
            child: Padding(
              padding : EdgeInsets.only(top: 7.h, bottom: 10.h, left: 0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(isProductBoosted(widget.data["booster_end_datetime"]))
                        Container(
                          margin: EdgeInsets.only(top: 6.h, left: 8.w),
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFD33C),
                            borderRadius: BorderRadius.all(Radius.circular(8.r)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15), // Soft black shadow with 15% opacity
                                offset: const Offset(0, 4),                  // Shadow positioned slightly below the container
                                blurRadius: 4,                         // Moderate blur for a soft shadow effect
                                spreadRadius: 0,                       // Slight spread to enhance the visibility
                              ),
                            ],
                          ),
                          child: AppText.appText('Special Offer', fontSize: 10.sp, fontWeight: FontWeight.w500, textColor: AppTheme.textColor ),
                        )
                      else
                        SizedBox(),


                      if(authorizationToken != null)
                        GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onTap: () {
                            // addOrRemoveWishItem();
                            addOrRemoveWishItemFromDB();
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 6.h, right: 8.w),
                              child: Container(
                                  height: 23.w,
                                  width: 23.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: AppTheme.whiteColor),
                                  child: isFav==false
                                      ? Icon(
                                    Icons.favorite_border,
                                    size: 15.w,
                                    color: AppTheme.textColor,
                                  )
                                      : Icon(
                                    size: 15.w,
                                    Icons.favorite_sharp,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        ),
                    ],
                  ),
                  CustomPaint(
                      painter: PriceTagPainter(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 14),
                        child: AppText.appText(
                            "AED ${abbreviateNumber(widget.data["auction_price"] ?? '')}",
                            textColor: Colors.white,
                            fontSize: 14.sp

                        ),))

                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppTheme.borderColorContainer),
                  right: BorderSide(color: AppTheme.borderColorContainer),
                  bottom: BorderSide(color: AppTheme.borderColorContainer),
                ),),
              child: Column(
                children: [
                  const SizedBox(height: 9),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            // decoration : BoxDecoration(border: Border.all(color: Colors.red)),
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.h, left: 8, right: 8),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    SizedBox(
                                      // height: 40,
                                      width: MediaQuery.sizeOf(context).width * .4,
                                      child: AppText.appText("${widget.data["title"]}",
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w700,
                                          textColor: AppTheme.textColor),
                                    ),

                                    if(propertyAttributes.catName == 'Property for Sale' ||
                                        propertyAttributes.catName
                                            == 'Property for Rent' || vehicleAttributes.catName == 'Vehicles')
                                      vehicleAttributes.catName == 'Vehicles'
                                          ? Row(
                                        children: [
                                          ImageText(
                                              txt: vehicleAttributes.makeModel,
                                              image: 'calender.png'),
                                          ImageText(
                                              txt: vehicleAttributes.mileAge, image: 'road.png'),
                                          ImageText(
                                              txt: vehicleAttributes.FuelType, image: 'petrol.png'),
                                        ],
                                      )
                                          : propertyAttributes.catName == 'Property for Sale' ||
                                          propertyAttributes.catName == 'Property for Rent'
                                          ? Row(
                                        children: [
                                          ImageText(
                                              txt: propertyAttributes.bathroom == '' ? "0" : propertyAttributes.bathroom,
                                              image: 'bath.png'),
                                          ImageText(
                                              txt: propertyAttributes.bedroom == '' ? "0" : propertyAttributes.bedroom,
                                              image: 'bed.png'),
                                          ImageText(
                                              txt: propertyAttributes.area == '' ? "0" : propertyAttributes.area,
                                              image: 'family.png'),
                                        ],
                                      )
                                          : const SizedBox.shrink(),


                                    if(propertyAttributes.catName != 'Property for Sale' &&
                                        propertyAttributes.catName
                                            != 'Property for Rent' && vehicleAttributes.catName != 'Vehicles')
                                      SizedBox(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            AppText.appText("Time Left:",
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                textColor: AppTheme.yellowColor),
                                            SizedBox(width: 5.w,),
                                            Expanded(
                                              child: SizedBox(
                                                child: AppText.appText(getTimeLeftString(),
                                                    fontSize: 11,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w600,
                                                    textColor: AppTheme.yellowColor),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),



                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/location.png',
                                          height: 14,
                                          width: 14,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: AppText.appText(widget.data["location"],
                                              fontSize: 10,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w700,
                                              textColor: Colors.black45),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                                      child: AppButton.appButton("Bid Now", onTap: () {
                                        if(widget.data["user_id"] != userId.toString()){
                                          getAuctionProductDetail(productId: widget.data["id"]);}
                                        else{
                                          showSnackBar(context, 'You can\'t place a bid on your own product.');
                                        }
                                      },
                                          height: 32,
                                          radius: 16.0,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          backgroundColor: AppTheme.appColor,
                                          textColor: AppTheme.whiteColor),
                                    ),

                                  ]),
                            ),
                          ),
                        ),
            

                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          )



        ],
      ),
    );
  }

  bool isFav = false;


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
    DateTime? endTime = convertEndTimeToUserTimeZone(_parseEndingDateTime());

    if (endTime == null) {
      return 'Invalid date/time';
    }

    if (kDebugMode) {
      print('endTime $endTime');
    }


    Duration timeLeft = endTime.difference(DateTime.now());

    if (timeLeft.isNegative) {
      return 'Time Ends';
    }

    if (timeLeft.inHours < 24) {
      int hours = timeLeft.inHours;
      int minutes = timeLeft.inMinutes.remainder(60);
      return '$hours H $minutes M';
    } else {
      int days = timeLeft.inDays;
      int hours = timeLeft.inHours % 24;
      int minutes = timeLeft.inMinutes.remainder(60);
      return '$days D $hours H $minutes M';
    }
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

  void addToFavourite() async {
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
    Map<String, dynamic> params = {
      "user_id": userId,
      "product_id": widget.data["id"],
    };
    try {
      response = await dio.post(path: AppUrls.adddToFavorite, data: params);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'}");
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'} ");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'}");

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
          isFav = true;
          wishItem = true;


          apiProvider!.getAuctionProducts(
            dio: dio,
            context: context,
          );
          // apiProvider!.getFeatureProducts(
          //   dio: dio,
          //   context: context,
          // );

          // getAuctionProductDetail();
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

  void removeFavourite({wishId}) async {
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
    Map<String, dynamic> params = {
      "id": wishId,
      // "product_id": widget.detailResponse["id"],
    };
    try {
      response = await dio.post(path: AppUrls.removeFavorite, data: params);
      var responseData = response.data;

      // apiProvider!.getFeatureProducts(
      //   dio: dio,
      //   context: context,
      // );

      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'}");
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'} ");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"] ?? 'Something went wrong'}");

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
          isFav = false;
          wishItem = false;


          apiProvider!.getAuctionProducts(
            dio: dio,
            context: context,
          );
          // apiProvider!.getFeatureProducts(
          //   dio: dio,
          //   context: context,
          // );

          // getAuctionProductDetail();
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
        Image.asset(
          'assets/images/${widget.image}',
          height: widget.image == 'family.png' ? 10 : 10,
          width: widget.image == 'family.png' ? 10 : 12,
        ),
        SizedBox(width: widget.image == 'calender.png' ? 5 : 5),
        AppText.appText(widget.txt!, fontSize: 8.5, textColor: Colors.black54),
        const SizedBox(width: 6)
      ],
    );
  }
}
