import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/data/app_exceptions.dart';
import 'package:tt_offer/models/payment_card_model.dart';
import 'package:tt_offer/models/subscription_model.dart';

import 'package:tt_offer/view_model/payment/payment_view_model.dart';

import '../Utils/widgets/others/congragulations_dialog.dart';
import '../main.dart';
import '../views/BottomNavigation/navigation_bar.dart';


class PaymentService {

  static Future<void> saveNewCard(int? userId, String? brand, BuildContext context) async {
    // Ensure context is valid and paymentViewModel is accessible
    final paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);

    if (userId == null || brand == null) {
      throw AppException("User ID and Brand cannot be null.");
    }

    try {
      // Step 1: Create a SetupIntent on your backend
      final clientSecret = await paymentViewModel.createPaymentIntent();
      if (clientSecret == null || clientSecret.isEmpty) {
        throw AppException("Failed to retrieve client secret.");
      }

      // Step 2: Confirm card setup with Stripe
      final setupIntentResult =  await Stripe.instance.confirmSetupIntent(
        paymentIntentClientSecret: clientSecret,
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
          ),
        ),
      );

      // Step 3: Add card to the user's account
      await paymentViewModel.addCard(
        userId: userId,
        paymentMethodId: setupIntentResult.paymentMethodId,
        brand: brand,
      );

    } catch (e, stacktrace) {
      // Log the error and rethrow a user-friendly exception
      debugPrint("Error in saveNewCard: $e\n$stacktrace");
      throw AppException("An error occurred while saving the card. Please try again.");
    }
  }

  static Future<void> boostProductWithSavedCard({int? userId, int? cardId, Subscription? subscription, int? productId, required BuildContext context}) async {

    final paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);

    try {
      paymentViewModel.setPaymentLoading(true);
      PaymentCard? paymentCard = await paymentViewModel.getCardDetailSellFaster(userId: userId, id: cardId);

      final paymentId = await paymentViewModel.stripeChargePayment(amount: subscription?.price , paymentMethodId: paymentCard?.paymentMethodId, productId: productId,);

      await paymentViewModel.sellFaster(productId: productId, userId: userId, subscriptionId: subscription?.id, chargeId: paymentId, googlePay: false);

      paymentViewModel.setPaymentLoading(false);
      congratulationAlertDialog(
        title: 'Congratulations!', description: 'Thank you for your purchase! Your product is now live.', context: navigatorKey.currentState!.context, loading: false,
        onTap: () {
          pushReplacement(navigatorKey.currentState!.context, const BottomNavView());
        },
      );
    } catch (error) {
      throw AppException(error.toString());
    }
  }

  static Future<void> boostProductWithGooglePay({required paymentResult, int? productId, int? userId, Subscription? subscriptionModel, required PaymentViewModel paymentViewModel}) async {

    try {
      String? paymentToken = paymentResult['paymentMethodData']['tokenizationData']['token'];
      String? last4Digits =  paymentResult['paymentMethodData']['info']['cardDetails'];
      String? brand =  paymentResult['paymentMethodData']['info']['cardNetwork'];

      if (paymentToken != null && paymentToken.isNotEmpty) {

        await paymentViewModel
            .googlePayPayment(
          amount: subscriptionModel?.price,
          lastFour: last4Digits,
          brand: brand,
          token: paymentToken,
          userId: userId,
        );

        await paymentViewModel.sellFaster(productId: productId, userId: userId, subscriptionId: subscriptionModel?.id, chargeId: paymentToken, googlePay: true);

        paymentViewModel.setPaymentLoading(false);

        congratulationAlertDialog(
          title: 'Congratulations!', description: 'Thank you for your purchase! Your product is now live.', context: navigatorKey.currentState!.context, loading: false,
          onTap: () {
            pushReplacement(navigatorKey.currentState!.context, const BottomNavView());
          },
        );
      } else {
        throw AppException('Payment failed: Invalid token');
      }
    } catch (e) {
      showSnackBar(navigatorKey.currentState!.context, e.toString());
    }
  }



}


