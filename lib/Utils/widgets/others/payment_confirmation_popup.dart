
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';

import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/bids/bids_view_model.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';

Future paymentConfirmation(BuildContext context,
    var price, Function() onTap) {
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      AppText.appText("Confirmation",
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          textColor: const Color(0xff14181B)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: AppText.appText(
                            "Are you sure you want to boost your product in AED $price.",
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Consumer<PaymentViewModel>(
                          builder: (context, paymentViewModel, child){
                            if (paymentViewModel.loading) {
                              return Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.appColor,
                              ),
                            );
                            } else {
                              return AppButton.appButton("Yes, Boost My Product",
                                onTap: onTap,
                                height: 53,
                                fontSize: 14,
                                radius: 32.0,
                                fontWeight: FontWeight.w500,
                                textColor: AppTheme.whiteColor,
                                backgroundColor: AppTheme.appColor);
                            }
                          }
                        ),

                      const SizedBox(
                        height: 10,
                      ),
                      AppButton.appButton("Cancel", onTap: () {
                        Navigator.of(context).pop();
                      },
                          height: 53,
                          fontSize: 14,
                          radius: 32.0,
                          border: true,
                          fontWeight: FontWeight.w500,
                          textColor: AppTheme.blackColor,
                          backgroundColor: AppTheme.whiteColor),
                      const SizedBox(
                        height: 25,
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
