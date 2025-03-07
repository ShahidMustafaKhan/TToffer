import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/product/product/product_viewmodel.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Utils/resources/res/app_theme.dart';
import '../../../../Utils/utils.dart';
import '../../../../Utils/widgets/others/app_button.dart';
import '../../../../models/cart_model.dart';
import '../../../../models/product_model.dart';
import '../../../../providers/screen_state_notifier.dart';
import '../../../Authentication screens/login_screen.dart';
import '../../../ChatScreens/offer_chat_screen.dart';
import '../../../ShoppingFlow/cart/cart_screen.dart';
import 'make_offer_screen.dart';

class FeatureProductInteractiveButtons extends StatelessWidget {
  final String? authorizationToken;
  final Product? product;
  final String? categoryName;
  final bool isFav;
  final int? userId;
  
  const FeatureProductInteractiveButtons({super.key, this.authorizationToken, this.product , this.categoryName, this.isFav=false, this.userId});

  @override
  Widget build(BuildContext context) {

    bool purchasableCategories =
        categoryName != 'Property for Rent' &&
            categoryName != 'Property for Sale' &&
            categoryName != 'Vehicles' &&
            categoryName != 'Services' &&
            categoryName != 'Jobs' ;

    bool productStockAvailable = product?.inventory?.availableStock != null && product?.inventory?.availableStock!=0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(purchasableCategories)...[
            Consumer<ProductViewModel>(
                builder: (context, productViewModel, child) {
                 return Consumer<CartViewModel>(
                    builder: (context, cartViewModel, child) {
                      return AppButton.appButton(productStockAvailable == false  ? 'Out of Stock' : "Buy it Now",
                          onTap: productStockAvailable == true ? () async {
                            if(authorizationToken != null){
                              showCartBottomSheet(context, product, buyItNow: true);
                            }
                            else{
                              push(context, const SigInScreen());
                            }

                          } : null,
                          height: 45.h,
                          radius: 32.r,
                          loading: cartViewModel.loading,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          backgroundColor: productStockAvailable == false && productViewModel.productDetailLoading == false ? Colors.grey.shade400 : AppTheme.appColor,
                          borderColor: productStockAvailable == false  && productViewModel.productDetailLoading == false ? Colors.grey.shade400 : AppTheme.appColor,
                          borderWidth: 1,
                          textColor: AppTheme.white);
                    }
                );
              }
            ),
            SizedBox(height: 7.w,),
          ],

          if(productStockAvailable == true && enableCartButton(product) == true)...[
            Consumer<CartViewModel>(
                builder: (context, cartViewModel, child) {
                  return AppButton.appButton("Add to cart",
                    onTap: () async {
                      if(authorizationToken != null){
                        showCartBottomSheet(context, product);
                      }
                      else{
                        push(context, SigInScreen());
                      }},
                    height: 45.h,
                    radius: 32.r,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    borderWidth: 1,
                    textColor: AppTheme.appColor);
              }
            ),
            SizedBox(height: 7.w,),],
          if(makeOfferButton(product))...[
            AppButton.appButton("Make Offer",
                onTap: () async {
                  if(authorizationToken!=null){
                    push(context, MakeOfferScreen(product: product));
                  }
                  else{
                    push(context, const SigInScreen());
                  }
                },
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                backgroundColor: !purchasableCategories ? AppTheme.appColor : null,
                textColor: !purchasableCategories ? AppTheme.white : AppTheme.appColor),
            SizedBox(height: 7.w,),
          ],

          AppButton.appButton(featureChatButtonTitle(product),
              onTap: () async {
                if(authorizationToken!=null){
                  Provider.of<ScreenStateNotifier>(context, listen: false)
                      .setChatScreenActive(true);
                  push(
                      context,
                      OfferChatScreen(
                        participantModel: product?.user,
                        product: product,
                        receiverId: product?.userId,
                        sellerId: product?.userId,
                        productId: product?.id,
                        buyerId: userId,
                        isFromFeatureProduct: true,
                      ), then: (){Provider.of<ScreenStateNotifier>(context, listen: false)
                      .setChatScreenActive(false);});
                }
                else{
                  push(context, const SigInScreen());

                }
              },
              height: 45.h,
              radius: 32.r,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              borderWidth: 1,
              textColor: AppTheme.appColor),
          SizedBox(height: 7.w,),
          if(product?.user?.phone!=null && product?.user?.showContact==1)...[
            AppButton.appButton("Call Seller",
                onTap: () async {
                  if(authorizationToken != null){
                    var url = Uri.parse("tel:${product?.user?.phone}");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  }
                  else{
                    push(context, const SigInScreen());
                  }
                },
                height: 45.h,
                radius: 32.r,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                borderWidth: 1,
                textColor: AppTheme.appColor),
            // SizedBox(height: 7.w,)
          ],
          // Consumer<UserViewModel>(
          //     builder: (context, userViewModel, child) {
          //       return AppButton.appButton(authorizationToken==null ? "Add to wishlist" : userViewModel.isProductInWishList(product?.id) ? "Remove from wishlist" : "Add to wishlist",
          //         onTap: () async {
          //           if(authorizationToken!=null ){
          //             userViewModel.toggleWishList(userId, product?.id, context);
          //           }
          //           else{
          //             push(context, const SigInScreen());
          //           }
          //         },
          //         height: 45.h,
          //         radius: 32.r,
          //         fontWeight: FontWeight.w500,
          //         fontSize: 15,
          //         borderWidth: 1,
          //         imagePath: userViewModel.isProductInWishList(product?.id) && authorizationToken!=null ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
          //         imageColor: userViewModel.isProductInWishList(product?.id) && authorizationToken!=null  ? null : AppTheme.appColor,
          //         textColor: AppTheme.appColor);
          //   }
          // ),

        ],
      ),
    );
  }
  void showCartBottomSheet(BuildContext contextA, Product? product, {bool buyItNow = false}) {
    showModalBottomSheet(
      context: contextA,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        int quantity = 1;
        int availableStock = product?.inventory?.availableStock ?? 0; // Local state variable

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (availableStock == 0)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Item is out of stock",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: product != null && (product.photo?.isNotEmpty ?? false)
                              ? Image.network(
                            product.photo![0].url!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          )
                              : Container(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product?.title ?? '',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'AED ${product?.fixPrice ?? ''}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            Text(
                              '+ AED 0 shipping',
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      color: Color(0xfff0f0f0),
                      thickness: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quantity",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.remove,
                                color: quantity > 1 ? const Color(0xff9ea1a8) : Color(0xff9ea1a8).withOpacity(0.5),
                                size: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "$quantity",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (quantity < availableStock) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              color: const Color(0xfff9f8fd),
                              child: Icon(
                                Icons.add,
                                color: quantity < availableStock ? const Color(0xff9ea1a8) : Color(0xff9ea1a8).withOpacity(0.5),
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 65),
                  Consumer<CartViewModel>(
                      builder: (context, cartViewModel, child) {
                        return AppButton.appButton(
                          buyItNow ? 'Buy it now' : "Add to cart",
                        onTap: availableStock > 0
                            ? () async {
                          Navigator.of(context).pop();

                          if(buyItNow == true){
                            buyItNowFunction(cartViewModel, contextA, quantity);
                          }
                          else{
                            cartViewModel.addCartItem(
                              productId : product?.id,
                              price : product?.fixPrice,
                              quantity: quantity,
                              userId: userId,)
                                .then((value){
                              addToCartBottomSheet(contextA);
                            }).onError((error, stackTrace){
                              showSnackBar(contextA, error.toString());
                            });
                          }


                        }
                            : null,
                        height: 45,
                        radius: 32.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        backgroundColor: availableStock > 0
                            ? AppTheme.appColor
                            : Colors.grey,
                        borderWidth: 1,
                        textColor: AppTheme.white,
                      );
                    }
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void addToCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Added to cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for the product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: product != null && (product?.photo?.isNotEmpty ?? false)
                            ? Image.network(
                          product!.photo![0].url!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        )
                            : Container(color: Colors.grey)
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.title ?? '',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'AED ${product?.fixPrice ?? ''}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          '+ AED 0 shipping',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21),
              AppButton.appButton("Go to cart", onTap: () async {
                Navigator.of(context).pop();
                push(context, CartScreen());
              },
                  height: 45.h,
                  radius: 32.r,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                  backgroundColor: AppTheme.appColor,
                  borderWidth: 1,
                  textColor: AppTheme.white),
            ],
          ),
        );
      },
    );
  }

  void buyItNowFunction(CartViewModel cartViewModel, BuildContext context, int? quantity){
    if(authorizationToken!=null){
      List<Cart> cartDataList = [];

      Cart cart = Cart(
          productId: product?.id,
          product: product,
          qty: quantity,
          userId: product?.userId,
          user: product?.user
      );

      cartDataList.add(cart);

      cartViewModel.getLastAddress()
          .then((value){
        cartViewModel.addCartItem(
            productId : product?.id,
            price : product?.fixPrice,
            quantity: quantity, userId: userId, loading : false);
        cartViewModel.determineNextScreen(true , cartDataList, context);

      })
          .onError((error, stackTrace){
        if(error.toString() == 'No address Found' ){
          cartViewModel.addCartItem(
              productId : product?.id,
              price : product?.fixPrice,
              quantity: quantity,
              userId: userId, loading : false);
          cartViewModel.determineNextScreen(false , cartDataList, context);
        }
        else{
          showSnackBar(context, error.toString());
        }
      });
    }
    else{
      push(context, const SigInScreen());

    }
  }

}
