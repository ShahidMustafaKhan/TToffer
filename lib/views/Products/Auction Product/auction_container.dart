import 'package:dialogs/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/detail_model/attribute_model.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';

import '../../../config/keys/pref_keys.dart';
import '../../../models/product_model.dart';
import '../../../view_model/product/product/product_viewmodel.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';
import '../Feature Product/feature_container.dart';

class AuctionProductContainer extends StatefulWidget {
  Product? product;

   AuctionProductContainer({super.key, this.product});

  @override
  State<AuctionProductContainer> createState() =>
      _AuctionProductContainerState();
}

class _AuctionProductContainerState extends State<AuctionProductContainer> {

  bool isLoading = false;

  int? userId;
  String? authorizationToken;

  late bool wishItem;
  Product? product;

  getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
      userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
      authorizationToken = pref.getString(PrefKey.authorization);
  }



  @override
  void initState() {
    product = widget.product;
    getUserId();
    super.initState();
  }


  DateTime _parseEndingDateTime() {
    String? endingTimeString = product?.auctionEndingTime;
    String? endingDateString = product?.auctionEndingDate;
    DateTime endingDate =
        DateFormat("yyyy-MM-dd").parse(endingDateString!);
    DateTime endingTime;

    if (endingTimeString!.contains("PM") || endingTimeString.contains("AM")) {
      endingTime = DateFormat("h:mm a").parse(endingTimeString);
      if (kDebugMode) {
        print(" vkrvlrvm$endingTime");
      }
    } else {
      endingTime = DateFormat("HH:mm").parse(endingTimeString);
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

    product = widget.product;
    getUserId();


    VehicleAttributes vehicleAttributes =
        VehicleAttributes.fromJson(product?.attributes);
    PropertyAttributes propertyAttributes =
        PropertyAttributes.fromJson(product?.attributes);
        // PropertyAttributes.fromJson(widget.data['attributes']);


    final productViewModel = Provider.of<ProductViewModel>(context, listen: false);


    Product? productTemp = productViewModel.auctionProductList.data?.data?.productList
        ?.firstWhere(
          (item) => item.id == product?.id,);

    widget.product = productTemp;


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
              image: (product?.photo?.isNotEmpty ?? false)
                  ? DecorationImage(
                image:
                NetworkImage("${product?.photo?[0].url}"),
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
                      if(isProductBoosted(product?.boosterEndDatetime))
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
                        Consumer<UserViewModel>(
                            builder: (context, userViewModel , child) {
                              return GestureDetector(
                              behavior: HitTestBehavior.deferToChild,
                              onTap: () {
                                userViewModel.toggleWishList(userId, product?.id, context);
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
                                      child: userViewModel.isProductInWishList(product?.id) == false
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
                            );
                          }
                        ),
                    ],
                  ),
                  CustomPaint(
                      painter: PriceTagPainter(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 14),
                        child: AppText.appText(
                            productPrice(product),
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
                                      child: AppText.appText(product?.title ?? '',
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w700,
                                          textColor: AppTheme.textColor),
                                    ),

                                    if(product?.category?.name == 'Property for Sale' ||
                                        product?.category?.name
                                            == 'Property for Rent' || product?.category?.name == 'Vehicles')
                                      product?.category?.name == 'Vehicles'
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ImageText(
                                              txt: vehicleAttributes.makeModel == '' ? '0' : vehicleAttributes.makeModel,
                                              image: 'calender.png'),
                                          SizedBox(width: 5.w,),
                                          ImageText(
                                              txt: vehicleAttributes.mileAge == '' ? '0' : vehicleAttributes.mileAge,
                                              image: 'road.png'),
                                          SizedBox(width: 5.w,),
                                          ImageText(
                                              txt: vehicleAttributes.fuelType == '' ? '0' : vehicleAttributes.fuelType,
                                              image: 'petrol.png'),
                                        ],
                                      )
                                          : product?.category?.name == 'Property for Sale' ||
                                          product?.category?.name == 'Property for Rent'
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,

                                        children: [
                                          ImageText(
                                              txt: propertyAttributes.bathroom == '' ? "0" : propertyAttributes.bathroom,
                                              image: 'bath.png'),
                                          SizedBox(width: 5.w,),
                                          ImageText(
                                              txt: propertyAttributes.bedroom == '' ? "0" : propertyAttributes.bedroom,
                                              image: 'bed.png'),
                                          SizedBox(width: 5.w,),
                                          ImageText(
                                              txt: propertyAttributes.area == '' ? "0" : propertyAttributes.area,
                                              image: 'family.png'),
                                        ],
                                      )
                                          : const SizedBox.shrink(),


                                    if(product?.category?.name != 'Property for Sale' &&
                                        product?.category?.name
                                            != 'Property for Rent' && product?.category?.name != 'Vehicles')
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
                                          child: AppText.appText(product?.location ?? '',
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
                                        if(product?.user?.id?.toString() != userId.toString()){
                                          push(context, AuctionInfoScreen(product: product));}
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
    const dubaiTimeZoneOffset = Duration(hours: 0);

    // Calculate the difference between user time zone and Dubai time zone
    Duration timeDifference = userTimeZoneOffset - dubaiTimeZoneOffset;

    // Add or subtract the time difference to the endTime
    return endTime.add(timeDifference);
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
