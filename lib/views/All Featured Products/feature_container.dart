import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/detail_model/property_for_sale_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/views/All%20Aucton%20Products/auction_container.dart';

import '../../Utils/utils.dart';
import '../../config/dio/app_dio.dart';

class FeatureProductContainer extends StatefulWidget {
  var data;

   FeatureProductContainer({this.data});

  @override
  State<FeatureProductContainer> createState() =>
      _FeatureProductContainerState();
}

class _FeatureProductContainerState extends State<FeatureProductContainer> {
  String timeDifference = ''; // Store the calculated time difference
  var userId;
  String? authorizationToken;
  bool isFav = false;
  late final dio;


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
    super.initState();
    dio = AppDio(context);
    apiProvider = Provider.of<ProductsApiProvider>(context, listen: false);

    if(widget.data!=null && widget.data["wishlist"]!=null) {
    isFav = widget.data["wishlist"].isNotEmpty
        ? true
        : false;}


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

    getUserId();
    // Convert API date to DateTime
    DateTime dateTime = DateTime.parse("${widget.data["created_at"]}");
    // Calculate time difference
    timeDifference = calculateTimeDifference(dateTime);
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

  addOrRemoveWishItemFromDB(){
    widget.data["wishlist"].isNotEmpty
        ? removeFavourite(
        wishId: widget.data["wishlist"][0]["id"])
        : addToFavourite();
  }

  @override
  Widget build(BuildContext context) {
    VehicleAttributes vehicleAttributes =
        VehicleAttributes.fromJson(widget.data["attributes"]);
    PropertyAttributes propertyAttributes =
        PropertyAttributes.fromJson(widget.data["attributes"]);

    if(widget.data!=null && widget.data["wishlist"]!=null) {
      isFav = widget.data["wishlist"].isNotEmpty
        ? true
        : false;
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppTheme.borderColorContainer)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135.h,
            decoration: BoxDecoration(
              color: AppTheme.hintTextColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
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
                                height: 22.w,
                                width: 22.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: AppTheme.whiteColor),
                                child: isFav==false
                                    ? Icon(
                                  Icons.favorite_border,
                                  size: 14.w,
                                  color: AppTheme.textColor,
                                )
                                    : Icon(
                                  size: 14.w,
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
                            "AED ${abbreviateNumber(widget.data["fix_price"] ?? '')}",
                          textColor: Colors.white,
                          fontSize: 14.sp

                        ),))

                ],
              ),
            ),
          ),
          const SizedBox(height: 11),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppText.appText("AED ${formatNumber(removeLastTwoZeros(widget.data["fix_price"] ?? ''))}",
                    //     fontSize: 17,
                    //     fontWeight: FontWeight.w700,
                    //     textColor: AppTheme.textColor),
                    // const SizedBox(height: 5),

                    SizedBox(
                      // height: 40,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: AppText.appText("${widget.data["title"]}",
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          textColor: AppTheme.textColor),
                    ),

                    // const SizedBox(height: 3),


                    if(propertyAttributes.catName == 'Property for Sale' ||
                        propertyAttributes.catName
                            == 'Property for Rent' || vehicleAttributes.catName == 'Vehicles')
                      vehicleAttributes.catName == 'Vehicles'
                          ? Row(
                        children: [
                          ImageText(
                              txt: vehicleAttributes.year, image: 'calender.png'),
                          ImageText(
                              txt: vehicleAttributes.mileAge, image: 'road.png'),
                          ImageText(
                              txt: vehicleAttributes.FuelType,
                              image: 'petrol.png'),
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

                    // if(propertyAttributes.catName != 'Property for Sale' &&
                    //     propertyAttributes.catName
                    //         != 'Property for Rent' && vehicleAttributes.catName != 'Vehicles')
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       AppText.appText("Member since: ${formatYear(widget.data["created_at"])}",
                    //           fontSize: 12.sp,
                    //           fontWeight: FontWeight.w700,
                    //           textColor: AppTheme.textColor),
                    //     ],
                    //   ),


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
                              fontSize: 11,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.black45),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5),

                    if(propertyAttributes.catName != 'Property for Sale' &&
                        propertyAttributes.catName
                            != 'Property for Rent' && vehicleAttributes.catName != 'Vehicles')
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: AppText.appText(timeAgo(widget.data["created_at"]),
                                fontSize: 11,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w700,
                                textColor: Colors.black45),
                          ),
                        ],
                      ),


                  ]),
            ),
          ),
          SizedBox(height: 5.h,)






          // AppText.appText(
          //   "${widget.data["title"]}",
          //   fontSize: 14,
          //   fontWeight: FontWeight.w500,
          //   textColor: AppTheme.textColor,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     AppText.appText(
          //       "\$${widget.data["fix_price"]}",
          //       fontSize: 14,
          //       fontWeight: FontWeight.w700,
          //       textColor: AppTheme.textColor,
          //     ),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Icon(
          //           Icons.location_on_outlined,
          //           color: AppTheme.textColor,
          //           size: 20,
          //         ),
          //         SizedBox(
          //           width: 50,
          //           child: AppText.appText(
          //             "${widget.data["location"]}",
          //             fontSize: 12,
          //             fontWeight: FontWeight.w400,
          //             overflow: TextOverflow.ellipsis,
          //             textColor: AppTheme.textColor,
          //           ),
          //         )
          //       ],
          //     ),
          //     SizedBox(
          //       width: 100,
          //       child: AppText.appText(
          //         overflow: TextOverflow.ellipsis,
          //         timeDifference,
          //         fontSize: 11,
          //         fontWeight: FontWeight.w600,
          //         textColor: AppTheme.appColor,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }





  bool isLoading = false;


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
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

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
          // isFav = true;

          apiProvider!.getFeatureProducts(
            dio: dio,
            context: context,
          );

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
      // apiProvider!.getAuctionProducts(
      //   dio: dio,
      //   context: context,
      // );


      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      } else if (response.statusCode == responseCode401) {
        showSnackBar(context, "${responseData["msg"]}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["msg"]}");

        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["msg"]}");

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
          // isFav = false;

          apiProvider!.getFeatureProducts(
            dio: dio,
            context: context,
          );

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
class PriceTagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xff039b73)
      ..style = PaintingStyle.fill;

    // Draw rounded rectangle for tag background with custom corners
    final RRect background = RRect.fromRectAndCorners(
      Rect.fromLTWH(10, 0, size.width - 10, size.height),
      topLeft: Radius.circular(25), // More rounded left side
      bottomLeft: Radius.circular(25),
      topRight: Radius.circular(4), // Less rounded right side
      bottomRight: Radius.circular(4),
    );
    canvas.drawRRect(background, paint);

    // Draw small white circle on the left
    // final Paint dotPaint = Paint()..color = Colors.white;
    // canvas.drawCircle(Offset(10, size.height / 2), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}