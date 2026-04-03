import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../config/keys/pref_keys.dart';
import '../../../data/response/status.dart';
import '../../../main.dart';
import '../../../view_model/banner/banner_view_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartViewModel cartViewModel;

  late int total;
  late int subTotal;
  late int numberOfItems;

  bool isLoading = false;
  int? userId;

  @override
  void initState() {
    userId = int.tryParse(pref.getString(PrefKey.userId) ?? '');
    cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    cartViewModel.getCartList(userId);
    getTotalAmount(cartViewModel.cartItemList.data);
    super.initState();
  }

  void getTotalAmount(CartModel? cartModel) {
    numberOfItems = 0;
    total = 0;
    subTotal = 0;

    if (cartModel != null &&
        cartModel.data != null &&
        cartModel.data!.isNotEmpty) {
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar1(
        title: "TTOffer Shopping Cart",
        preferredHeight: 55.0,
        actionOntap: () {},
      ),
      body: Consumer<UserViewModel>(builder: (context, userViewModel, child) {
        CartModel? cartModel = cartViewModel.cartItemList.data;
        getTotalAmount(cartModel);
        return Consumer<CartViewModel>(
            builder: (context, cartViewModel, child) {
          CartModel? cartModel = cartViewModel.cartItemList.data;
          getTotalAmount(cartModel);
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                                  autoPlay: false,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: false,
                                  scrollDirection: Axis.horizontal,
                                ),
                                items: bannerViewModel.firstBanner
                                    .map((String banner) {
                                  return InkWell(
                                    onTap: () async {},
                                    child: Container(
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: banner,
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) => Center(
                                          child: SizedBox(
                                            height: 30.h,
                                            child: CircularProgressIndicator(
                                              color: AppTheme.yellowColor,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const SizedBox(),
                                        cacheKey:
                                            banner, // Cache key to identify this image
                                        fadeInDuration: const Duration(
                                            milliseconds:
                                                500), // Smooth fade-in effect
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const SizedBox();
                      }),
                      cartViewModel.cartItemList.status == Status.loading ||
                              cartViewModel.cartItemList.status == Status.error
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.35),
                                cartViewModel.cartItemList.status ==
                                        Status.loading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : cartViewModel.cartItemList.status ==
                                            Status.error
                                        ? Center(
                                            child: AppText.appText(
                                                cartViewModel
                                                        .cartItemList.message ??
                                                    '',
                                                fontSize: 16,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.w500,
                                                textColor: Colors.black),
                                          )
                                        : const SizedBox(),
                              ],
                            )
                          : cartModel?.data?.isEmpty ?? false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 150.h,
                                    ),
                                    Center(
                                        child: Image.asset(
                                      "assets/images/no_data_folder.png",
                                      height: 143.h,
                                    )),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    AppText.appText('Cart is empty',
                                        fontSize: 14,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w500,
                                        textColor: Colors.black),
                                    SizedBox(
                                      height: 12.h,
                                    )
                                  ],
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cartModel?.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    Cart? item = cartModel?.data?[index];
                                    return ShoppingCartItem(
                                      index: index,
                                      seller: item?.user?.name,
                                      productName: item?.product?.title,
                                      quantity: item?.product?.qty,
                                      savedForLater:
                                          userViewModel.isProductInSavedList(
                                              item?.product?.id),
                                      price: item?.product?.fixPrice != null
                                          ? double.parse(item!
                                              .product!.fixPrice!
                                              .toString())
                                          : null,
                                      shippingCost: 0,
                                      productImage:
                                          item?.product?.photo?.isNotEmpty ??
                                                  false
                                              ? item?.product!.photo![0].url
                                              : null,
                                      lastItem:
                                          (cartModel?.data?.length ?? 0) - 1 ==
                                              index,
                                      deleteItem: () {
                                        cartViewModel
                                            .removeCartItem(
                                                item?.product?.id, userId,
                                                index: index)
                                            .then((value) {
                                          cartModel?.data?.removeAt(index);
                                          showSnackBar(context,
                                              'Product removed from cart',
                                              title: 'Congratulations!');
                                        }).onError((error, stackTrace) {
                                          showSnackBar(
                                              context, error.toString());
                                        });
                                      },
                                      buyItNow: () {
                                        List<Cart>? temp =
                                            List.from(cartModel?.data ?? []);
                                        List<Cart>? data = [temp[index]];
                                        getLastAddress(
                                            cartDataList: data, index: index);
                                      },
                                      toggleSaveItem: () {
                                        userViewModel
                                            .addSavedItem(userId,
                                                item?.product?.id, context,
                                                index: index)
                                            .then((value) {
                                          showSnackBar(context,
                                              'Product has been saved for later',
                                              title: 'Congratulations!');
                                          cartModel?.data?.removeAt(index);
                                        }).onError((error, stackTrace) {
                                          showSnackBar(
                                              context, error.toString());
                                        });
                                      },
                                      saveLaterLoading:
                                          cartViewModel.toggleSaveLoadingList,
                                      removeCartItemLoading:
                                          cartViewModel.removeCartLoadingList,
                                      buyItNowLoading:
                                          cartViewModel.buyNowLoadingList,
                                    );
                                  },
                                )
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
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText("Items ($numberOfItems)",
                                fontSize: 11.5.sp,
                                textColor: AppTheme.blackColor),
                            AppText.appText("AED $total",
                                fontSize: 11.5.sp,
                                textColor: AppTheme.blackColor),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText("Shipping",
                                fontSize: 11.5.sp,
                                textColor: AppTheme.blackColor),
                            AppText.appText("AED 0",
                                fontSize: 11.5.sp,
                                textColor: AppTheme.blackColor),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.appText("Subtotal",
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5.sp,
                                textColor: AppTheme.textColor),
                            AppText.appText('AED $subTotal',
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5.sp,
                                textColor: AppTheme.textColor),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        InkWell(
                          onTap: cartModel?.data?.isNotEmpty ?? false
                              ? () =>
                                  getLastAddress(cartDataList: cartModel?.data)
                              : null,
                          child: cartViewModel.loading
                              ? const CircularProgressIndicator()
                              : Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  child: AppButton.appButton('Go to checkout',
                                      height: 45.h,
                                      fontSize: 13.sp,
                                      fontWeight:
                                          cartModel?.data?.isNotEmpty ?? false
                                              ? null
                                              : FontWeight.w600,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 11.h,
                                      ),
                                      textColor:
                                          cartModel?.data?.isNotEmpty ?? false
                                              ? AppTheme.whiteColor
                                              : AppTheme.blackColor,
                                      backgroundColor:
                                          cartModel?.data?.isNotEmpty ?? false
                                              ? AppTheme.appColor
                                              : Colors.grey.shade400,
                                      borderColor:
                                          cartModel?.data?.isNotEmpty ?? false
                                              ? AppTheme.appColor
                                              : Colors.grey.shade400,
                                      radius: 26.sp),
                                ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      }),
    );
  }

  Future getLastAddress({required List<Cart>? cartDataList, int? index}) async {
    List<Cart> inStockItems = cartDataList?.where((cart) {
          return cart.product?.inventory != null &&
              cart.product?.inventory?.availableStock != null &&
              cart.product!.inventory!.availableStock! > 0;
        }).toList() ??
        [];

    if (inStockItems.isNotEmpty) {
      cartViewModel.getLastAddress(index: index).then((value) {
        cartViewModel.determineNextScreen(true, inStockItems, context);
      }).onError((error, stackTrace) {
        if (error.toString() == 'No address Found') {
          cartViewModel.determineNextScreen(false, inStockItems, context);
        } else {
          showSnackBar(context, error.toString());
        }
      });
    } else {
      showSnackBar(
          context, "All the items in your cart are currently out of stock.");
    }
  }
}

