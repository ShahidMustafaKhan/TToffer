import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Controller/image_provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/views/Post%20screens/post_card_payment.dart';
import 'package:http/http.dart' as http;

class PostProductPayment extends StatefulWidget {
  String image;
  String title;

  int productId;
  int amount;

  PostProductPayment(
      {required this.image,
      required this.amount,
      required this.productId,
      required this.title});

  @override
  State<PostProductPayment> createState() => _PostProductPaymentState();
}

class _PostProductPaymentState extends State<PostProductPayment> {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageNotifyProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar1(
        title: "Post Product Payment",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(imageProvider.imagePaths[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.appText(widget.title,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                textColor: AppTheme.txt1B20),
                            const SizedBox(
                              height: 5,
                            ),
                            AppText.appText(widget.amount.toString(),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppTheme.txt1B20),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const CustomDivider(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 180,
                width: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.appColor),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppText.appText("Post your product in",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppTheme.blackColor),
                    AppText.appText("\$10",
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        textColor: AppTheme.blackColor),
                    AppButton.appButton("Pay Now", height: 42, onTap: () {
                      // push(context, const PostingPaymentScreen());
                      makePayment('10', '1');
                    },
                        width: 161,
                        textColor: AppTheme.whiteColor,
                        backgroundColor: AppTheme.appColor,
                        radius: 32.0)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  fasterProductHandler(String? day, String? amount, String? currency) {
    SellFasterStripeService().sellFasterStripeService(
        context: context,
        productId: widget.productId!,
        nod: day,
        amount: amount,
        currency: currency,
        token: '123');
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
}
