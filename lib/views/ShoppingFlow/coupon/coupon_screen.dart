import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/view_model/coupon/coupon_viewmodel.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_button.dart';
import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../data/response/status.dart';

class GiftCardsCouponsScreen extends StatefulWidget {
  final bool showSuccessMessage;
  const GiftCardsCouponsScreen({super.key, this.showSuccessMessage = false});

  @override
  State<GiftCardsCouponsScreen> createState() => _GiftCardsCouponsScreenState();
}

class _GiftCardsCouponsScreenState extends State<GiftCardsCouponsScreen> {
  TextEditingController couponController = TextEditingController();
  bool isError = false;
  String? successMessage;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar1(
        title: "Gift card, coupons",
      ),
      body: Consumer<CouponViewModel>(
          builder: (context, couponViewModel, child) {
            return couponViewModel.coupon.status == Status.loading ?
            const Center(child: CircularProgressIndicator()) :
            Column(
              children: [
                if(isError == true)
                const Divider(color: Colors.red,),
                Expanded(
                  child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: isError == true ? 9 : 16),
                  child: Column(
                    children: [
                      if(isError == true)
                        Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, color: Colors.red, size: 17.r,),
                          SizedBox(width: 5.w,),
                          Expanded(child: AppText.appText('Looks like that\'s wrong code. Please double-check and try again.', fontSize: 11.sp)),
                        ],
                      ),

                      if(widget.showSuccessMessage == true && successMessage != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.redeem_outlined, color: Colors.green, size: 17.r,),
                            SizedBox(width: 5.w,),
                            Expanded(child: AppText.appText(successMessage!, fontSize: 11.sp, textColor: Colors.green)),
                          ],
                        ),

                      if(isError == true || (widget.showSuccessMessage == true && successMessage != null))
                        SizedBox(height: 12.h,),
                  
                      TextField(
                        controller: couponController,
                        onChanged: (value){
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter a code',
                          hintStyle: TextStyle(fontSize: 13.5.sp),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppButton.appButton('Done',
                            onTap: (){
                            if(couponController.text.isNotEmpty) {
                              couponViewModel.verifyCoupon(couponController.text).
                              then((value){
                                if(widget.showSuccessMessage == true){
                                  showSnackBar(context, 'Discount added on checkout', title: 'Congratulations!');
                                  couponController.text = '';
                                  successMessage = 'Success! Your code has been redeemed, and a discount of AED ${couponViewModel.coupon.data?.value} has been applied to your checkout';
                                  setState(() {});
                                }
                                else{
                                  Navigator.of(context).pop();
                                }
                              }).
                              onError((error, stackTrace){
                                print(error.toString());
                                successMessage = null;
                                isError = true;
                                setState(() {});
                              });
                            }
                            },
                            fontSize: 13.sp,
                            height: 45.h,
                            fontWeight: FontWeight.w600,
                            padding: EdgeInsets.symmetric(vertical: 11.h,),
                            textColor: AppTheme.whiteColor ,
                            backgroundColor: couponController.text.isNotEmpty ? AppTheme.appColor : Colors.grey.shade400,
                            borderColor: couponController.text.isNotEmpty ? AppTheme.appColor : Colors.grey.shade400,
                            radius: 26.sp,
                  
                  
                          ),
                  
                        ],
                      ),
                    ],
                  ),
                            ),
                ),
              ],
            );
        }
      ),
    );
  }
}