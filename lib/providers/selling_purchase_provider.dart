import 'package:flutter/material.dart';
import 'package:tt_offer/models/selling_products_model.dart';

import '../models/product_model.dart';

class SellingPurchaseProvider extends ChangeNotifier {
  SellingProductsModel? sellingProductsModel;
  List<Product>? soldProductsList;

  bool isLoading = true;

  void updateData({required SellingProductsModel model}) {
    sellingProductsModel = model;
    isLoading = false;
    notifyListeners();
  }

  void updateSoldProductData({required List<Product> soldProductList}) {
    soldProductsList = soldProductList;
    notifyListeners();
  }
}
