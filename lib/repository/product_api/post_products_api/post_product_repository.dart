import '../../../models/post_product_model.dart';
import '../../../models/product_detail_model.dart';

abstract class PostProductRepository {
  Future<PostProductModel> addProductFirstStepApi(
      dynamic data, List<String> filePath,
      {String? videoPath});

  Future<PostProductModel> addProductSecondStepApi(dynamic data);

  Future<PostProductModel> addProductThirdStepApi(dynamic data);

  Future<ProductDetailModel> addProductLastStepApi(dynamic data);

  Future<PostProductModel> updateProductFirstStepApi(
      dynamic data, List<String> filePath,
      {String? videoPath});

  Future<PostProductModel> updateProductSecondStepApi(dynamic data);

  Future<PostProductModel> updateProductThirdStepApi(dynamic data);

  Future<ProductDetailModel> updateProductLastStepApi(dynamic data);

  Future<void> deleteImage(dynamic data);

  Future<void> deleteVideo(dynamic data);
}
