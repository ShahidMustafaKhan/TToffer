import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

Future congratulationAlertDialog(
    {required String? title,
    required String description,
    required BuildContext context,
    required bool loading,
    bool isDismissible = false,
    required Function() onTap}) {
  return showDialog(
    barrierDismissible : isDismissible,
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      FittedBox(
                        child: AppText.appText(title ?? "Congratulations!",
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            maxlines: 1,
                            textColor: const Color(0xff14181B)),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        child: AppText.appText(description,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            textColor: const Color(0xff14181B)),
                      ),
                       SizedBox(
                        height: 45.h,),
                      loading
                          ? CircularProgressIndicator(color: AppTheme.appColor)
                          : AppButton.appButton("Done",
                              onTap: onTap,
                              height: 53,
                              fontSize: 14,
                              radius: 32.0,
                              fontWeight: FontWeight.w500,
                              textColor: AppTheme.whiteColor,
                              backgroundColor: AppTheme.appColor),

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
