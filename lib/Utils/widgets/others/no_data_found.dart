import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

class NoDataFound{
  static Widget noDataFound(
      {double? height, String? emptyImage,
        double? width, double? spacer, String? emptyText, double? bottomPadding, double? fontSize, double? spaceHeight, double? imageHeight}) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 0),
      child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: spacer ?? 120.h,),
              Image.asset(emptyImage ?? "assets/images/no_data_found.png", height: imageHeight, fit: BoxFit.cover,),
              SizedBox(height: spaceHeight ?? 32.h,),
              AppText.appText(emptyText ?? 'No Data Found', fontWeight: FontWeight.bold, fontSize: fontSize,letterSpacing: 1, textAlign: TextAlign.center)
            ],
          )
      ),
    );
  }

}
