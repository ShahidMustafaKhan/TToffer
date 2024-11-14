import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class NoDataFound{
  static Widget noDataFound(
      {double? height,
        double? width, double? spacer}) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: spacer ?? 120.h,),
            Image.asset("assets/images/no_data_found.png"),
            SizedBox(height: 32.h,),
            AppText.appText('No Data Found', fontWeight: FontWeight.w600)
          ],
        )
    );
  }

}
