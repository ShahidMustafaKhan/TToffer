import 'package:tt_offer/models/payment_card_model.dart';
import 'package:tt_offer/models/subscription_model.dart';

abstract class PaymentRepository {
  Future<dynamic> sellFasterApi(dynamic data);

  Future<dynamic> googlePayApi(dynamic data);

  Future<dynamic> createPaymentIntent(dynamic data);

  Future<dynamic> stripePaymentCharge(dynamic data);

  Future<dynamic> googlePayment(dynamic data);

  Future<dynamic> addNewCard(dynamic data);

  Future<PaymentCardsModel> getAllCard(dynamic data);

  Future<PaymentCardDetailModel> getCardDetail(dynamic data);

  Future<SubscriptionModel> getAllSubscription();
}
