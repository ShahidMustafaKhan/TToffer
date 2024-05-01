import 'package:flutter/material.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

showLogOutALert(BuildContext context, price) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
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
                    AppText.appText("Confirm Bid",
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        textColor: const Color(0xff14181B)),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: AppText.appText(
                          "You have placed a bid for \$$price. Should we place this as your Bid?",
                          textAlign: TextAlign.center,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textColor: const Color(0xff14181B)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton.appButton("Yes, Place My Bid",
                        height: 53,
                        fontSize: 14,
                        radius: 32.0,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.whiteColor,
                        backgroundColor: AppTheme.appColor),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton.appButton("Cancel",
                        height: 53,
                        fontSize: 14,
                        radius: 32.0,
                        border: true,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.blackColor,
                        backgroundColor:AppTheme.whiteColor
                      )
                  ],
                ),
              ),
            ),
          ));
    },
  );
}
