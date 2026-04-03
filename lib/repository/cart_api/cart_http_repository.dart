import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/models/shipping_detail_model.dart';

import '../../../data/network/network_api_services.dart';
import 'cart_repository.dart';

class CartHttpRepository implements CartRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<CartModel> getCartItemsApi(int? userId) async {
    dynamic response = await _apiServices
        .getGetApiResponse("${AppUrls.baseUrl + AppUrls.getCartItems}/$userId");
    return CartModel.fromJson(response);
  }

  @override
  Future<dynamic> addCartItemApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addCart, data);
    return response;
  }

  @override
  Future<dynamic> removeCartItemApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.removeCart, data);
    return response;
  }

  @override
  Future<ShippingDetailModel> getLastSaveAddress() async {
    dynamic response = await _apiServices
        .getGetApiResponse(AppUrls.baseUrl + AppUrls.getLastAddress);
    return ShippingDetailModel.fromJson(response);
  }

  @override
  Future<dynamic> saveAddress(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.saveAddress, data);
    return response;
  }

  @override
  Future<dynamic> fetchCountries() async {
    dynamic response = await _apiServices
        .getGetApiResponse(AppUrls.baseUrl + AppUrls.getCountries);
    return response;
  }

  @override
  Future<dynamic> fetchCities(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getCities, data);
    return response;
  }

  @override
  Future<dynamic> addOrder(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addOrder, data);
    return response;
  }
}
