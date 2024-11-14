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

Future showLogOutALert(BuildContext context, var price, var productId,
    var userId, var id, var productUserId) {
  bool loading = false;

  final bidProvider = Provider.of<BidsProvider>(context, listen: false).bids;

  // void sendBidNotification() {
  //   SendNotification.sendNotification(
  //     context: context,
  //     userId: int.parse(productUserId.toString()),
  //     text: 'You have received a new Bid',
  //     type: 'Bid',
  //     typeId: int.parse(productId.toString()),
  //     status: 'Bid',
  //   );
  // }

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
                      if (loading)
                        Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.appColor,
                          ),
                        )
                      else
                        AppButton.appButton("Yes, Place My Bid",
                            onTap: () async {
                          setStatess(() {
                            loading = true;
                          });

                          Map<String, dynamic> body = {
                            "user_id": userId.toString(),
                            "product_id": productId.toString(),
                            "price": price.toString().replaceAll(',', '')
                          };

                          print('body--->${body}');

                          try {
                            var response = await AppDio(context)
                                .post(path: AppUrls.placeBid, data: body);

                            // if (response.statusCode == 200) {
                            var responseData = response.data;

                            if (responseData['status'] == "error") {
                              showSnackBar(context, responseData['message']);
                            } else {
                              await BidsService().getBidsService(
                                  context: context, productId: productId);

                              bidProvider.add(BidsData(
                                id: id,
                                userId: int.parse(userId),
                                productId: productId,
                                price: int.parse(price.toString().replaceAll(',', '')),
                                createdAt: DateTime.now().toIso8601String(),
                                updatedAt: DateTime.now().toIso8601String(),
                              ));

                              showSnackBar(context, responseData["message"], title: 'Success!');
                            }

                            log("response in bid post = ${response.data}");
                            // }
                          } catch (e) {
                            showSnackBar(context, 'An error occurred: $e');
                          } finally {
                            setStatess(() {
                              loading = false;
                            });
                          }

                          // sendBidNotification();

                          Navigator.of(context).pop();
                        },
                            height: 53,
                            fontSize: 14,
                            radius: 32.0,
                            fontWeight: FontWeight.w500,
                            textColor: AppTheme.whiteColor,
                            backgroundColor: AppTheme.appColor),
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
