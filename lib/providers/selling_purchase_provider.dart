import 'package:flutter/material.dart';
import 'package:tt_offer/models/selling_products_model.dart';

class SellingPurchaseProvider extends ChangeNotifier {
  SellingProductsModel? sellingProductsModel;

  bool isLoading = true;

  void updateData({required SellingProductsModel model}) {
    sellingProductsModel = model;
    isLoading = false;
    notifyListeners();
  }
}
