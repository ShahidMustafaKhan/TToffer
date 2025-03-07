import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/cart_model.dart';
import 'package:tt_offer/models/shipping_detail_model.dart';

import '../../../data/network/network_api_services.dart';



class CartRepository {

  final _apiServices = NetworkApiService() ;

  Future<CartModel> getCartItemsApi(int? userId)async{
    dynamic response = await _apiServices.getGetApiResponse("${AppUrls.baseUrl+AppUrls.getCartItems}/$userId");
    return CartModel.fromJson(response) ;
  }

  Future<dynamic> addCartItemApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addCart, data);
    return response ;
  }

  Future<dynamic> removeCartItemApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.removeCart, data);
    return response ;
  }

  Future<ShippingDetailModel> getLastSaveAddress() async{
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getLastAddress);
    return ShippingDetailModel.fromJson(response);
  }

  Future<dynamic> saveAddress(dynamic data) async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.saveAddress, data);
    return response ;
  }

  Future<dynamic> fetchCountries() async{
    dynamic response = await _apiServices.getGetApiResponse(AppUrls.baseUrl+AppUrls.getCountries);
    return response ;
  }

  Future<dynamic> fetchCities(dynamic data) async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.getCities, data);
    return response ;
  }

  Future<dynamic> addOrder(dynamic data) async{
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addOrder, data);
    return response ;
  }






}