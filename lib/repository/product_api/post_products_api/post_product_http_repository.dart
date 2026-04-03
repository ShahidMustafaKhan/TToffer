import 'package:tt_offer/config/app_urls.dart';
import 'package:tt_offer/repository/product_api/post_products_api/post_product_repository.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/post_product_model.dart';
import '../../../models/product_detail_model.dart';

class PostProductHttpRepository implements PostProductRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<PostProductModel> addProductFirstStepApi(
      dynamic data, List<String> filePath,
      {String? videoPath}) async {
    dynamic response = await _apiServices.postMultiFileApiRequest(
        AppUrls.baseUrl + AppUrls.addProduct, data, filePath,
        videoPath: videoPath);
    return PostProductModel.fromJson(response);
  }

  @override
  Future<PostProductModel> addProductSecondStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addProductDetail, data);
    return PostProductModel.fromJson(response);
  }

  @override
  Future<PostProductModel> addProductThirdStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addProductPrice, data);
    return PostProductModel.fromJson(response);
  }

  @override
  Future<ProductDetailModel> addProductLastStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.addProductLocation, data);
    return ProductDetailModel.fromJson(response);
  }

  @override
  Future<PostProductModel> updateProductFirstStepApi(
      dynamic data, List<String> filePath,
      {String? videoPath}) async {
    dynamic response = await _apiServices.postMultiFileApiRequest(
        AppUrls.baseUrl + AppUrls.updateProduct, data, filePath,
        videoPath: videoPath);
    return PostProductModel.fromJson(response);
  }

  @override
  Future<PostProductModel> updateProductSecondStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.updateProductDetail, data);
    return PostProductModel.fromJson(response);
  }

  @override
  Future<PostProductModel> updateProductThirdStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.updateProductPrice, data);
    return PostProductModel.fromJson(response);
  }

  @override
  Future<ProductDetailModel> updateProductLastStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.updateProductLocation, data);
    return ProductDetailModel.fromJson(response);
  }

  @override
  Future<void> deleteImage(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.deleteImage, data);
    return response;
  }

  @override
  Future<void> deleteVideo(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(
        AppUrls.baseUrl + AppUrls.deleteVideo, data);
    return response;
  }
}
