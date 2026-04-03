import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/config/keys/pref_keys.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/data/response/api_response.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/coupon/coupon_viewmodel.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';
import 'package:tt_offer/views/Payment/stripe_payment_screen.dart';
import '../../../main.dart';
import '../../../view_model/banner/banner_view_model.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../view_model/profile/user_profile/user_view_model.dart';
import '../../Payment/payment_sucess_screen.dart';
import '../coupon/coupon_screen.dart';


class CheckOutScreen extends StatefulWidget {
  final List<Cart>? items;
  final bool fromAccountInfo;
  const CheckOutScreen({super.key, this.items, this.fromAccountInfo=false});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  late int total;
  late int subTotal;
  late int numberOfItems;
  int? userId;

  List<Cart>? items;


  @override
  void initState() {
    items = widget.items;
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');

    getTotalAmount(items);
    super.initState();
  }

  void getTotalAmount(List<Cart>? item, {double? discount}) {
    numberOfItems = 0;
    total = 0;
    subTotal = 0;

    if (item != null && item.isNotEmpty) {
      for (var element in item) {
        if (element.product != null && element.product!.fixPrice != null) {
          total += int.parse(element.product!.fixPrice!.toString()) * (element.product?.qty ?? element.qty ?? 1);
          numberOfItems++;
        }
      }
      subTotal =
          total; // Assuming subTotal is meant to be the same as total initially
    } else {
      total = 0;
      numberOfItems = 0;
    }

    // Subtract discount if it's not null
    if (discount != null) {
      subTotal -= discount.floor();
      if (subTotal < 0) {
        subTotal = 0; // Ensure subtotal does not go negative
      }
    }

    // Update UI if any state variables have changed
  }


