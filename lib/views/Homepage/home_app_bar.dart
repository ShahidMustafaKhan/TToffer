import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/cart_api.dart';
import 'package:tt_offer/Controller/APIs%20Manager/product_api.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/views/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/views/Notification/notification_screen.dart';
import 'package:tt_offer/views/ShoppingFlow/cart/cart_screen.dart';

import '../../Constants/app_logger.dart';
import '../../Controller/APIs Manager/profile_apis.dart';
import '../../Utils/widgets/others/app_field.dart';
import '../../config/dio/app_dio.dart';
import '../../providers/notification_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final context;
  final TextEditingController searchController;
  final Function() searchHandler;
  final StateSetter setState;
  final String? authenticationCode;

  // Callback function

  const CustomAppBar({super.key, this.context, required this.searchController, this.authenticationCode, required this.searchHandler, required this.setState});




  @override
  Widget build(BuildContext context) {
    final productApi = Provider.of<ProductsApiProvider>(context);
    final cartApi = Provider.of<CartApiProvider>(context);
    late AppDio dio;
    AppLogger logger = AppLogger();
    dio = AppDio(context);
    logger.init();

    return Padding(
      padding: EdgeInsets.only(left: 25.0, top: 40.h, right: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.appText('TTOffer',
                fontWeight: FontWeight.bold,
                fontSize: 24.sp

              ),
              Consumer<CartApiProvider>(
                  builder: (context, cartProvider, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(authenticationCode != null)
                            push(context, CartScreen());
                            else
                              push(context, SigInScreen());
                          },
                          child: const Icon(Icons.shopping_cart_outlined)),
                        if(cartProvider.numberOfItems!= null && cartProvider.numberOfItems!=0)
                          Positioned(
                            top: -4.5,
                            right: -3.5,
                            child: Container(
                              height: 14, // Adjust the size as needed
                              width: 14,  // Adjust the size as needed
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: AppText.appText('${cartProvider.numberOfItems}', textColor: Colors.white, fontSize: 7.sp, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    );
                }
              )

            ],
          ),

          SizedBox(height: 7.h,),


          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomAppFormField(
                  onFieldSubmitted: (val) {
                    // setState(() {
                    //   searchController.text = val;
                    //   searchHandler;
                    // });
                  },
                  onChanged: (value){
                    setState(() {
                      productApi.getAllProducts(search: value, context: context , dio: dio);
                      searchController.text = value;


                    });
                  },
                  radius: 15.0,
                  hintStyle: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400),
                  prefixIcon: Image.asset(
                    "assets/images/search.png",
                    height: 22.h,
                    color: AppTheme.textColor,
                  ),
                  texthint: "What are you looking for?",
                  controller: searchController,
                  cPadding: 9.h,
                  // contentPadding : EdgeInsets.only(left: 10, right : 10 , top: 6.h , bottom: 0.h)
                ),
              ),
              SizedBox(width: 20.w,),
              Consumer<NotificationProvider>(
                  builder: (context, apiProvider, child) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                            onTap: () {
                              push(context, const NotificationScreen());
                            },
                            child: Image.asset(
                              "assets/images/notification.png",
                              height: 26,
                            )),
                        if(apiProvider.unreadNotificationIndicator==true)
                          Positioned(
                            top: -3,
                            right: -3,
                            child: Container(
                              height: 19, // Adjust the size as needed
                              width: 19,  // Adjust the size as needed
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: AppText.appText('${apiProvider.unreadNotificationCount}', textColor: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    );
                  }
              )

            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(108.h);
}
