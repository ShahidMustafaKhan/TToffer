import 'package:tt_offer/models/product_detail_model.dart';
import 'package:tt_offer/models/product_view_count_model.dart';
import 'package:tt_offer/repository/product_api/get_product_api/get_product_repository.dart';

import '../../../mock/product_mock_data.dart';
import '../../../models/inventory_model.dart';
import '../../../models/product_model.dart';

class ProductMockRepository implements ProductRepository {
  @override
  Future<ProductModel> getAuctionProducts(dynamic data) async {
    return ProductModel(data: Data(productList: getMockAuctionProducts()));
  }

  @override
  Future<ProductModel> getFeatureProducts(dynamic data) async {
    return ProductModel(data: Data(productList: getMockFeatureProducts()));
  }

  @override
  Future<ProductModel> getAllProducts(data) {
    throw UnimplementedError();
  }

  @override
  Future<ProductDetailModel> getProductDetails(data) async {
    await Future.delayed(const Duration(seconds: 2));
    return ProductDetailModel(product: getMockProductById(data['product_id']));
  }

  @override
  Future<ProductViewCountModel> getTotalProductViews(int? productId) {
    throw UnimplementedError();
  }

  @override
  Future incrementProductView(data) {
    throw UnimplementedError();
  }

  @override
  Future<InventoryModel> productInventory(int? productId) async {
    await Future.delayed(const Duration(seconds: 1));
    return InventoryModel(
      inventory: Inventory(
          availableStock: 10,
          totalStock: 10,
          thresholdLowStock: 10,
          productId: productId),
    );
  }

  @override
  Future productReportApi(data) {
    throw UnimplementedError();
  }

  @override
  Future rescheduleAuctionTime(data) {
    throw UnimplementedError();
  }
}
