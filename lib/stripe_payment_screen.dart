import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/app_field.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/utils/utils.dart';

class StripePaymentScreen extends StatefulWidget {
  Selling? selling;
  String? amount;
  String? currency;
  String? day;

  StripePaymentScreen(
      {super.key, this.selling, this.amount, this.day, this.currency});

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardFieldInputDetails? _card;

  bool loading = false;

  void _handlePayPress() async {
    if (_formKey.currentState?.validate() == true && _card != null) {
      try {
        TokenData data =
            await Stripe.instance.createToken(const CreateTokenParams.card(
                params: CardTokenParams(
          currency: "usd",
        )));

        // final tokenData = await Stripe.instance.createPaymentMethod(
        //   params: const PaymentMethodParams.card(
        //     paymentMethodData: PaymentMethodData(),
        //   ),
        // );
        print('Token generated: ${data.id}');

        await fasterProductHandler(
            widget.day!, widget.amount!, widget.currency!, data.id);

        // You can send this token to your backend server to process the payment
      } catch (e) {
        print('Error: $e');

        showSnackBar(context, "Something went wrong");
      }
    }
  }

  fasterProductHandler(
      String day, String amount, String currency, String token) async {
    setState(() {
      loading = true;
    });

    await SellFasterStripeService().sellFasterStripeService(
        context: context,
        productId: widget.selling!.id,
        nod: day,
        amount: amount,
        currency: currency,
        token: token);
    setState(() {
      loading = false;
    });
  }

  String? selectedValue;
  String? selectPayment;

  TextEditingController cardName = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController cvc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: CustomAppBar1(
        title: 'Subscription',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ImageWithRadio(
                    val: '1',
                    groupValue: selectedValue,
                    image: 'apple1',
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                        selectPayment = 'Apple';
                      });
                    },
                  ),
                  ImageWithRadio(
                    val: '2',
                    groupValue: selectedValue,
                    image: 'visa',
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                        selectPayment = 'Visa';
                      });
                    },
                  ),
                  ImageWithRadio(
                    val: '3',
                    groupValue: selectedValue,
                    image: 'master',
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                        selectPayment = 'Master';
                      });
                    },
                  ),
                  ImageWithRadio(
                    val: '4',
                    groupValue: selectedValue,
                    image: 'google1',
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                        selectPayment = 'Google';
                      });
                    },
                  ),
                ],
              ),
            ),
            if (selectPayment == 'Apple' || selectPayment == 'Google')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomAppFormField(
                        texthint: 'Card Name', controller: cardName),
                    const SizedBox(height: 15),
                    CustomAppFormField(
                        texthint: 'Card Number', controller: cardNumber),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                            child: CustomAppFormField(
                                texthint: 'mm/yy', controller: month)),
                        const SizedBox(width: 10),
                        Expanded(
                            child: CustomAppFormField(
                                texthint: 'Last name', controller: cvc)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    AppButton.appButton('Pay Now',
                        height: 50, textColor: Colors.white)
                  ],
                ),
              )
            else
              const SizedBox.shrink(),
            selectPayment == 'Master' || selectPayment == 'Visa'
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CardFormField(
                              onCardChanged: (card) {
                                _card = card;
                              },
                              style: CardFormStyle(
                                  borderRadius: 10,
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.black,
                                  textColor: Colors.black,
                                  borderWidth: 1),
                            ),
                            loading
                                ? CircularProgressIndicator(
                                    color: AppTheme.appColor)
                                : AppButton.appButton('Pay',
                                    backgroundColor: AppTheme.appColor,
                                    height: 50,
                                    textColor: Colors.white,
                                    onTap: _handlePayPress),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ImageWithRadio extends StatefulWidget {
  final String? image;
  final String? val;
  final String? groupValue;

  final Function(String?)? onChanged;

  ImageWithRadio({this.val, this.image, this.onChanged, this.groupValue});

  @override
  State<ImageWithRadio> createState() => _ImageWithRadioState();
}

class _ImageWithRadioState extends State<ImageWithRadio> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/images/${widget.image}.png'),
              )),
          Radio<String>(
            activeColor: AppTheme.appColor,
            value: widget.val!,
            groupValue: widget.groupValue,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
