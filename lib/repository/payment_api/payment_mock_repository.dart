import 'package:tt_offer/models/payment_card_model.dart';
import 'package:tt_offer/models/subscription_model.dart';
import 'package:tt_offer/repository/payment_api/payment_repository.dart';

class PaymentMockRepository implements PaymentRepository {
  @override
  Future<dynamic> sellFasterApi(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<dynamic> googlePayApi(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<dynamic> createPaymentIntent(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<dynamic> stripePaymentCharge(dynamic data) async {
    dynamic response = {
      "data": {"latest_charge": "123456789"}
    };
    return response;
  }

  @override
  Future<dynamic> googlePayment(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<dynamic> addNewCard(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<PaymentCardsModel> getAllCard(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return PaymentCardsModel(
      data: [
        PaymentCard(
          id: 1,
          brand: "visa",
        ),
        PaymentCard(
          id: 2,
          brand: "MasterCard",
        ),
      ],
    );
  }

  @override
  Future<PaymentCardDetailModel> getCardDetail(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return PaymentCardDetailModel(
      data: PaymentCard(
        id: 1,
        userId: 1,
        brand: "visa",
        createdAt: DateTime.now().toString(),
      ),
    );
  }

  @override
  Future<SubscriptionModel> getAllSubscription() async {
    await Future.delayed(const Duration(seconds: 1));
    return SubscriptionModel(data: [
      Subscription(
          id: 1,
          title: "Basic",
          shortDescription: "Basic Subscription",
          price: 100,
          duration: 5,
          durationType: "month",
          productLimit: 10),
      Subscription(
          id: 2,
          title: "Standard",
          shortDescription: "Standard Subscription",
          price: 200,
          duration: 10,
          durationType: "month",
          productLimit: 20),
      Subscription(
          id: 3,
          title: "Premium",
          shortDescription: "Premium Subscription",
          price: 300,
          duration: 15,
          durationType: "month",
          productLimit: 30),
    ]);
  }
}
