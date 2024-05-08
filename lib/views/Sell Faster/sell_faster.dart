import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/listview_container.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:http/http.dart' as http;

class SellFaster extends StatefulWidget {
  const SellFaster({super.key, required this.selling});

  final Selling selling;

  @override
  State<SellFaster> createState() => _SellFasterState();
}

class _SellFasterState extends State<SellFaster> {
  List<SellFasterData> sellFastData = [
    SellFasterData(
        boostDays: "3",
        amount: "3",
        subscriptionName: "Basic",
        amountInCents: 300),
    SellFasterData(
        boostDays: "5",
        amount: "5",
        subscriptionName: "Standard",
        amountInCents: 500),
    SellFasterData(
        boostDays: "7",
        amount: "7",
        subscriptionName: "Premium",
        amountInCents: 700),
  ];

  fasterProductHandler(String? day, String? amount, String? currency) {
    SellFasterStripeService().sellFasterStripeService(
        context: context,
        productId: widget.selling.id,
        nod: day,
        amount: amount,
        currency: currency,
        token: '123');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar1(
        title: "Sell Faster",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            ListViewContainer(
              selling: widget.selling,
            ),
            const CustomDivider(),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 206,
              width: getWidth(context) * .8,
              child: ListView.builder(
                itemCount: sellFastData.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        height: 206,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.appColor),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppText.appText(
                                sellFastData[index].subscriptionName,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.appColor),
                            AppText.appText(
                                "Boost ${sellFastData[index].boostDays} Days",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textColor: AppTheme.blackColor),
                            AppText.appText("\$${sellFastData[index].amount}",
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                textColor: AppTheme.blackColor),
                            AppButton.appButton("Subscribe", height: 42,
                                onTap: () async {
                              makePayment(sellFastData[index].amount.toString(),
                                  sellFastData[index].boostDays);
                            },
                                width: 161,
                                textColor: AppTheme.whiteColor,
                                backgroundColor: AppTheme.appColor,
                                radius: 32.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: customRow(txt: "Switch promotion to any item."),
            ),
            const SizedBox(
              height: 40,
            ),
            AppText.appText("How does promoting work?",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: AppTheme.appColor),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(String amount, String? days) async {
    try {
      paymentIntentData = await createPaymentIntent(
          double.parse(amount).round().toString(),
          'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  // primaryButtonLabel: 'Google',
                  allowsDelayedPaymentMethods: true,
                  appearance: const PaymentSheetAppearance(
                      primaryButton: PaymentSheetPrimaryButtonAppearance()),
                  // applePay: const PaymentSheetApplePay(
                  //     merchantCountryCode: 'PK',
                  //     cartItems: [],
                  //     buttonType: PlatformButtonType.checkout),
                  // googlePay: const PaymentSheetGooglePay(
                  //     merchantCountryCode: 'PK',
                  //     testEnv: true,
                  //     buttonType: PlatformButtonType.checkout),
                  style: ThemeMode.system,
                  // appearance: PaymentSheetAppearance(
                  //     colors: PaymentSheetAppearanceColors(
                  //         primary: Colors.black,
                  //         background: Colors.orange[100])),
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet
      await displayPaymentSheet();
      fasterProductHandler(days, amount, 'USD');
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());

        setState(() {});

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Payment Successful")));
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

//  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51JUUldDdNsnMpgdhx8kWqPhfiqHAHUVcd0BDw48M5HiP5GF36hOROHX2A2kq5BxYrzN2uZysgeDKpyTTzpOD1Ncf008VybA4Gu',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Widget customRow({txt}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/shield-tick.png",
            height: 24,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.79,
            child: AppText.appText("$txt",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppTheme.txt1B20),
          ),
        ],
      ),
    );
  }
}

class SellFasterData {
  final String boostDays;
  final String amount;
  final String subscriptionName;

  final int amountInCents;

  SellFasterData(
      {required this.boostDays,
      required this.amount,
      required this.subscriptionName,
      required this.amountInCents});
}
