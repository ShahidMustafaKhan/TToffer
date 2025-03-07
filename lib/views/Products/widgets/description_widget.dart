import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../models/product_model.dart';


class DescriptionWidget extends StatelessWidget {
  final Product? product;


  const DescriptionWidget({super.key, this.product});


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.appText(
              "Description",
              fontSize: 17,
              fontWeight: FontWeight.w900,
              textColor: AppTheme.blackColor),
          SizedBox(height: 5.h,),

          AppText.appText(
              product?.description ?? '',
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              textColor: AppTheme.lighttextColor),


        ],
      ),
    );
  }

}
