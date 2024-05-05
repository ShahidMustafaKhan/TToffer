import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/models/common_model.dart';
import 'package:tt_offer/utils/utils.dart';

Future CustomAlertDialog(
  BuildContext context,
  String? title,
  String? description,
  String? confirmButtonTitle,

  Function()? onTap,
  bool loading,
  String? cancelButtonTitle,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setStatess) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            child: SingleChildScrollView(
              child: Container(
                height: 346,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      AppText.appText(title!,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          textColor: const Color(0xff14181B)),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: AppText.appText(description!,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            textColor: const Color(0xff14181B)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      loading
                          ? CircularProgressIndicator(color: AppTheme.appColor)
                          : AppButton.appButton(confirmButtonTitle!,
                              onTap: onTap,
                              height: 53,
                              fontSize: 14,
                              radius: 32.0,
                              fontWeight: FontWeight.w500,
                              textColor: AppTheme.whiteColor,
                              backgroundColor: AppTheme.appColor),
                      const SizedBox(
                        height: 10,
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
                          backgroundColor: AppTheme.whiteColor)
                    ],
                  ),
                ),
              ),
            ));
      });
    },
  );
}