class ShoppingCartItem extends StatelessWidget {
  final int? index;
  final String? seller;
  final String? productName;
  final double? price;
  final int? quantity;
  final double? shippingCost;
  final String? productImage;
  final bool lastItem;
  final bool savedForLater;
  final Function() deleteItem;
  final Function() buyItNow;
  final Function() toggleSaveItem;
  final List<bool> saveLaterLoading;
  final List<bool> removeCartItemLoading;
  final List<bool> buyItNowLoading;

  const ShoppingCartItem({
    super.key,
    required this.index,
    required this.seller,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.shippingCost,
    required this.productImage,
    required this.deleteItem,
    this.savedForLater = false,
    this.lastItem = false,
    required this.buyItNow,
    required this.toggleSaveItem,
    required this.saveLaterLoading,
    required this.removeCartItemLoading,
    required this.buyItNowLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 0, top: 16.h, bottom: 6.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: lastItem ? Colors.transparent : AppTheme.borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppText.appText('Seller: ${capitalizeWords(seller ?? '')}', fontWeight: FontWeight.bold, textColor: AppTheme.textColor),
          // SizedBox(height: 25.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (productImage != null)
                Container(
                  width: 100.w,
                  height: 115.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(productImage!))),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h),
                    AppText.appText(capitalizeWords(productName ?? ''),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        textColor: AppTheme.textColor),
                    SizedBox(height: 4.h),
                    if (quantity != null && quantity != 0)
                      AppText.appText("Qty $quantity",
                          fontWeight: FontWeight.w400,
                          fontSize: 11.5.sp,
                          textColor: Colors.grey.shade600)
                    else
                      AppText.appText("Out of stock",
                          fontWeight: FontWeight.w400,
                          fontSize: 11.5.sp,
                          textColor: Colors.red),
                    const SizedBox(height: 8),
                    if (price != null)
                      AppText.appText("AED ${price!.toStringAsFixed(0)}",
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          textColor: AppTheme.textColor),
                    if (shippingCost != null)
                      AppText.appText(
                          '+ AED \$${shippingCost!.toStringAsFixed(0)}',
                          fontSize: 12.sp,
                          textColor: Colors.grey.shade600),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 7.h, bottom: 6.h, left: 3.w, right: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buyItNowLoading.isNotEmpty &&
                                  buyItNowLoading[index!] == true
                              ? Center(
                                  child: appLoading(),
                                )
                              : GestureDetector(
                                  onTap: quantity != null && quantity != 0
                                      ? () {
                                          buyItNow();
                                        }
                                      : null,
                                  child: AppText.appText('Buy it now',
                                      fontSize: 11.5.sp,
                                      textColor:
                                          quantity != null && quantity != 0
                                              ? Colors.blue.shade700
                                              : AppTheme.hintTextColor,
                                      fontWeight: FontWeight.w600)),
                          saveLaterLoading.isNotEmpty &&
                                  saveLaterLoading[index!] == true
                              ? appLoading()
                              : GestureDetector(
                                  onTap: () {
                                    toggleSaveItem();
                                  },
                                  child: AppText.appText('Save for later',
                                      fontSize: 11.5.sp,
                                      textColor: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600)),
                          removeCartItemLoading.isNotEmpty &&
                                  removeCartItemLoading[index!] == true
                              ? appLoading()
                              : GestureDetector(
                                  onTap: () {
                                    deleteItem();
                                  },
                                  child: AppText.appText('Remove',
                                      fontSize: 11.5.sp,
                                      textColor: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600)),
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
