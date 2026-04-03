import 'package:tt_offer/models/product_detail_model.dart';
import 'package:tt_offer/models/product_view_count_model.dart';

import '../../../models/inventory_model.dart';
import '../../../models/product_model.dart';

abstract class ProductRepository {
  Future<ProductModel> getAuctionProducts(dynamic data);

  Future<ProductModel> getFeatureProducts(dynamic data);

  Future<ProductModel> getAllProducts(dynamic data);

  Future<ProductDetailModel> getProductDetails(dynamic data);

  Future<dynamic> rescheduleAuctionTime(dynamic data);

  Future<dynamic> productReportApi(dynamic data);

  Future<dynamic> incrementProductView(dynamic data);

  Future<ProductViewCountModel> getTotalProductViews(int? productId);

  Future<InventoryModel> productInventory(int? productId);
}
