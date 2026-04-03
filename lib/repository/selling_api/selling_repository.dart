import '../../models/selling_products_model.dart';

abstract class SellingRepository {
  Future<SellingProductsModel> getSellingProducts();

  Future<dynamic> markSold(dynamic data);
}
