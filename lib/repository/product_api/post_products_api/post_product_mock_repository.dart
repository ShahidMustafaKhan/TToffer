import 'package:tt_offer/repository/product_api/post_products_api/post_product_repository.dart';

import '../../../mock/user_mock_data.dart';
import '../../../models/post_product_model.dart';
import '../../../models/product_detail_model.dart';
import '../../../models/product_model.dart' hide Data;

class PostProductMockRepository implements PostProductRepository {
  @override
  Future<PostProductModel> addProductFirstStepApi(
      dynamic data, List<String> filePath,
      {String? videoPath}) async {
    await Future.delayed(const Duration(seconds: 1));
    return PostProductModel(data: Data(productId: 7));
  }

  @override
  Future<PostProductModel> addProductSecondStepApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return PostProductModel(data: Data(productId: 7));
  }

  @override
  Future<PostProductModel> addProductThirdStepApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return PostProductModel(data: Data(productId: 7));
  }

  @override
  Future<ProductDetailModel> addProductLastStepApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return ProductDetailModel(
        product: Product(
      id: 7,
      title: "Test Product",
      description: "Test Product",
      fixPrice: 1000,
      productType: "featured",
      photo: [
        Photo(
          url:
              "https://images.pexels.com/photos/1595476/pexels-photo-1595476.jpeg?auto=compress&cs=tinysrgb&w=300",
        )
      ],
      user: getMockUserById(3),
      userId: getMockUserById(3).id,
    ));
  }

  @override
  Future<PostProductModel> updateProductFirstStepApi(
      dynamic data, List<String> filePath,
      {String? videoPath}) async {
    await Future.delayed(const Duration(seconds: 1));
    return PostProductModel(data: Data(productId: 7));
  }

  @override
  Future<PostProductModel> updateProductSecondStepApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return PostProductModel(data: Data(productId: 7));
  }

  @override
  Future<PostProductModel> updateProductThirdStepApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return PostProductModel(data: Data(productId: 7));
  }

  @override
  Future<ProductDetailModel> updateProductLastStepApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 1));
    return ProductDetailModel(
        product: Product(
      id: 7,
      title: "Test Product",
      description: "Test Product",
      fixPrice: 1000,
      productType: "featured",
      photo: [
        Photo(
          url:
              "https://images.pexels.com/photos/1595476/pexels-photo-1595476.jpeg?auto=compress&cs=tinysrgb&w=300",
        )
      ],
      user: getMockUserById(3),
      userId: getMockUserById(3).id,
    ));
  }

  @override
  Future<void> deleteImage(dynamic data) async {
    dynamic response = {};
    return response;
  }

  @override
  Future<void> deleteVideo(dynamic data) async {
    dynamic response = {};
    return response;
  }
}
