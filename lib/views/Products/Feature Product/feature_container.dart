import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/detail_model/attribute_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_container.dart';

import '../../../Utils/utils.dart';
import '../../../models/product_model.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';

class FeatureProductContainer extends StatefulWidget {
  final Product? product;

   const FeatureProductContainer({super.key, this.product});

  @override
  State<FeatureProductContainer> createState() =>
      _FeatureProductContainerState();
}

class _FeatureProductContainerState extends State<FeatureProductContainer> {
  String timeDifference = ''; // Store the calculated time difference
  int? userId;
  String? authorizationToken;
  bool isFav = false;


  Product? product;


  getUserId() async {
      userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
      authorizationToken = pref.getString(PrefKey.authorization);
  }


  @override
  void initState() {
    super.initState();

    product = widget.product;

    getUserId();
    if(product?.createdAt != null){
    DateTime dateTime = DateTime.parse(product?.createdAt ?? '');
    timeDifference = calculateTimeDifference(dateTime);
    }
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



  @override
  Widget build(BuildContext context) {

    product = widget.product;

    getUserId();
    if(product?.createdAt != null){
      DateTime dateTime = DateTime.parse(product?.createdAt ?? '');
      timeDifference = calculateTimeDifference(dateTime);
    }

    VehicleAttributes vehicleAttributes =
        VehicleAttributes.fromJson(product?.attributes);
    PropertyAttributes propertyAttributes =
    PropertyAttributes.fromJson(product?.attributes);



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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: product?.photo?.isNotEmpty ?? false
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
                                    height: 22.w,
                                    width: 22.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: AppTheme.whiteColor),
                                    child: userViewModel.isProductInWishList(product?.id) == false
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
                          );
                        }
                      ),
                    ],
                  ),
                  CustomPaint(
                      painter: PriceTagPainter(),
                      child: Padding(
                        padding: EdgeInsets.only(left: product?.productType == 'looking' || product?.productType == 'hiring' ? 18 : 24, right: product?.productType == 'looking' || product?.productType == 'hiring'  ? 5 : 14),
                        child: AppText.appText(
                            productPrice(product),
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
                    SizedBox(
                      // height: 40,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: AppText.appText(product?.title ?? '',
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          textColor: AppTheme.textColor),
                    ),


                    if(product?.category?.name == 'Property for Sale' ||
                        product?.category?.name
                            == 'Property for Rent' || product?.category?.name == 'Vehicles')
                      product?.category?.name == 'Vehicles'
                          ? Row(
                        children: [
                          ImageText(
                              txt: vehicleAttributes.makeModel == '' ? '0' : vehicleAttributes.makeModel,
                              image: 'calender.png'),
                          ImageText(
                              txt: vehicleAttributes.mileAge == '' ? '0' : vehicleAttributes.mileAge,
                              image: 'road.png'),
                          ImageText(
                              txt: vehicleAttributes.fuelType == '' ? '0' : vehicleAttributes.fuelType,
                              image: 'petrol.png'),
                        ],
                      )
                          : product?.category?.name == 'Property for Sale' ||
                          product?.category?.name == 'Property for Rent'
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
                              fontSize: 11,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                              textColor: Colors.black45),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5),

                    if(product?.category?.name != 'Property for Sale' &&
                        product?.category?.name
                            != 'Property for Rent' && product?.category?.name  != 'Vehicles')
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: AppText.appText(timeAgo(product?.createdAt),
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



        ],
      ),
    );
  }





  bool isLoading = false;

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