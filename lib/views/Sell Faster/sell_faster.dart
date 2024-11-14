import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/listview_container.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/Utils/widgets/others/congragulations_dialog.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/Utils/widgets/others/divider.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/stripe_payment_screen.dart';
import 'package:tt_offer/utils/widgets/custom_loader.dart';
import 'package:http/http.dart' as http;
import 'package:tt_offer/views/Sell%20Faster/how_promotion_works.dart';

import '../../Controller/image_provider.dart';
import '../BottomNavigation/navigation_bar.dart';

class SellFaster extends StatefulWidget {
  const SellFaster({super.key, required this.selling, this.fromLocation=false});

  final Selling selling;
  final bool fromLocation;

  @override
  State<SellFaster> createState() => _SellFasterState();
}

class _SellFasterState extends State<SellFaster> {
  List<SellFasterData> sellFastData = [
    SellFasterData(
        boostDays: "3",
        amount: "10",
        subscriptionName: "Basic",
        amountInCents: 10),
    SellFasterData(
        boostDays: "7",
        amount: "20",
        subscriptionName: "Standard",
        amountInCents: 20),
    SellFasterData(
        boostDays: "15",
        amount: "30",
        subscriptionName: "Premium",
        amountInCents: 30),
    SellFasterData(
        boostDays: "30",
        amount: "50",
        subscriptionName: "Elite",
        amountInCents: 50),
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
    final imageProvider = Provider.of<ImageNotifyProvider>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: widget.fromLocation==true ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: AppButton.appButton("Done", onTap: () async {
          imageProvider.imagePaths.clear();
          imageProvider.vedioPath = '';
          pushUntil(context, BottomNavView(showDialog: widget.fromLocation ? true : false,));
           // await getPaymentStatus();
        },
            height: 53,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            radius: 32.0,
            backgroundColor: AppTheme.appColor,
            textColor: AppTheme.whiteColor),
      ) : const SizedBox(),
      appBar: CustomAppBar1(
        title: "Sell Faster",
        selFaster: false,
        leading: true,
        dialog: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListViewContainer(
                selling: widget.selling,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomDivider(),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              child: ListView.separated(
                itemCount: sellFastData.length,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                physics : const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        height: 165,
                        width: 240,
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
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                textColor: AppTheme.blackColor),
                            AppText.appText("AED ${sellFastData[index].amount}",
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                textColor: AppTheme.blackColor),
                            AppButton.appButton("Subscribe", height: 38,
                                onTap: () async {
                              push(
                                  context,
                                  StripePaymentScreen(
                                      selling: widget.selling,
                                      amount: sellFastData[index].amount,
                                      currency: 'AED',
                                      day: sellFastData[index].boostDays));
        
                              // makePayment(sellFastData[index].amount.toString(),
                              //     sellFastData[index].boostDays);
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
                }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 4.h,); },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0,left: 0),
              child: customRow(txt: "Switch promotion to sell faster"),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: (){
                push(context, const HowPromotionWorks());
              },
              child: AppText.appText("How does promoting work?",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: AppTheme.yellowColor),
            ),
            const SizedBox(
              height: 25,
            ),
            SvgPicture.asset('assets/images/boosting.svg',
            height: 280.h,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(String amount, String? days) async {
    // await StripePlatform.instance
    //     .createToken(CreateTokenParams.card(params: CardTokenParams(

    //     )));

    var secretkey = await createPaymentIntent("500", "usd");

    StripePlatform.instance.collectBankAccountToken(
      clientSecret: secretkey['client_secret'],
    );

    // final cardDetails = CardDetails(
    //   number: '4242424242424242',
    //   expirationMonth: 5,
    //   expirationYear: 2024,
    //   cvc: '314',
    // );
    final TokenData tokenData = await Stripe.instance.createToken(
      const CreateTokenParams.bankAccount(
          params: BankAccountTokenParams(
              accountNumber: "000123456789",
              type: TokenType.BankAccount,
              accountHolderName: "John Doe",
              routingNumber: "110000000",
              accountHolderType: BankAccountHolderType.Individual,
              country: "US",
              currency: "usd")),
    );
    log("tokenData = $tokenData ");
    // try {
    //   paymentIntentData = await createPaymentIntent(
    //       double.parse(amount).round().toString(),
    //       'USD'); //json.decode(response.body);
    //   // print('Response body==>${response.body.toString()}');
    //   await Stripe.instance
    //       .initPaymentSheet(
    //           paymentSheetParameters: SetupPaymentSheetParameters(
    //               paymentIntentClientSecret:
    //                   paymentIntentData!['client_secret'],
    //               // primaryButtonLabel: 'Google',
    //               allowsDelayedPaymentMethods: true,
    //               appearance: const PaymentSheetAppearance(
    //                   primaryButton: PaymentSheetPrimaryButtonAppearance()),
    //               // applePay: const PaymentSheetApplePay(
    //               //     merchantCountryCode: 'PK',
    //               //     cartItems: [],
    //               //     buttonType: PlatformButtonType.checkout),
    //               // googlePay: const PaymentSheetGooglePay(
    //               //     merchantCountryCode: 'PK',
    //               //     testEnv: true,
    //               //     buttonType: PlatformButtonType.checkout),
    //               style: ThemeMode.system,
    //               // appearance: PaymentSheetAppearance(
    //               //     colors: PaymentSheetAppearanceColors(
    //               //         primary: Colors.black,
    //               //         background: Colors.orange[100])),
    //               // merchantCountryCode: 'US',
    //               merchantDisplayName: 'ANNIE'))
    //       .then((value) {});

    //   ///now finally display payment sheeet
    //   await displayPaymentSheet();
    //   fasterProductHandler(days, amount, 'USD');
    // } catch (e, s) {
    //   print('exception:$e$s');
    // }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) async {
        if (kDebugMode) {
          print('payment intent${paymentIntentData!['client_secret']}');
          print('payment intent${paymentIntentData!['amount']}');
          print('payment intent$paymentIntentData');
          print('payment intent${paymentIntentData!['id']}');
        }

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image.asset(
          //   "assets/images/shield-tick.png",
          //   height: 24,
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          AppText.appText("$txt",
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              textColor: AppTheme.txt1B20),
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
