import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/models/shipping_detail_model.dart';

abstract class CartRepository {
  Future<CartModel> getCartItemsApi(int? userId);

  Future<dynamic> addCartItemApi(dynamic data);

  Future<dynamic> removeCartItemApi(dynamic data);

  Future<ShippingDetailModel> getLastSaveAddress();

  Future<dynamic> saveAddress(dynamic data);

  Future<dynamic> fetchCountries();

  Future<dynamic> fetchCities(dynamic data);

  Future<dynamic> addOrder(dynamic data);
}
