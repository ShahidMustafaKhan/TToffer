import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/models/cart_model.dart';

import '../../../Constants/app_logger.dart';
import '../../../Controller/APIs Manager/banner_api.dart' hide Data;
import '../../../Controller/APIs Manager/cart_api.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../config/app_urls.dart';
import '../../../config/dio/app_dio.dart';
import '../account_info_form/AccountInfoForm.dart';
import '../account_info_form/AlmostThere.dart';
import '../checkout/checkout_screen.dart';


class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {


  late CartApiProvider cartProvider;
  late AppDio dio;
  AppLogger logger = AppLogger();

  late int total;
  late int subTotal;
  late int numberOfItems;

  bool isLoading = false;

  @override
  void initState() {
    dio = AppDio(context);
    logger.init();

    cartProvider = Provider.of<CartApiProvider>(context, listen: false);
    cartProvider.getCartItems(dio: dio, context: context);
    getTotalAmount(cartProvider.cartModel);
    super.initState();
  }

  void getTotalAmount(CartModel? cartModel) {
    numberOfItems = 0;
    total = 0;
    subTotal = 0;

    if (cartModel != null && cartModel.data != null && cartModel.data!.isNotEmpty) {
      for (var element in cartModel.data!) {
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

    return Scaffold(
      appBar: CustomAppBar1(
        title: "TTOffer Shopping Cart",
        preferredHeight: 55.0,
        actionOntap: () {
        },
      ),
      body:Consumer<CartApiProvider>(
          builder: (context, cartApiProvider, child) {
            getTotalAmount(cartProvider.cartModel);
            return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<BannerController>(
                          builder: (context, bannerController, child) {
                            return bannerController.firstBanner.isNotEmpty ? CarouselSlider(
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
                              items: bannerController.firstBanner.map((String imagePath) {
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

                      // if(cartApiProvider.cartModel!.data!.isEmpty)
                      //   Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       SizedBox(height: 150.h,),
                      //
                      //       Center(child: Image.asset("assets/images/no_data_folder.png", height: 143.h,)),
                      //         SizedBox(height: 15.h,),
                      //
                      //         AppText.appText('Cart is empty',
                      //             fontSize: 14,
                      //             letterSpacing: 2,
                      //             fontWeight: FontWeight.w500,
                      //             textColor: Colors.black),
                      //         SizedBox(height: 12.h,)
                      //     ],
                      //   ),

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartApiProvider.cartModel!.data!.length,
                        itemBuilder: (context, index) {
                          final item = cartApiProvider.cartModel!.data![index];
                          return ShoppingCartItem(
                            seller: item.user?.name,
                            productName: item.product?.title,
                            price: item.product?.fixPrice !=null ? double.parse(item.product!.fixPrice!.toString()) : null,
                            shippingCost: 0,
                            productImage: item.product?.imagePath?.url,
                            lastItem: cartApiProvider.cartModel!.data!.length - 1 == index,
                            deleteItem: (){
                              cartApiProvider.deleteCartItems(dio: dio, context: context, productId: item.product!.id!);
                            },
                            buyItNow: (){
                              List<Data>? temp = List.from(cartApiProvider.cartModel!.data!);
                              List<Data>? data = [temp[index]];
                              push(context, CheckOutScreen(items: data,));
                            },
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ),

              Column(
                children: [
                  Divider(color: AppTheme.borderColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 5.h,),
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
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText("Subtotal", fontWeight: FontWeight.bold, fontSize: 12.5.sp, textColor: AppTheme.textColor),
                            AppText.appText('AED $subTotal', fontWeight: FontWeight.bold, fontSize: 12.5.sp, textColor: AppTheme.textColor),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        InkWell(
                          onTap: (){

                            if(cartApiProvider.cartModel!.data!.isNotEmpty){
                              getLastAddress(dio: dio, context: context, cartDataList: cartApiProvider.cartModel?.data!);
                            }

                          },
                          child: isLoading ? CircularProgressIndicator() : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: AppButton.appButton('Go to checkout',
                            fontSize: 13.sp,
                            padding: EdgeInsets.symmetric(vertical: 11.h,),
                            textColor: AppTheme.whiteColor,
                             backgroundColor: AppTheme.appColor,
                              borderColor: AppTheme.appColor,
                              radius: 26.sp

                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );
  }

  Future getLastAddress({required dio, required context, required List<Data>? cartDataList}) async {
    isLoading = true;
    setState(() {

    });
    var response;
    int responseCode200 = 200; // For successful request.
    int responseCode400 = 400; // For Bad Request.
    int responseCode401 = 401; // For Unauthorized access.
    int responseCode404 = 404; // For For data not found
    int responseCode422 = 422; // For For data not found
    int responseCode500 = 500; // Internal server error.

    try {
      response = await dio.get(path: AppUrls.getLastAddress);
      var responseData = response.data;
      if (response.statusCode == responseCode400) {
        showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        setState((){});
      } else if (response.statusCode == responseCode401) {
        // showSnackBar(context, "${responseData["message"]}");
        isLoading = false;
        setState((){});
      } else if (response.statusCode == responseCode404) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        setState((){});
      } else if (response.statusCode == responseCode500) {
        showSnackBar(context, "${responseData["message"]}");

        isLoading = false;
        setState((){});
      } else if (response.statusCode == responseCode422) {
        isLoading = false;
        setState((){});
      } else if (response.statusCode == responseCode200) {
        isLoading = false;
        bool addressSaved;
        if(responseData["message"] == 'No address Found'){
          addressSaved = false;
        }
        else{
          addressSaved = true;
        }

        determineNextScreen(addressSaved , cartDataList);
        setState((){});
      }
    } catch (e) {
      print("Something went Wrong ${e}");
      showSnackBar(context, "Something went Wrong.");
      isLoading = false;
      setState((){});
    }
  }

  determineNextScreen(bool addressSaved, List<Data>? cartDataList){
    List<Data>? data = List.from(cartDataList!);

    if(addressSaved==false){
      push(context, AlmostThereScreen(data: data));
    }
    else{
      push(context, CheckOutScreen(items: data,));
    }
  }




}

class ShoppingCartItem extends StatelessWidget {
  final String? seller;
  final String? productName;
  final double? price;
  final double? shippingCost;
  final String? productImage;
  final bool lastItem;
  final Function() deleteItem;
  final Function() buyItNow;

  const ShoppingCartItem({super.key,
    required this.seller,
    required this.productName,
    required this.price,
    required this.shippingCost,
    required this.productImage,
    required this.deleteItem,
    this.lastItem = false,
    required this.buyItNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right : 0, top: 16.h , bottom: 6.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: lastItem ? Colors.transparent : AppTheme.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText('Seller: ${capitalizeWords(seller ?? '')}', fontWeight: FontWeight.bold, textColor: AppTheme.textColor),
          SizedBox(height: 25.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(productImage!=null)
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
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
                    AppText.appText(productName ?? '', fontWeight: FontWeight.w600, fontSize: 13.sp, textColor: AppTheme.textColor),
                    SizedBox(height: 4.h),
                    AppText.appText("Qty 1", fontWeight: FontWeight.w400, fontSize: 11.5.sp, textColor: Colors.grey.shade600),
                    const SizedBox(height: 8),
                    if(price!=null)
                      AppText.appText("AED ${price!.toStringAsFixed(0)}", fontWeight: FontWeight.bold, fontSize: 14.sp, textColor: AppTheme.textColor),

                    if(shippingCost!=null)
                      AppText.appText('+ US \$${shippingCost!.toStringAsFixed(0)}', fontSize: 12.sp, textColor: Colors.grey.shade600),


                    Padding(
                      padding: EdgeInsets.only(top: 15.h, bottom: 6.h, left: 6.w, right: 18.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: (){buyItNow();},
                              child: AppText.appText('Buy it now', fontSize: 11.5.sp, textColor: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                          AppText.appText('Save for later', fontSize: 11.5.sp,textColor: Colors.blue.shade700, fontWeight: FontWeight.w600),
                          GestureDetector(
                              onTap: (){deleteItem();},
                              child: AppText.appText('Remove', fontSize: 11.5.sp, textColor: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                        ],
                      ),
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
