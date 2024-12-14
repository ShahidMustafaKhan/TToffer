import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/views/ShoppingFlow/cart/cart_screen.dart';

import '../../../Constants/app_logger.dart';
import '../../../view_model/banner/banner_view_model.dart' hide Data;
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../config/dio/app_dio.dart';


class CheckOutScreen extends StatefulWidget {
  List<Cart>? items;
  bool fromAccountInfo;
  CheckOutScreen({super.key, this.items, this.fromAccountInfo=false});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {


  late AppDio dio;
  AppLogger logger = AppLogger();

  late int total;
  late int subTotal;
  late int numberOfItems;

  List<Cart>? items;


  @override
  void initState() {
    dio = AppDio(context);
    logger.init();
    items = widget.items;

    getTotalAmount(items);
    super.initState();
  }

  void getTotalAmount(List<Cart>? item) {
    numberOfItems = 0;
    total = 0;
    subTotal = 0;

    if (item != null && item.isNotEmpty) {
      for (var element in item) {
        if (element.product != null && element.product!.fixPrice != null) {
          total += int.parse(element.product!.fixPrice!.toString());
          numberOfItems++;
        }
      }
      subTotal = total; // Assuming subTotal is meant to be the same as total
    } else {
      total = 0;
      numberOfItems = 0;
    }
    subTotal = total;

    // Update UI if any state variables have changed
  }


  @override
  Widget build(BuildContext context) {
    getTotalAmount(items);

    return PopScope(
      canPop: widget.fromAccountInfo == true ? false : true,
      onPopInvoked: (bool didPop){
        if (!didPop) {
          if (widget.fromAccountInfo == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }}

      },
      child: Scaffold(
        appBar: CustomAppBar1(
          title: "Checkout",
          backButtonTap: (){
            if (widget.fromAccountInfo == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            }
            else{
              Navigator.of(context).pop();
            }
          },
        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView (
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<BannerViewModel>(
                        builder: (context, bannerViewModel, child) {
                          return bannerViewModel.firstBanner.isNotEmpty ? CarouselSlider(
                            options: CarouselOptions(
                              aspectRatio: 16 / 4,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: bannerViewModel.firstBanner.map((String imagePath) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  double screenWidth = MediaQuery.of(context).size.width;
                                  double bannerHeight = screenWidth * (7 / 16);

                                  return Container(
                                    height: bannerHeight,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: imagePath,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Center(
                                        child: SizedBox(
                                          height: 30.h,
                                          child: CircularProgressIndicator(color: AppTheme.yellowColor),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => SizedBox(),
                                      cacheKey: imagePath,
                                      maxWidthDiskCache: 200,
                                      fadeInDuration: const Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ) : SizedBox();
                        }
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right : 16, top: 16.h , bottom: 6.h),
                      child: AppText.appText('Review order', fontWeight: FontWeight.bold, fontSize: 17.sp, textColor: AppTheme.textColor),
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
                          price: item.product?.fixPrice !=null ? double.parse(item.product!.fixPrice!.toString()) : null,
                          shippingCost: 0,
                          productImage: item.product?.photo?[0].url,
                          deleteItem: (){
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
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: AppTheme.borderColor,),
                  SizedBox(height: 3.h,),

                  AppText.appText("Order summary", fontWeight: FontWeight.bold, fontSize: 14.sp, textColor: AppTheme.textColor),

                  SizedBox(height: 12.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText("Items ($numberOfItems)",  fontSize: 11.5.sp, textColor: AppTheme.blackColor),
                      AppText.appText("AED $total", fontSize: 11.5.sp, textColor: AppTheme.blackColor),

                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText("Shipping",  fontSize: 11.5.sp, textColor: AppTheme.blackColor),
                      AppText.appText("AED 0", fontSize: 11.5.sp, textColor: AppTheme.blackColor),

                    ],
                  ),
                  SizedBox(height: 11.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.appText("Order Total", fontWeight: FontWeight.bold, fontSize: 13.sp, textColor: AppTheme.textColor),
                      AppText.appText('AED $subTotal', fontWeight: FontWeight.bold, fontSize: 13.sp, textColor: AppTheme.textColor),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: AppButton.appButton('Confirm and Pay',
                        fontSize: 13.sp,
                        height: 42.h,
                        fontWeight: FontWeight.w600,
                        padding: EdgeInsets.symmetric(vertical: 11.h,),
                        textColor: AppTheme.blackColor,
                        backgroundColor: Colors.grey.shade400,
                        borderColor: Colors.grey.shade400,
                        radius: 26.sp,
                        icon: Icons.lock

                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class ShoppingCartItem extends StatelessWidget {
  final String? seller;
  final String? productName;
  final double? price;
  final double? shippingCost;
  final String? productImage;
  final bool lastIndex;
  final Function() deleteItem;

  const ShoppingCartItem({super.key,
    required this.seller,
    required this.productName,
    required this.price,
    required this.shippingCost,
    required this.productImage,
    this.lastIndex= false,
    required this.deleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right : 16, top: 12.h , bottom: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lastIndex ? Colors.transparent : AppTheme.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText('Seller: ${capitalizeWords(seller ?? '')}', fontWeight: FontWeight.bold, textColor: AppTheme.textColor),
          SizedBox(height: 15.h),
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
                        AppText.appText("Quantity  1", fontWeight: FontWeight.w400, fontSize: 11.5.sp, textColor: Colors.grey.shade600),
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
