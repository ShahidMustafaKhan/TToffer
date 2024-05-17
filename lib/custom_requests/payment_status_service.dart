import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/custom_requests/custom_post_request.dart';
import 'package:tt_offer/main.dart';
import 'package:tt_offer/models/payment_fee_model.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/payment_fee_provider.dart';
import 'package:tt_offer/stripe_test.dart';
import 'package:tt_offer/views/Homepage/landing_screen.dart';
import 'package:tt_offer/views/Post%20screens/enter_location_screen.dart';
import 'package:tt_offer/views/Post%20screens/payment_charge_screen.dart';

class PaymentStatusService {
  Future paymentStatusService({
    required BuildContext context,
    Selling? selling,
  }) async {
    try {
      var res = await customGetRequest.httpGetRequest(url: 'payment-status');

      if (res['success'] == true && res["data"]["value"] == "1") {
        navigate = true;
        print('object--->${navigate}');
        push(
            context,
            selling != null
                ? PostLocationScreen(
                    amount: 1,
                    title: 'title',
                    selling: selling,
                    productId: selling.id,
                  )
                : StripePaymentChargeScreen(
                    selling: selling,
                  ));
      } else if (res['success'] == true && res["data"]["value"] == "0") {
        navigate = false;
        return false;
      }
    } catch (err) {
      print('Error in paymentStatusService: $err');
      return false;
    }
  }

  Future paymentFeeGetService({
    required BuildContext context,
  }) async {
    try {
      var res = await customGetRequest.httpGetRequest(url: 'payment-status');

      if (res['success'] == true) {
        PaymentFeeModel paymentFeeModel = PaymentFeeModel.fromJson(res);

        Provider.of<PaymentFeeProvider>(context, listen: false)
            .getPayment(newPaymentFeeModel: paymentFeeModel);
        return true;
      } else {
        throw Exception('Invalid response: $res');
      }
    } catch (err) {
      print('Error in paymentFeeGetService: $err');
      return false;
    }
  }

  Future addCharge(
      {required BuildContext context,
      String? amount,
      String? currency,
      Selling? selling,
      String? token}) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'token': token,
      };

      var res =
          await CustomPostRequest().httpPostRequest(url: 'charge', body: body);

      if (res['success'] == true) {
        showSnackBar(context, '${res['message']}');

        push(
            context,
            PostLocationScreen(
              selling: selling,
              productId: firstTimeProductId,
              amount: 0,
              title: 'name',
            ));
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }
}
