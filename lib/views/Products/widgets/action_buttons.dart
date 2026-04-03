import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_button.dart';
import '../../../custom_requests/dynmaic_link_service.dart';
import '../../../models/product_model.dart';
import '../../Authentication screens/login_screen.dart';

class ActionButtons extends StatelessWidget {
  String? authorizationToken;
  Product? product;
  bool isFav;
  int? userId;
  
  ActionButtons({super.key, this.authorizationToken, this.product , this.isFav=false, this.userId});

  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // if(userId.toString() != product?.userId.toString())
          // Expanded(
          //   child: Consumer<UserViewModel>(
          //       builder: (context, userViewModel, child) {
          //         return AppButton.appButton("Save", onTap: () async {
          //         if(authorizationToken!=null){
          //           userViewModel.toggleSavedItem(userId, product?.id, context);
          //         }
          //         else{
          //           push(context, const SigInScreen());
          //
          //         }
          //
          //       },
          //           height: 35.h,
          //           width: MediaQuery.of(context).size.width*0.5,
          //           radius: 32.r,
          //           fontWeight: FontWeight.w600,
          //           fontSize: 14,
          //           backgroundColor: const Color(0xffdfdde0),
          //           borderColor: Colors.transparent,
          //           borderWidth: 2,
          //           imagePath: userViewModel.isProductInSavedList(product?.id) ? "assets/svg/ic_heart_dark.svg" : "assets/svg/ic_heart.svg",
          //           imageColor: userViewModel.isProductInSavedList(product?.id) ? null : AppTheme.appColor,
          //           textColor: AppTheme.appColor);
          //     }
          //   ),
          // ),
          // if(userId.toString() != product?.userId?.toString())
          //   SizedBox(width: 10.w,),
          if(userId.toString() != product?.userId?.toString())
            Expanded(
              child: AppButton.appButton("Report", onTap: () async {
                if(authorizationToken!=null && product!=null && product!.id != null){
                  reportProduct(
                      context,
                      product!.id!,
                      userId!
                  );}
                else{
                  push(context, const SigInScreen());

                }
              },
                  height: 35.h,
                  width: MediaQuery.of(context).size.width*0.45,
                  radius: 32.r,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  backgroundColor: const Color(0xffdfdde0),
                  borderColor: Colors.transparent,
                  borderWidth: 2,
                  imagePath: "assets/svg/ic_flag.svg",
                  imageColor: AppTheme.appColor,
                  textColor: AppTheme.appColor),
            ),
          SizedBox(width: 10.w,),
          Expanded(
            child: AppButton.appButton("Share", onTap: () async {
              shareProductLink();
            },
                height: 35.h,
                width: MediaQuery.of(context).size.width*0.35,
                radius: 32.r,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                backgroundColor: const Color(0xffdfdde0),
                borderColor: Colors.transparent,
                imagePath: "assets/svg/ic_share.svg",
                imageColor: AppTheme.appColor,
                borderWidth: 2,
                textColor: AppTheme.appColor),
          ),

        ],
      ),
    );
  }
  Future<void> shareProductLink() async {
    String shareLink = await DynamicLinkService().createDynamicLink(product?.id?.toString() ?? '', product?.productType == 'auction' ? 'auction' : "featured");
    Share.share('Check out this ad: $shareLink');
  }
}
