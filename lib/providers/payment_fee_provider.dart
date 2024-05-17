import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/payment_fee_model.dart';

class PaymentFeeProvider extends ChangeNotifier {
  PaymentFeeModel? paymentFeeModel;

  getPayment({required PaymentFeeModel newPaymentFeeModel}) {
    paymentFeeModel = newPaymentFeeModel;
    notifyListeners();
  }
}
