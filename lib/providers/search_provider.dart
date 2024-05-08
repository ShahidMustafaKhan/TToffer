import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/selling_products_model.dart';

class SearchProvider extends ChangeNotifier {
  List<Selling> selling = [];

  void getSellingData({required List<Selling> newSelling}) {
    selling = newSelling;
    notifyListeners();
  }

  void clearSellingData() {
    selling.clear();
    notifyListeners();
  }
}