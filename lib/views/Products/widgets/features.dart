import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tt_offer/views/Products/widgets/divider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/utils.dart';
import '../../../Utils/widgets/others/app_button.dart';
import '../../../Utils/widgets/others/app_text.dart';
import '../../../custom_requests/dynmaic_link_service.dart';
import '../../../detail_model/attribute_model.dart';
import '../../../models/product_model.dart';
import '../../Authentication screens/login_screen.dart';
import '../../ChatScreens/offer_chat_screen.dart';
import '../../Profile Screen/profile_screen.dart';
import '../../Seller Profile/seller_profile.dart';
import '../Feature Product/widgets/make_offer_screen.dart';

class FeatureWidget extends StatelessWidget {
  final Product? product;
  final PropertyAttributes? propertyAttributes;

  const FeatureWidget({super.key, this.product, this.propertyAttributes});


  @override
  Widget build(BuildContext context) {

    List<String> features = [];

    if (propertyAttributes?.features is List) {
      // Safely cast to List<dynamic> and process each item
      for (var item in (propertyAttributes?.features as List)) {
        features.add(item.toString());
      }
    }

    return features.isNotEmpty ? Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 17.0, bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.appText(
                      "Features",
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      textColor: AppTheme.blackColor),

                  Column(
                    children: [
                      for (int i = 0; i < features.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 13.0, left: 2.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                             const Icon(Icons.check, size: 14,),

                              SizedBox(width: 10.w,),

                              SizedBox(
                                width: 160.w,
                                child: AppText.appText(
                                    "${features[i]} ",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppTheme.textColor
                                ),
                              ),


                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
        const AddDivider(),
      ],
    ) : const SizedBox();
  }
}