  @override
  Widget build(BuildContext context) {
    getTotalAmount(items);

    return PopScope(
      canPop: widget.fromAccountInfo == true ? false : true,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          if (widget.fromAccountInfo == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar1(
          title: "Checkout",
          backButtonTap: () {
            if (widget.fromAccountInfo == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            }
            else {
              Navigator.of(context).pop();
            }
          },
        ),
        body: Consumer<CartViewModel>(
            builder: (context, cartViewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<BannerViewModel>(
                              builder: (context, bannerViewModel, child) {
                                return bannerViewModel.firstBanner.isNotEmpty
                                    ? CarouselSlider(
                                  options: CarouselOptions(
                                    aspectRatio: 16 / 4,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(
                                        seconds: 3),
                                    autoPlayAnimationDuration: const Duration(
                                        milliseconds: 1000),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: bannerViewModel.firstBanner.map((
                                      String? banner) {
                                    return InkWell(
                                      onTap: () async {
                                        // String? url = banner.redirect;
                                        //
                                        // if (url != null) {
                                        //   if (await canLaunchUrl(
                                        //       Uri.parse(url))) {
                                        //     await launchUrl(Uri.parse(url),
                                        //         mode: LaunchMode
                                        //             .externalApplication);
                                        //   } else {
                                        //     showSnackBar(context,
                                        //         "Could not launch the URL");
                                        //   }
                                        // }
                                      },
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double screenWidth = MediaQuery
                                              .of(context)
                                              .size
                                              .width;
                                          double bannerHeight = screenWidth *
                                              (7 / 16);

                                          return Container(
                                            height: bannerHeight,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: banner ?? '',
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) =>
                                                  Center(
                                                    child: SizedBox(
                                                      height: 30.h,
                                                      child: CircularProgressIndicator(
                                                          color: AppTheme
                                                              .yellowColor),
                                                    ),
                                                  ),
                                              errorWidget: (context, url,
                                                  error) => const SizedBox(),
                                              cacheKey: banner,
                                              fadeInDuration: const Duration(
                                                  milliseconds: 500),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                )
                                    : const SizedBox();
                              }
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(cartViewModel.shippingDetails.data !=
                                    null)...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8.h, top: 4.h),
                                        child: AppText.appText('Ship to',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                            textColor: AppTheme.textColor),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              AppText.appText(Provider
                                                  .of<UserViewModel>(
                                                  context, listen: false)
                                                  .userModel
                                                  .data
                                                  ?.name ?? '',
                                                  fontSize: 11.5.sp),
                                              AppText.appText(cartViewModel.shippingDetails.data?.address ?? '', fontSize: 11.5.sp),
                                              AppText.appText(cartViewModel.shippingDetails.data?.state ?? '', fontSize: 11.5.sp),
                                              AppText.appText("${cartViewModel.shippingDetails.data?.city?.name ?? ''}, ${cartViewModel.shippingDetails.data?.country?.name ?? ''}", fontSize: 11.5.sp),
                                              AppText.appText(
                                                  cartViewModel.shippingDetails
                                                      .data?.phoneNo ?? '',
                                                  fontSize: 11.5.sp),
                                            ],
                                          ),

                                        ],
                                      )
                                    ],
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h),
                                    child: Divider(
                                      color: AppTheme.borderColor,),
                                  ),
                                ],

                                Consumer<PaymentViewModel>(
                                    builder: (context, paymentViewModel,
                                        child) {
                                      return InkWell(
                                        onTap: () {
                                          push(context,
                                              const StripePaymentScreen(
                                                  checkout: true));
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 8.h, top: 4.h),
                                                child: AppText.appText(
                                                    'Pay With',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                    textColor: AppTheme
                                                        .textColor),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .only(top: 3.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        if(paymentViewModel
                                                            .selectedPaymentCard
                                                            .status ==
                                                            Status.completed &&
                                                            paymentViewModel
                                                                .selectedPaymentCard
                                                                .data != null)
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: 22.h,
                                                                width: 32.w,
                                                                decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                      color: AppTheme
                                                                          .blackColor
                                                                  ),
                                                                ),
                                                                child: Image
                                                                    .asset(
                                                                    getCardType(
                                                                        paymentViewModel
                                                                            .selectedPaymentCard
                                                                            .data
                                                                            ?.brand) ==
                                                                        'Master'
                                                                        ? 'assets/images/ic_master.png'
                                                                        :
                                                                    getCardType(
                                                                        paymentViewModel
                                                                            .selectedPaymentCard
                                                                            .data
                                                                            ?.brand) ==
                                                                        'Visa'
                                                                        ? 'assets/images/ic_visa.png'
                                                                        :
                                                                    getCardType(
                                                                        paymentViewModel
                                                                            .selectedPaymentCard
                                                                            .data
                                                                            ?.brand) ==
                                                                        'Google Pay'
                                                                        ? 'assets/images/ic_google_pay.png'
                                                                        :
                                                                    'assets/images/add_new_card.png'
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8.w,),
                                                              AppText.appText(
                                                                  capitalizeWords(
                                                                      paymentViewModel
                                                                          .selectedPaymentCard
                                                                          .data
                                                                          ?.brand ??
                                                                          ''),
                                                                  fontSize: 11.5
                                                                      .sp),
                                                            ],
                                                          )
                                                        else
                                                          AppText.appText(
                                                              'Select payment method',
                                                              fontSize: 11.5.sp,
                                                              textColor: Colors
                                                                  .red),
                                                      ],
                                                    ),
                                                    if(paymentViewModel
                                                        .selectedPaymentCard
                                                        .status ==
                                                        Status.completed &&
                                                        paymentViewModel
                                                            .selectedPaymentCard
                                                            .data != null)
                                                      Container(
                                                          width: 18.0,
                                                          // Adjust size as needed
                                                          height: 18.0,
                                                          margin: const EdgeInsets
                                                              .only(right: 3),
                                                          decoration: const BoxDecoration(
                                                            color: Colors.green,
                                                            shape: BoxShape
                                                                .circle,
                                                          ),
                                                          child: Image.asset(
                                                              'assets/images/ic_check.png')) // Adjust size as needed
                                                    else
                                                      const Icon(
                                                        Icons.chevron_right,
                                                        size: 28,)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Divider(color: AppTheme.borderColor,),
                                ),

                                Consumer<CouponViewModel>(
                                    builder: (context, couponViewModel, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          push(context,
                                              const GiftCardsCouponsScreen());
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                if(couponViewModel.coupon
                                                    .status ==
                                                    Status.completed &&
                                                    couponViewModel.coupon
                                                        .data != null)
                                                  AppText.appText(
                                                    '${capitalizeWords(
                                                        couponViewModel.coupon
                                                            .data?.type ??
                                                            '')} added',
                                                    fontSize: 11.5.sp,)
                                                else
                                                  AppText.appText(
                                                      'Gifts cards and coupons',
                                                      fontSize: 11.5.sp,
                                                      textColor: Colors.grey
                                                          .shade700),

                                                if(couponViewModel.coupon
                                                    .status ==
                                                    Status.completed &&
                                                    couponViewModel.coupon
                                                        .data != null)
                                                  Container(
                                                      width: 18.0,
                                                      // Adjust size as needed
                                                      height: 18.0,
                                                      margin: const EdgeInsets
                                                          .only(right: 3),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.green,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Image.asset(
                                                          'assets/images/ic_check.png')) // Adjust size as needed
                                                else
                                                  const Icon(
                                                    Icons.chevron_right,
                                                    size: 28,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Divider(color: AppTheme.borderColor,),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 6.h),
                                      child: AppText.appText('Review order',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                          textColor: AppTheme.textColor),
                                    ),
                                    ListView.builder(
                                      itemCount: items!.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final item = items![index];
                                        return ShoppingCartItem(
                                          seller: item.user?.name,
                                          productName: item.product?.title,
                                          quantity: item.product?.qty ?? item.qty,
                                          price: item.product?.fixPrice != null
                                              ? double.parse(
                                              item.product!.fixPrice!
                                                  .toString())
                                              : null,
                                          shippingCost: 0,
                                          productImage: item.product?.photo?[0]
                                              .url,
                                          deleteItem: () {
                                            items!.removeAt(index);
                                            setState(() {

                                            });
                                          },
                                          lastIndex: index == items!.length - 1,
                                        );
                                      },
                                    ),
                                  ],
                                ),


                              ],
                            ),
                          ),

                          Consumer<CouponViewModel>(
                              builder: (context, couponViewModel, child) {
                                getTotalAmount(widget.items ?? [],
                                    discount: couponViewModel.coupon.data
                                        ?.value);
                                return Container(
                                  color: const Color(0xfff7f7f7),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [

                                      AppText.appText("Order summary",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          textColor: AppTheme.textColor),

                                      SizedBox(height: 12.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          AppText.appText(
                                              "Items ($numberOfItems)",
                                              fontSize: 11.5.sp,
                                              textColor: AppTheme.blackColor),
                                          AppText.appText(
                                              "AED $total", fontSize: 11.5.sp,
                                              textColor: AppTheme.blackColor),

                                        ],
                                      ),
                                      SizedBox(height: 2.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          AppText.appText(
                                              "Shipping", fontSize: 11.5.sp,
                                              textColor: AppTheme.blackColor),
                                          AppText.appText(
                                              "AED 0", fontSize: 11.5.sp,
                                              textColor: AppTheme.blackColor),

                                        ],
                                      ),
                                      if(couponViewModel.coupon.status ==
                                          Status.completed &&
                                          couponViewModel.coupon.data !=
                                              null)...[
                                        SizedBox(height: 2.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            AppText.appText(
                                                "Discount", fontSize: 11.5.sp,
                                                textColor: AppTheme.blackColor),
                                            AppText.appText(
                                                "AED ${couponViewModel.coupon
                                                    .data?.value?.floor() ??
                                                    0}", fontSize: 11.5.sp,
                                                textColor: AppTheme.blackColor),

                                          ],
                                        ),
                                      ],

                                      SizedBox(height: 11.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          AppText.appText("Order Total",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                              textColor: AppTheme.textColor),
                                          AppText.appText('AED $subTotal',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                              textColor: AppTheme.textColor),
                                        ],
                                      ),

                                    ],
                                  ),
                                );
                              }
                          ),
                          SizedBox(height: 30.h,)

                        ],
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<PaymentViewModel>(
                            builder: (context, paymentViewModel, child) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: paymentViewModel.selectedPaymentCard.data?.brand == 'Google Pay' ?
                                      _googlePayButton(paymentViewModel)
                                    : AppButton.appButton('Confirm and Pay',
                                  onTap: enableConfirmButton(paymentViewModel)
                                      ? () async {
                                    try {
                                      paymentViewModel.setCheckOutLoading(true);
                                      dynamic paymentId = await paymentViewModel
                                          .stripeChargePayment(
                                        amount: subTotal.toDouble(),
                                        paymentMethodId: paymentViewModel
                                            .selectedPaymentCard.data
                                            ?.paymentMethodId,
                                        loading: true,
                                      );
                                      final orderId = await cartViewModel
                                          .addOrder(userId, cartViewModel.shippingDetails.data?.id, paymentId, googlePay: false);
                                      paymentViewModel.setCheckOutLoading(
                                          false);
                                      removePaymentAndCoupon(
                                          paymentViewModel, context);
                                      push(context, PaymentSuccessScreen(
                                          orderId: orderId));
                                    } catch (error) {
                                      paymentViewModel.setCheckOutLoading(
                                          false);
                                      showSnackBar(context, error.toString());
                                    }
                                  }
                                      : null,
                                  fontSize: 13.sp,
                                  loading: paymentViewModel.checkoutLoading,
                                  loadingColor: Colors.white,
                                  height: 45.h,
                                  fontWeight: FontWeight.w600,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 11.h,),
                                  textColor: AppTheme.whiteColor,
                                  backgroundColor: enableConfirmButton(
                                      paymentViewModel)
                                      ? AppTheme.appColor
                                      : Colors.grey.shade400,
                                  borderColor: enableConfirmButton(
                                      paymentViewModel)
                                      ? AppTheme.appColor
                                      : Colors.grey.shade400,
                                  radius: 26.sp,
                                  icon: Icons.lock,
                                  imageColor: AppTheme.white,

                                ),
                              );
                            }
                        ),

                      ],
                    ),
                  ),

                ],
              );
            }
        ),
      ),
    );
  }

  bool enableConfirmButton(PaymentViewModel paymentViewModel) {
    if ((items?.isNotEmpty ?? false) &&
        (paymentViewModel.selectedPaymentCard.status == Status.completed &&
            paymentViewModel.selectedPaymentCard.data != null)) {
      return true;
    }
    else {
      return false;
    }
  }

  void removePaymentAndCoupon(PaymentViewModel paymentViewModel, BuildContext context) {
    paymentViewModel.setSelectedPaymentCard(ApiResponse.notStarted());
    Provider.of<CouponViewModel>(context, listen: false).setCoupon(
        ApiResponse.notStarted());
  }

  Widget _googlePayButton(PaymentViewModel paymentViewModel) {
    return paymentViewModel.checkoutLoading == true ?
    const Center(child: CircularProgressIndicator()) :
    Row(
      children: [
        Expanded(
          child: GooglePayButton(
            paymentItems: [
              PaymentItem(
                label: 'Total',
                amount: subTotal.toString(),
                status: PaymentItemStatus.final_price,
              ),
            ],
            paymentConfigurationAsset: 'google_pay_configuration.json',
            height: 55.h,
            type: GooglePayButtonType.plain,
            onPaymentResult: onGooglePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onGooglePayResult(paymentResult) async {

    PaymentViewModel paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
    CartViewModel cartViewModel = Provider.of<CartViewModel>(context, listen: false);

    try {
      // Extract the payment token from the result
      String? paymentToken = paymentResult['paymentMethodData']['tokenizationData']['token'];

      String? last4Digits = paymentResult['paymentMethodData']['info']['cardDetails'];
      String? brand = paymentResult['paymentMethodData']['info']['cardNetwork'];



      if (paymentToken != null && paymentToken.isNotEmpty) {
        // Payment was successful
        paymentViewModel.setCheckOutLoading(true);
        await paymentViewModel
            .googlePayPayment(
          amount: subTotal.toDouble(),
          lastFour: last4Digits,
          brand: brand,
          token: paymentToken,
          userId: userId,
        );

        final orderId = await cartViewModel
            .addOrder(userId, cartViewModel.shippingDetails.data?.id, paymentToken, googlePay: true);

        paymentViewModel.setCheckOutLoading(
            false);

        removePaymentAndCoupon(
            paymentViewModel, context);

        push(context, PaymentSuccessScreen(
            orderId: orderId));

      } else {

        throw AppException('Payment failed: Invalid token');

    }} catch (e) {

      paymentViewModel.setCheckOutLoading(false);
      showSnackBar(context, e.toString());
    }
  }
}



class ShoppingCartItem extends StatelessWidget {
  final String? seller;
  final String? productName;
  final double? price;
  final int? quantity;
  final double? shippingCost;
  final String? productImage;
  final bool lastIndex;
  final Function() deleteItem;

  const ShoppingCartItem({super.key,
    required this.seller,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.shippingCost,
    required this.productImage,
    this.lastIndex= false,
    required this.deleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.h , bottom: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lastIndex ? Colors.transparent : AppTheme.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(productImage!=null)
              Container(
                width: 50.w,
                height: 60.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                        image: NetworkImage(
                            productImage!
                        )
                    )
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.appText(productName ?? '', fontWeight: FontWeight.w600, fontSize: 13.sp, textColor: AppTheme.textColor),

                        if(price!=null)
                          AppText.appText("AED ${price!.toStringAsFixed(0)}", fontWeight: FontWeight.bold, fontSize: 13.sp, textColor: AppTheme.textColor),

                      ],
                    ),
                    SizedBox(height: 9.h),
                    Row(
                      children: [
                        AppText.appText("Quantity $quantity", fontWeight: FontWeight.w400, fontSize: 11.5.sp, textColor: Colors.grey.shade600),
                        AppText.appText("    |  ", fontWeight: FontWeight.w400, fontSize: 11.5.sp, textColor: Colors.grey.shade300),
                        GestureDetector(
                            onTap: (){
                              deleteItem();
                            },
                            child: AppText.appText("Remove", fontWeight: FontWeight.bold, fontSize: 11.5.sp, textColor: Colors.blueAccent)),

                      ],
                    ),
                    SizedBox(height: 10.h),

                    if(shippingCost!=null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.appText('Delivery', fontWeight: FontWeight.w600, fontSize: 11.sp, textColor: AppTheme.textColor),
                          SizedBox(height: 4.h,),
                          AppText.appText('Est. delivery: Nov 11 - Nov 21\nTTOffer international Shipping ', fontWeight: FontWeight.w600, fontSize: 11.sp, textColor: AppTheme.textColor),
                          AppText.appText('+ US \$${shippingCost!.toStringAsFixed(0)}', fontWeight: FontWeight.w900, textColor: AppTheme.textColor),
                          SizedBox(height: 6.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.appText("Authorities may apply duties, fees and\ntaxes upon delivery", fontWeight: FontWeight.w400, fontSize: 10.sp, textColor: Colors.grey.shade600),

                            ],
                          ),
                        ],
                      ),





                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
