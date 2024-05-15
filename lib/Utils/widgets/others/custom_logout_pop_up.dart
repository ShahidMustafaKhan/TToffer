import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

Future showLogOutALert(
    BuildContext context, var price, var productId, var userId, var id) {
  bool loading = false;

  final bidProvider = Provider.of<BidsProvider>(context, listen: false).bids;

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
                            "user_id": userId,
                            "product_id": productId,
                            "price": price
                          };

                          print('bodyyy--->${body}');

                          try {
                            var response = await AppDio(context)
                                .post(path: AppUrls.placeBid, data: body);

                            if (response.statusCode == 200) {
                              var responseData = response.data;

                              await BidsService().getBidsService(
                                  context: context, productId: id);

                              if (responseData['message'] ==
                                  'You can not place bid on your product!') {
                                showSnackBar(context,
                                    'You can not place bid on your product!');
                              } else {
                                bidProvider.add(BidsData(
                                  id: id,
                                  userId: int.parse(userId.toString()),
                                  productId: productId,
                                  price: int.parse(price.toString()),
                                  createdAt: DateTime.now().toIso8601String(),
                                  updatedAt: DateTime.now().toIso8601String(),
                                ));
                              }

                              log("response in bid post = ${response.data}");

                              showSnackBar(context, responseData["message"]);
                            } else {
                              showSnackBar(context,
                                  'Failed to place bid. Please try again.');
                            }
                          } catch (e) {
                            showSnackBar(context, 'An error occurred: $e');
                          } finally {
                            setStatess(() {
                              loading = false;
                            });
                          }

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
