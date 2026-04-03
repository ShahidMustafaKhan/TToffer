import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';

import '../../Utils/resources/res/app_theme.dart';
import '../../Utils/utils.dart';
import '../../Utils/widgets/others/app_button.dart';
import '../../Utils/widgets/others/custom_app_bar.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String? orderId;
  const PaymentSuccessScreen({super.key, this.orderId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: 'Order Received',
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/ic_check.png'),
                const SizedBox(height: 15),
                Text(
                  'Transaction is complete!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your order id is $orderId.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                AppButton.appButton('Explore Ads',
                  onTap: (){
                      pushUntil(context, const BottomNavView());
                  },
                  fontSize: 13.sp,
                  height: 45.h,
                  fontWeight: FontWeight.w600,
                  padding: EdgeInsets.symmetric(vertical: 11.h,),
                  textColor: AppTheme.whiteColor,
                  backgroundColor:  AppTheme.appColor ,
                  borderColor:  AppTheme.appColor,
                  radius: 26.sp,
                  imageColor: AppTheme.white ,

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
