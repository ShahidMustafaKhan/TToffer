import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/detail_model/attribute_model.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/views/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/views/Products/Auction%20Product/auction_container.dart';

import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_button.dart';
import '../../../models/cart_model.dart';
import '../../../models/product_model.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';

class FeatureProductContainer extends StatelessWidget {
  Product? product;
  bool fromHomePage;

   FeatureProductContainer({super.key, this.product, this.fromHomePage = false});

  String timeDifference = '';
 // Store the calculated time difference
  int? userId;

  String? authorizationToken;

  bool isFav = false;

  getUserId() async {
      userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
      authorizationToken = pref.getString(PrefKey.authorization);
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
          border: Border.all(color: Colors.red)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135.h,
            decoration: BoxDecoration(
              color: AppTheme.hintTextColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.r),
                topRight: Radius.circular(7.r),
              ),
              image: product?.photo?.isNotEmpty ?? false
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
                  Padding(
                      padding: const EdgeInsets.only(left: 12, right: 14),
                      child: priceTag(product))

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
                      child: AppText.appText(product?.title ?? '',
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w700,
                          textColor: AppTheme.textColor),
                    ),

                    if(product?.deliveryType?.isNotEmpty ?? false)
                      shippingMethodIconWidget(product),
                    

                    if(product?.category?.name == 'Property for Sale' ||
                        product?.category?.name
                            == 'Property for Rent' || product?.category?.name == 'Vehicles')
                      product?.category?.name == 'Vehicles'
                          ? Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ImageText(
                              txt: vehicleAttributes.makeModel == '' || vehicleAttributes.makeModel.contains('null') ? '0' : vehicleAttributes.makeModel,
                              image: 'calender.png'),
                          SizedBox(width: 5.w,),
                          ImageText(
                              txt: vehicleAttributes.mileAge == '' || vehicleAttributes.mileAge.contains('null') ? '0' : vehicleAttributes.mileAge,
                              image: 'road.png'),
                          SizedBox(width: 5.w,),
                          ImageText(
                              txt: vehicleAttributes.fuelType == '' || vehicleAttributes.fuelType.contains('null') ? '0' : vehicleAttributes.fuelType,
                              image: 'petrol.png'),
                        ],
                      )
                          : product?.category?.name == 'Property for Sale' ||
                          product?.category?.name == 'Property for Rent'
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          ImageText(
                              txt: propertyAttributes.bathroom == '' || propertyAttributes.bathroom.contains('null') ? "0" : propertyAttributes.bathroom,
                              image: 'bath.png'),
                          SizedBox(width: 5.w,),
                          ImageText(
                              txt: propertyAttributes.bedroom == '' || propertyAttributes.bedroom.contains('null') ? "0" : propertyAttributes.bedroom,
                              image: 'bed.png'),
                          SizedBox(width: 5.w,),
                          ImageText(
                              txt: propertyAttributes.area == '' || propertyAttributes.area.contains('null') ? "0" : propertyAttributes.area,
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
                          child: AppText.appText(extractCity(product?.location ?? ''),
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
                            != 'Property for Rent' && product?.category?.name  != 'Vehicles' && fromHomePage == false)
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

                    if(fromHomePage == true && enableCartButton(product))
                    Consumer<CartViewModel>(
                        builder: (context, cartViewModel, child) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.w),
                            child: AppButton.appButton(cartViewModel.isProductInCart(product?.id) == true ? "Added in cart" : "Add to Cart",
                                onTap: () {
                                  if(userId != product?.userId){
                                    if(authorizationToken == null){
                                      push(context, const SigInScreen());
                                    }
                                    else{
                                      if(cartViewModel.isProductInCart(product?.id) == true ){
                                        cartViewModel.removeCartItem(
                                           product?.id,
                                           userId,
                                           );
                                      }
                                      else{
                                        cartViewModel.addCartItemInList(Cart(
                                          userId: userId,
                                          productId: product?.id,
                                          user: product?.user,
                                          product: product,
                                        ));
                                        cartViewModel.addCartItem(
                                            productId : product?.id,
                                            price : product?.fixPrice,
                                            quantity: 1,
                                            userId: userId,
                                            callGetCartApi: true);
                                      }

                                    }
                                  }

                            },
                                height: 32,
                                radius: 16.0,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                backgroundColor: AppTheme.appColor,
                                textColor: AppTheme.whiteColor),
                          );
                      }
                    ),


                  ]),
            ),
          ),
          SizedBox(height: 6.h,)



        ],
      ),
    );
  }

  bool isLoading = false;
}

