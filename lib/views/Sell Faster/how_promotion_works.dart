import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

import '../../Utils/widgets/others/custom_app_bar.dart';
import '../BottomNavigation/navigation_bar.dart';

class HowPromotionWorks extends StatefulWidget {

  const HowPromotionWorks({super.key});

  @override
  State<HowPromotionWorks> createState() => _HowPromotionWorksState();
}

class _HowPromotionWorksState extends State<HowPromotionWorks> {


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar1(
        title: "Boost My Listing",
        selFaster: false,
        leading: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w,60.h,24.w,34.h),
        child: Column(
          children: [
            Center(child: Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: SvgPicture.asset("assets/svg/upgrade.svg"),
            )),
            SizedBox(height: 64.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText('Sell fast with Boost Plus', fontSize: 14.sp, fontWeight: FontWeight.w600),
                SizedBox(height: 34.h,),
                Row(
                  children: [
                    Image.asset('assets/images/shield-tick.png', width: 24.w, height: 24.w,),
                    SizedBox(width: 16.w,),
                    AppText.appText('Get an average of 20x more views each day', fontSize: 12.sp, fontWeight: FontWeight.normal),

                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Image.asset('assets/images/shield-tick.png', width: 24.w, height: 24.w,),
                    SizedBox(width: 16.w,),
                    AppText.appText('Promote for multiple days', fontSize: 12.sp, fontWeight: FontWeight.normal),

                  ],
                ),
                SizedBox(height: 16.h,),
                Row(
                  children: [
                    Image.asset('assets/images/shield-tick.png', width: 24.w, height: 24.w,),
                    SizedBox(width: 16.w,),
                    AppText.appText('Switch promotion to any item', fontSize: 12.sp, fontWeight: FontWeight.normal),

                  ],
                ),
                SizedBox(height: 32.h,),
                AppButton.appButton('Boost Plus',
                    onTap: (){
                      pushUntil(context, const BottomNavView(index: 2,));
                    },
                    imagePath: "assets/images/ic_arrow_up.png", padding: EdgeInsets.symmetric(vertical: 16.w), radius: 32.r )
              ],
            ),
            SizedBox(height: 40.h,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.appText('Already a subscriber?', fontSize: 14.sp, fontWeight: FontWeight.w600),
                SizedBox(height: 16.h,),
                AppText.appText('To change your subscription visit your App store. If you cancel, your subscription will run to the end of this billing period', fontSize: 12.sp, fontWeight: FontWeight.normal, ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}
