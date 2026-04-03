import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/models/product_detail_model.dart';
import 'package:tt_offer/models/product_view_count_model.dart';
import 'package:tt_offer/repository/product_api/get_product_api/get_product_repository.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/inventory_model.dart';
import '../../../models/product_model.dart';

class ProductHttpRepository implements ProductRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<ProductModel> getAuctionProducts(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getAuctionProducts, data);
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> getFeatureProducts(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getFeatureProducts, data);
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> getAllProducts(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getAllProducts, data);
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductDetailModel> getProductDetails(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.getProductDetails, data);
    return ProductDetailModel.fromJson(response);
  }

  @override
  Future<dynamic> rescheduleAuctionTime(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.rescheduleAuctionTime, data);
    return response;
  }

  @override
  Future<dynamic> productReportApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addProductReport, data);
    return response;
  }

  @override
  Future<dynamic> incrementProductView(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addProductView, data);
    return response;
  }

  @override
  Future<ProductViewCountModel> getTotalProductViews(int? productId) async {
    dynamic response = await _apiServices
        .getGetApiResponse("${AppUrls.baseUrl}products/$productId/views");
    return ProductViewCountModel.fromJson(response);
  }

  @override
  Future<InventoryModel> productInventory(int? productId) async {
    dynamic response = await _apiServices.getGetApiResponse(
        "${AppUrls.baseUrl + AppUrls.getProductInventory}$productId");
    return InventoryModel.fromJson(response);
  }
}
