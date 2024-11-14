import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/loading_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

import '../../../Controller/APIs Manager/product_api.dart';

Future CustomAlertDialog(
    {required String title,
    required String description,
    required String cancelButtonTitle,
    required String confirmButtonTitle,
    required BuildContext context,
    required bool loading,
    required Function() onTap}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setStatess) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      if(description != "")
                      FittedBox(
                        child: AppText.appText(title!,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            maxlines: 1,
                            textColor: const Color(0xff14181B)),
                      )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AppText.appText(title!,
                                  fontSize: 26.sp,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w700,
                                  textColor: const Color(0xff14181B)),
                            ),
                          ],
                        ),


                      SizedBox(
                        height: description != "" ? 30.h : 45.h,
                      ),
                      if(description != "")...[
                      Container(
                        child: AppText.appText(description!,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            textColor: const Color(0xff14181B)),
                      ),
                       SizedBox(
                        height: 45.h,),
                      ],
                      Consumer<LoadingProvider>(
                          builder: (context, apiProvider, child) {
                            return apiProvider.loading
                              ? CircularProgressIndicator(color: AppTheme.appColor)
                              : AppButton.appButton(confirmButtonTitle!,
                                  onTap: onTap,
                                  height: 53,
                                  fontSize: 14,
                                  radius: 32.0,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppTheme.whiteColor,
                                  backgroundColor: AppTheme.appColor);
                        }
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      AppButton.appButton(cancelButtonTitle!, onTap: () {
                        Navigator.of(context).pop();
                      },
                          height: 53,
                          fontSize: 14,
                          radius: 32.0,
                          border: true,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.blackColor,
                          backgroundColor: AppTheme.whiteColor),

                       SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ),
            ));
      });
    },
  );
}
