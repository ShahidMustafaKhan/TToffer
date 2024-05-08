import 'package:flutter/cupertino.dart';
import 'package:tt_offer/models/selling_products_model.dart';

class SearchProvider extends ChangeNotifier {
  List<Selling> selling = [];

  void getSellingData({required List<Selling> newSelling}) {
    selling = newSelling;
    notifyListeners(); // Notify listeners when data changes
  }

  void clearSellingData() {
    selling.clear();
    notifyListeners(); // Notify listeners when data is cleared
  }
}
