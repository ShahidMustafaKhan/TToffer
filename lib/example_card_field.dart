import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/custom_requests/sell-faster_stripe_api.dart';
import 'package:tt_offer/models/selling_products_model.dart';

class CardHomeScreen extends StatefulWidget {
  Selling? selling;
  String? amount;
  String? currency;
  String? day;

  CardHomeScreen(
      {super.key, this.selling, this.amount, this.day, this.currency});

  @override
  _CardHomeScreenState createState() => _CardHomeScreenState();
}

class _CardHomeScreenState extends State<CardHomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardFieldInputDetails? _card;

  bool loading = false;

  void _handlePayPress() async {
    if (_formKey.currentState?.validate() == true && _card != null) {
      try {
        final tokenData = await Stripe.instance.createPaymentMethod(
          params: const PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(),
          ),
        );
        print('Token generated: ${tokenData.id}');

        await fasterProductHandler(
            widget.day!, widget.amount!, widget.currency!, tokenData.id);

        // You can send this token to your backend server to process the payment
      } catch (e) {
        print('Error: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar1(
        title: 'Subscription',
      ),
      body: Padding(
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
                    ? CircularProgressIndicator(color: AppTheme.appColor)
                    : AppButton.appButton('Pay',
                        backgroundColor: AppTheme.appColor,
                        height: 50,
                        textColor: Colors.white,
                        onTap: _handlePayPress),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
