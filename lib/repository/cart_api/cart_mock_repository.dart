import 'package:tt_offer/mock/product_mock_data.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/models/shipping_detail_model.dart';

import 'cart_repository.dart';

class CartMockRepository implements CartRepository {
  @override
  Future<CartModel> getCartItemsApi(int? userId) async {
    await Future.delayed(const Duration(seconds: 2));
    return CartModel(data: [
      Cart(
        id: 1,
        product: getMockProductById(2),
        productId: getMockProductById(2).id,
        user: getMockProductById(2).user,
        userId: getMockProductById(2).userId,
      ),
      Cart(
        id: 2,
        product: getMockProductById(1),
        productId: getMockProductById(1).id,
        user: getMockProductById(1).user,
        userId: getMockProductById(1).userId,
      )
    ]);
  }

  @override
  Future<dynamic> addCartItemApi(dynamic data) async {
    dynamic response = {};
    await Future.delayed(const Duration(seconds: 2));
    return response;
  }

  @override
  Future<dynamic> removeCartItemApi(dynamic data) async {
    dynamic response = {};
    await Future.delayed(const Duration(seconds: 2));
    return response;
  }

  @override
  Future<ShippingDetailModel> getLastSaveAddress() async {
    await Future.delayed(const Duration(seconds: 2));
    return ShippingDetailModel(
        data: Shipping(
      id: 1,
      userId: 1,
      address: "123 Main Street, Anytown, USA",
      city: City(id: 1, name: "New York"),
      country: City(id: 1, name: "USA"),
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      state: "NY",
      zipCode: "10001",
      phoneNo: "123-456-7890",
    ));
  }

  @override
  Future<dynamic> saveAddress(dynamic data) async {
    dynamic response = {};
    await Future.delayed(const Duration(seconds: 2));
    return response;
  }

  @override
  Future<dynamic> fetchCountries() async {
    dynamic response = {};
    await Future.delayed(const Duration(seconds: 2));
    return response;
  }

  @override
  Future<dynamic> fetchCities(dynamic data) async {
    dynamic response = {};
    await Future.delayed(const Duration(seconds: 2));
    return response;
  }

  @override
  Future<dynamic> addOrder(dynamic data) async {
    dynamic response = {
      "data": {
        "order": {"order_number": "123456789"}
      }
    };
    await Future.delayed(const Duration(seconds: 2));
    return response;
  }
}
