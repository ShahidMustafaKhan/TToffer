import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/resources/res/app_theme.dart';
import 'package:tt_offer/Utils/widgets/others/app_button.dart';
import 'package:tt_offer/Utils/widgets/others/custom_app_bar.dart';
import 'package:tt_offer/custom_requests/payment_status_service.dart';
import 'package:tt_offer/models/payment_fee_model.dart';
import 'package:tt_offer/models/selling_products_model.dart';
import 'package:tt_offer/providers/payment_fee_provider.dart';
import 'package:tt_offer/utils/utils.dart';

import '../../models/product_model.dart';

class StripePaymentChargeScreen extends StatefulWidget {
  final Product? product;

  const StripePaymentChargeScreen({super.key, this.product});

  @override
  _StripePaymentChargeScreenState createState() =>
      _StripePaymentChargeScreenState();
}

class _StripePaymentChargeScreenState extends State<StripePaymentChargeScreen> {
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

        await addFeeCharge(data.id);

        // final tokenData = await Stripe.instance.createPaymentMethod(
        //   params: const PaymentMethodParams.card(
        //     paymentMethodData: PaymentMethodData(),
        //   ),
        // );
        print('Token generated: ${data.id}');

        // You can send this token to your backend server to process the payment
      } catch (e) {
        print('Error: $e');

        showSnackBar(context, "Something went wrong");
      }
    }
  }

  PaymentFeeModel? paymentFeeModel;

  addFeeCharge(String token) async {
    setState(() {
      loading = true;
    });
    await PaymentStatusService().addCharge(
        context: context,
        amount: '4',
        currency: 'usd',
        product: widget.product,
        token: token);
    setState(() {
      loading = false;
    });
  }

  getFeeHandler() async {
    await PaymentStatusService().paymentFeeGetService(context: context);
    paymentFeeModel =
        Provider.of<PaymentFeeProvider>(context, listen: false).paymentFeeModel;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeeHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(
        title: 'Payment for Product Listing',
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
