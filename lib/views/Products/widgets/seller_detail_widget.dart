import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../models/product_model.dart';
import '../../Profile Screen/profile_screen.dart';
import '../../Seller Profile/seller_profile.dart';

class SellerDetailWidget extends StatelessWidget {
  final String? authorizationToken;
  final Product? product;

  const SellerDetailWidget({super.key, this.authorizationToken, this.product});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(product?.user != null)
              InkWell(
                onTap: (){
                    push(
                        context,
                        SellerProfileScreen(
                            sellerProfile:
                            product?.user));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: product?.user==null || product?.user?.img == null
                                      ? const AssetImage(
                                      'assets/images/auction2.png')
                                      : NetworkImage(
                                      product!.user!.img!)
                                  as ImageProvider,
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2,),
                              GestureDetector(
                                onTap: (){
                                    push(
                                        context,
                                        SellerProfileScreen(
                                            sellerProfile:
                                            product?.user));

                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.appText(
                                        capitalizeWords(product?.user?.name ?? ''),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppTheme.blackColor),

                                    SizedBox(width : 5.w),
                                    if(product?.user?.emailVerifiedAt !=null &&
                                        product?.user?.imageVerifiedAt !=null &&
                                        product?.user?.phoneVerifiedAt !=null)
                                      const Icon(Icons.check_circle, color: Colors.green, size: 19),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.h,),
                              GestureDetector(
                                onTap: (){
                                  if(authorizationToken!=null){
                                    push(
                                        context,
                                        SellerProfileScreen(
                                          sellerProfile:
                                          product?.user,
                                          review: true,
                                        ));
                                  }
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      StarRating(
                                        percentage: percentageOfFive(product?.user?.reviewPercentage ?? 0),
                                        color: Colors.yellow,
                                        size: 18,
                                      ),
                                      SizedBox(width: 5.w,),
                                      if(product?.user?.reviewPercentage != null)
                                        AppText.appText(starCount(product?.user?.reviewPercentage),
                                            textAlign: TextAlign.center,
                                            fontSize: 9.5.sp,
                                            fontWeight: FontWeight.w400,
                                            textColor: AppTheme.txt1B20),
                                    ]),
                              )
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          const Icon(Icons.chevron_right)

                        ],
                      ),
                    ),
                    // if(product?.user?.emailVerifiedAt !=null &&
                    //     product?.user?.imageVerifiedAt !=null &&
                    //     product?.user?.phoneVerifiedAt !=null)
                    //   Row(
                    //     children: [
                    //       Image.asset(
                    //         "assets/images/verify.png",
                    //         height: 24,
                    //       ),
                    //       AppText.appText("Verified Member",
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.w500,
                    //           textColor: AppTheme.blackColor),
                    //     ],
                    //   ),
                  ],
                ),
              ),

                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: AppText.appText(
                //       formatTimestamp(
                //           product?.createdAt ?? ''),
                //       fontSize: 10,
                //       fontWeight: FontWeight.w400,
                //       textColor: AppTheme.lighttextColor),
                // ),
          ],
        ),
      ),
    );
  }
  
}
