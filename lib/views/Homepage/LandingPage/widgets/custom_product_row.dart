
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import '../../../../Utils/resources/res/app_theme.dart';



class ProductTypeDetails extends StatelessWidget {
  final String txt1;
  final String txt3;
  const ProductTypeDetails({super.key, required this.txt1, required this.txt3});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h, top: 0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21.0),
        color: Colors.red,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText.appText(txt1,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.white),
          AppText.appText(txt3,
              fontSize: 10,
              fontWeight: FontWeight.w300,
              textColor: AppTheme.white),
        ],
      ),
    );
  }
}


