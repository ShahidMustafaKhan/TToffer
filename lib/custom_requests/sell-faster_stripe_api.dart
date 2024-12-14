import 'package:flutter/cupertino.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/view_model/payment/payment_view_model.dart';
import 'package:tt_offer/views/BottomNavigation/navigation_bar.dart';

import '../Utils/widgets/others/congragulations_dialog.dart';
import '../config/app_urls.dart';

class SellFasterStripeService {
  Future<bool> sellFasterStripeService({
    required BuildContext context,
    required PaymentViewModel paymentViewModel,
    int? productId,
    String? nod,
    String? amount,
    String? currency,
    String? token,

  }) async {

      paymentViewModel.sellFaster(
        productId: productId, nod: nod, amount: amount, currency: currency, token: token, save: false
      ).then((value){
        congratulationAlertDialog(
          title: 'Congratulations!', description: 'Thank you for your purchase! Your product is now live.', context: context, loading: false,
          onTap: () {
            pushReplacement(context, const BottomNavView());
          },
        );
        return true;
      }).onError((error, stackTrace) {
        showSnackBar(context, error.toString());
        return false;
      });

      return false;



  }

  Future<bool> sellFasterGooglePay({
    required BuildContext context,
    required PaymentViewModel paymentViewModel,
    int? productId,
    String? nod,
    String? amount,
    String? currency,
    String? token,
    String? brand,
    String? lastFour,
  }) async {

        paymentViewModel.googlePay(
            productId: productId, nod: nod, amount: amount, currency: currency, token: token,brand: brand, lastFour: lastFour
        ).then((value){
          congratulationAlertDialog(
            title: 'Congratulations!', description: 'Thank you for your purchase! Your product is now live.', context: context, loading: false,
            onTap: () {
              pushReplacement(context, const BottomNavView());
            },
          );
          return true;
        }).onError((error, stackTrace) {
          showSnackBar(context, error.toString());
          return false;
        });

        return false;

  }
}
