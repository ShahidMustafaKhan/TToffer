import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../Utils/widgets/video_player.dart';
import '../../../custom_requests/dynmaic_link_service.dart';
import '../../../models/product_model.dart';
import '../../BottomNavigation/navigation_bar.dart';
import '../../ShoppingFlow/cart/cart_screen.dart';

import 'full_image_page.dart';

class ProductImage extends StatefulWidget {
  final String? categoryName;
  final String? subCategoryName;
  final String? authorizationToken;
  final bool popToBottomNav;
  final Product? product;
  final int? userId;


  const ProductImage({super.key, this.product, this.userId, this.categoryName, this.subCategoryName, this.authorizationToken, this.popToBottomNav=false,});

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  int _currentPage = 0;
  Product? product;


  @override
  void initState() {
    if(widget.product != null ){
    product = Product.copy(widget.product!);
    if(product?.video?.isNotEmpty ?? false){
      product?.photo?.insert(0, product!.video![0]);
    }}

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 450.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: (product?.photo?.length ?? 0),
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 300,
                child: InkWell(
                  onTap: () {
                    push(
                        context,
                        FullImagePage(
                            product:
                            product));
                  },
                  child: Stack(
                      children: [
                        if(product?.photo?.isNotEmpty ?? false)...[
                          Positioned.fill(
                            child: product!.photo![index].url!.endsWith('.mp4') ?
                            VideoPlayerWidget(videoPath: product!.photo![index].url!, networkVideo: true, playBtnSize: 45,):
                            Image.network(
                              product?.photo?[index].url ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        if((product?.photo?.length ?? 0) > 1)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: (product?.photo?.length ?? 0),
                                effect: const ScrollingDotsEffect(
                                  activeDotColor: Colors.blue,
                                  dotColor: Colors.grey,
                                  maxVisibleDots: 5,
                                  dotHeight: 7.0,
                                  dotWidth: 7.0,
                                ),
                              ),
                            ),
                          ),
                        if((product?.photo?.length ?? 0)>1 && index!=0 )
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                              onPressed: _goToPreviousPage,
                              padding: const EdgeInsets.only(left: 15),
                            ),
                          ),
                        if((product?.photo?.length ?? 0)>1 && (index==0 || index!=((product?.photo?.length ?? 0)-1)) )
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                              onPressed: _goToNextPage,
                              padding: const EdgeInsets.only(right: 10),
                            ),
                          ),
                      ]
                  ),
                ),
              );
            },
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          GestureDetector(
            onTap: () {
              if(widget.popToBottomNav == true) {
                pushUntil(context, const BottomNavView());
              }
              else{
                Navigator.of(context).pop();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.whiteColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/arrow-left.png",),
                  ),
                ),
              ),
            ),
          ),

          Align(
              alignment: Alignment.topRight,
              child: iconSvg()),

          priceTagDetail(),

          if(widget.authorizationToken != null && widget.userId.toString() != product?.userId.toString())
            Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
                  return iconContainer(
                  ontap: () {
                    userViewModel.toggleWishList(widget.userId, product?.id, context);
                  },
                  isFavourite:
                  userViewModel.isProductInWishList(product?.id),
                  alignment: Alignment.bottomRight,
                  img: "assets/images/heart.png");
              }
            )
        ],
      ),
    );
  }

  Widget iconContainer({Function()? ontap, img, alignment, isFavourite}) {
    return GestureDetector(
        onTap: ontap,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Align(
              alignment: alignment,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppTheme.whiteColor),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      isFavourite ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
                      color: isFavourite? Colors.red : AppTheme.textColor,

                    )

                ),
              ),
            )));
  }


  Widget iconSvg({Function()? ontap, img,}) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.0, vertical: 35.h),
          child: SizedBox(
            width: 100.w,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){shareProductLink();},
                    child: SvgPicture.asset(
                        "assets/svg/ic_share.svg",
                        height: 30.h
                    ),
                  ),
                  if(product?.productType == 'featured' && widget.userId.toString() != product?.userId.toString() && enableCartButton(product) == true)...[
                    SizedBox(width: 18.w),
                    Consumer<CartViewModel>(
                        builder: (context, cartViewModel, child) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap:(){
                                  cartViewModel.addCartItem(
                                      productId: product?.id,
                                      quantity: 1,
                                      price: product?.fixPrice,
                                      userId: widget.userId);
                                  push(context, const CartScreen());
                                },
                                child: SvgPicture.asset(
                                    "assets/svg/ic_cart.svg",
                                    height: 30.h

                                ),
                              ),
                              if(cartViewModel.cartItemsCount!=0)
                                Positioned(
                                  top: -3,
                                  right: -3,
                                  child: Container(
                                    height: 15.w, // Adjust the size as needed
                                    width: 15.w,  // Adjust the size as needed
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(child: AppText.appText('${cartViewModel.cartItemsCount}', textColor: Colors.white, fontSize: 7.sp, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          );
                        }
                    ),]
                ]
            ),
          )
      ),
    );
  }

  Widget priceTagDetail() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 14, bottom: 27),
        child: fullPriceTag(product, )));
  }

  Future<void> shareProductLink() async {
    String shareLink = await DynamicLinkService().createDynamicLink(product?.id?.toString() ?? '', product?.productType == 'auction' ? 'auction' : "featured");
    Share.share('Check out this ad: $shareLink');
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < (product?.photo?.length ?? 0) - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
