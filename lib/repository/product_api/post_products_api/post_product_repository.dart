import 'package:tt_offer/config/app_urls.dart';

import '../../../data/network/network_api_services.dart';
import '../../../models/post_product_model.dart';
import '../../../models/product_detail_model.dart';
import '../../../models/product_model.dart';


class PostProductRepository {

  final _apiServices = NetworkApiService() ;


  Future<PostProductModel> addProductFirstStepApi(dynamic data, List<String> filePath, {String? videoPath})async{
    dynamic response = await _apiServices.postMultiFileApiRequest(AppUrls.baseUrl+AppUrls.addProduct, data, filePath, videoPath: videoPath);
    return PostProductModel.fromJson(response) ;
  }

  // Future<PostProductModel> addProductFirstStepApi(dynamic data, List<String> filePath, {String? videoPath})async{
  //   dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addProduct, data);
  //   return PostProductModel.fromJson(response) ;
  // }

  Future<PostProductModel> addProductSecondStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addProductDetail, data);
    return PostProductModel.fromJson(response) ;
  }

  Future<PostProductModel> addProductThirdStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addProductPrice, data);
    return PostProductModel.fromJson(response) ;
  }

  Future<ProductDetailModel> addProductLastStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.addProductLocation, data);
    return ProductDetailModel.fromJson(response) ;
  }



  Future<PostProductModel> updateProductFirstStepApi(dynamic data, List<String> filePath, {String? videoPath}) async {
    dynamic response = await _apiServices.postMultiFileApiRequest(AppUrls.baseUrl+AppUrls.updateProduct, data, filePath, videoPath: videoPath);
    return PostProductModel.fromJson(response) ;
  }

  Future<PostProductModel> updateProductSecondStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.updateProductDetail, data);
    return PostProductModel.fromJson(response) ;
  }

  Future<PostProductModel> updateProductThirdStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.updateProductPrice, data);
    return PostProductModel.fromJson(response) ;
  }

  Future<ProductDetailModel> updateProductLastStepApi(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.updateProductLocation, data);
    return ProductDetailModel.fromJson(response) ;
  }

  Future<void> deleteImage(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.deleteImage, data);
    return response;
  }

  Future<void> deleteVideo(dynamic data) async {
    dynamic response = await _apiServices.getPostApiResponse(AppUrls.baseUrl+AppUrls.deleteVideo, data);
    return response;
  }


}