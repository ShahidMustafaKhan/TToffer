import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CardHomeScreen extends StatefulWidget {
  @override
  _CardHomeScreenState createState() => _CardHomeScreenState();
}

class _CardHomeScreenState extends State<CardHomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CardFieldInputDetails? _card;

  void _handlePayPress() async {
    if (_formKey.currentState?.validate() == true && _card != null) {
      try {
        final tokenData = await Stripe.instance.createPaymentMethod(
          params: const PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(
                email: 'email@example.com',
              ),
            ),
          ),
        );
        print('Token generated: ${tokenData.id}');
        // You can send this token to your backend server to process the payment
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                    borderWidth: 1),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handlePayPress,
                child: const Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
