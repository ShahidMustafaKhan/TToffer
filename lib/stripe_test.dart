import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CardFieldInputDetails? _cardDetails;
  bool _validCard = false;
  CardEditController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Payment")),
        body: Column(
          children: [
            CardField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              onCardChanged: (card) {
                setState(() {
                  _cardDetails = card;
                  _validCard = card!.complete;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CardField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Expiration Date',
                      border: OutlineInputBorder(),
                    ),
                    onCardChanged: (card) {
                      setState(() {
                        _cardDetails = card;
                        _validCard = card!.complete;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    onCardChanged: (card) {
                      setState(() {
                        _cardDetails = card;
                        _validCard = card!.complete;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void _handlePayment() async {
    if (_cardDetails == null) return;

    try {
      // Create a Payment Method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
                // billingDetails: _cardDetails.
                )),
      );

      log("paymentMethod = ${paymentMethod.id}");
      // Send payment method ID to your backend (example function call)
      // sendPaymentMethodToBackend(paymentMethod.id);
    } catch (e) {
      // Handle exception
      print('Error creating payment method: $e');
    }
  }
}
