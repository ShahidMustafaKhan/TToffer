import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_info.dart';

import '../../../config/keys/pref_keys.dart';
import '../../../main.dart';
import '../../../models/product_model.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';

class AuctionProductContainer extends StatelessWidget {
  Product? product;

   AuctionProductContainer({super.key, this.product});

  bool isLoading = false;

  int? userId;

  String? authorizationToken;

  late bool wishItem;

  Timer? _timer;

  getUserId() async {
      userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
      authorizationToken = pref.getString(PrefKey.authorization);
  }

  @override
  Widget build(BuildContext context) {
    getUserId();
    ValueNotifier<int> remainingTimeNotifier = ValueNotifier(0);

    DateTime? endDateTime;
    DateTime? now = DateTime.now();

    if(product?.auctionEndingDateTime != null) {
      endDateTime = convertEndTimeToUserTimeZone(product!.auctionEndingDateTime!);
      remainingTimeNotifier.value = endDateTime.difference(now).inSeconds;
      startAuctionTimer(_timer, remainingTimeNotifier, context);
    }
    else{
      remainingTimeNotifier.value = 0;
    }

    return Container(
      width: 165.w,
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.red)
      ),
      // height: 370,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150.h,
            decoration: BoxDecoration(
              color: AppTheme.hintTextColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.r),
                topRight: Radius.circular(7.r),
              ),
              // borderRadius: BorderRadius.circular(8.r),
              image: (product?.photo?.isNotEmpty ?? false)
                  ? DecorationImage(
                image:
                NetworkImage("${product?.photo?[0].url}"),
                fit: BoxFit.cover,
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
                      specialOffer(product),
                      if(authorizationToken != null && userId != product?.userId)
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
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 14),
                    child: priceTag(product))

                ],
              ),
            ),
          ),
          Expanded(
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


                                  if(product?.deliveryType?.isNotEmpty ?? false)
                                    shippingMethodIconWidget(product),

                                    if(endDateTime != null)
                                      ValueListenableBuilder<int>(
                                          valueListenable: remainingTimeNotifier,
                                          builder: (context, remainingTime, child) {
                                            return Padding(
                                          padding: EdgeInsets.only(bottom: (product?.deliveryType?.isNotEmpty ?? false) ? 3.h : 0),
                                          child: auctionTimerCounter(endDateTime),
                                          );
                                      }
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
                                        child: AppText.appText(extractCity(product?.location ?? ''),
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
          )



        ],
      ),
    );
  }


}

class ImageText extends StatefulWidget {
  String? image;
  String? txt;

  ImageText({super.key, this.txt, this.image});

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
