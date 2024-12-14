import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/APIs%20Manager/send_notification_service.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/config/dio/app_dio.dart';
import 'package:tt_offer/custom_requests/bids_service.dart';
import 'package:tt_offer/models/bids_model.dart';
import 'package:tt_offer/models/common_model.dart';
import 'package:tt_offer/providers/bids_provider.dart';
import 'package:tt_offer/utils/utils.dart';
import 'package:tt_offer/view_model/bids/bids_view_model.dart';

Future placeBidDialog(BuildContext context, var price, var productId,
    var userId, var productUserId) {


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
                      AppText.appText("Confirm Bid",
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          textColor: const Color(0xff14181B)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: AppText.appText(
                            "ATTENTION! WHEN YOU CONFIRM YOUR BID, IT MEANS YOU’RE AGREE TO BUY THIS ITEM IN CASE IF YOU WIN THIS AUCTION. IF YOU REFUSE TO BUY THIS PRODUCT, YOU WILL NOT BE ABLE TO PLACE BIDS FOR AUCTION PRODUCTS.",
                            // "You have placed a bid for AED ${formatNumber(price)}. Should we place this as your Bid?",
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.red),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Consumer<BidsViewModel>(
                          builder: (context, bidsViewModel, child){
                            if (bidsViewModel.bidsLoading) {
                              return Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.appColor,
                              ),
                            );
                            } else {
                              return AppButton.appButton("Yes, Place My Bid",
                                onTap: () async {


                                  Map<String, dynamic> data = {
                                    "user_id": userId,
                                    "product_id": productId,
                                    "price": int.parse(price.toString().replaceAll(',', ''))
                                  };

                                  bidsViewModel.placeBid(data).then((value){
                                    Navigator.of(context).pop();
                                    showSnackBar(context, 'Bid placed successfully', title: 'Congratulations!');
                                  }).onError((error, stackTrace){
                                    Navigator.of(context).pop();
                                    showSnackBar(context, error.toString());
                                  });

                                  // sendBidNotification();

                                },
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
